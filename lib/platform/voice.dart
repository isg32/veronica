import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:archive/archive_io.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sherpa_onnx/sherpa_onnx.dart' as sherpa;

import '../data/models/models.dart';
import '../data/providers.dart';
import 'android_usage.dart';

part 'voice.g.dart';

/// Kokoro English (v0.19) for sherpa-onnx, downloaded once from the
/// sherpa-onnx releases. It is the only thing Veronica fetches from the
/// network.
const kokoroUrl =
    'https://github.com/k2-fsa/sherpa-onnx/releases/download/tts-models/kokoro-en-v0_19.tar.bz2';
const _modelDir = 'kokoro-en-v0_19';

/// Speaker ids in kokoro-en-v0_19: 0 af, 1 af_bella, 2 af_nicole, 3 af_sarah,
/// 4 af_sky, 5 am_adam, 6 am_michael, 7 bf_emma, 8 bf_isabella, 9 bm_george,
/// 10 bm_lewis. This model has no af_heart, so its default warm voice "af"
/// stands in for it.
int kokoroSpeaker(KokoroVoice v) => switch (v) {
  KokoroVoice.afHeart => 0,
  KokoroVoice.afBella => 1,
  KokoroVoice.afNicole => 2,
  KokoroVoice.bfEmma => 7,
};

Future<Directory> _root() async =>
    Directory('${(await getApplicationSupportDirectory()).path}/voice');

const _download = MethodChannel('veronica/voice');

/// Download and readiness of the Kokoro model, with progress.
///
/// Android's DownloadManager fetches it, so the download carries on in the
/// background with its own notification, even if Veronica is closed. When
/// it has finished, the app unpacks it (straight away if open, else the
/// next time it runs).
@Riverpod(keepAlive: true)
class VoiceModel extends _$VoiceModel {
  Timer? _poll;
  bool _unpacking = false;

  static Future<Directory> _modelDir() async =>
      Directory('${(await _root()).path}/$_modelDir');

  static Future<bool> _installed() async {
    final dir = await _modelDir();
    return File('${dir.path}/model.onnx').existsSync() &&
        File('${dir.path}/voices.bin').existsSync();
  }

  @override
  Future<({VoiceModelState state, double progress})> build() async {
    ref.onDispose(() => _poll?.cancel());
    if (!isAndroid) {
      return (state: VoiceModelState.notDownloaded, progress: 0.0);
    }
    if (await _installed()) {
      return (state: VoiceModelState.ready, progress: 1.0);
    }
    return _check();
  }

  /// Starts (or rejoins) the background download.
  Future<void> download() async {
    await _download.invokeMethod<void>('start', kokoroUrl);
    state = const AsyncData((
      state: VoiceModelState.downloading,
      progress: 0.0,
    ));
    _watch();
  }

  void _watch() {
    _poll ??= Timer.periodic(const Duration(seconds: 1), (_) async {
      final next = await _check();
      if (next.state != VoiceModelState.downloading) {
        _poll?.cancel();
        _poll = null;
      }
      state = AsyncData(next);
    });
  }

  /// Where the system download is; unpacks it once it has finished.
  Future<({VoiceModelState state, double progress})> _check() async {
    final status = await _download.invokeMapMethod<String, Object?>('status');
    final received = (status?['received'] as num?)?.toDouble() ?? 0;
    final total = (status?['total'] as num?)?.toDouble() ?? 0;
    switch (status?['state']) {
      case 'pending' || 'running' || 'paused':
        _watch();
        return (
          state: VoiceModelState.downloading,
          // The last 10 % is unpacking.
          progress: total > 0 ? received / total * 0.9 : 0.0,
        );
      case 'done':
        final path = status?['path'] as String?;
        if (path != null && await _unpack(path)) {
          return (state: VoiceModelState.ready, progress: 1.0);
        }
        return (state: VoiceModelState.downloading, progress: 0.92);
      case 'failed':
        await _download.invokeMethod<void>('forget');
        return (state: VoiceModelState.notDownloaded, progress: 0.0);
      default:
        return (state: VoiceModelState.notDownloaded, progress: 0.0);
    }
  }

  /// Unpacks the downloaded archive; true once the model is in place.
  Future<bool> _unpack(String archive) async {
    if (_unpacking) return false;
    _unpacking = true;
    try {
      final root = await _root();
      await root.create(recursive: true);
      final out = root.path;
      await Isolate.run(() => extractFileToDisk(archive, out));
      await _download.invokeMethod<void>('forget');
      return await _installed();
    } on Object catch (e) {
      debugPrint('Voice model unpack failed: $e');
      await _download.invokeMethod<void>('forget');
      return false;
    } finally {
      _unpacking = false;
    }
  }
}

/// Renders [text] to a WAV with Kokoro, off the main isolate.
Future<void> _render({
  required String modelDir,
  required String text,
  required int speaker,
  required double speed,
  required String out,
}) => Isolate.run(() {
  sherpa.initBindings();
  final tts = sherpa.OfflineTts(
    sherpa.OfflineTtsConfig(
      model: sherpa.OfflineTtsModelConfig(
        kokoro: sherpa.OfflineTtsKokoroModelConfig(
          model: '$modelDir/model.onnx',
          voices: '$modelDir/voices.bin',
          tokens: '$modelDir/tokens.txt',
          dataDir: '$modelDir/espeak-ng-data',
        ),
        numThreads: 2,
      ),
    ),
  );
  try {
    final audio = tts.generate(text: text, sid: speaker, speed: speed);
    sherpa.writeWave(
      filename: out,
      samples: audio.samples,
      sampleRate: audio.sampleRate,
    );
  } finally {
    tts.free();
  }
});

/// A stable short hash for cache file names.
String _hash(String s) {
  var h = 0x811c9dc5;
  for (final c in s.codeUnits) {
    h = ((h ^ c) * 0x01000193) & 0xffffffff;
  }
  return h.toRadixString(16);
}

/// Veronica speaking.
///
/// Each line is rendered once with Kokoro and cached, so it plays instantly
/// the next time. Until a line is ready (or without the model) Android's own
/// speech says it, so a moment is never silent.
class VeronicaVoice {
  VeronicaVoice(this._settings);

  final Future<VoiceSettings> Function() _settings;
  final AudioPlayer _player = AudioPlayer();
  final FlutterTts _system = FlutterTts();
  final Set<String> _rendering = {};

  Future<void> say(String text, VoiceMoment moment) async {
    if (!isAndroid || text.trim().isEmpty) return;
    final s = await _settings();
    if (!s.enabled || !s.moments.contains(moment)) return;

    final cached = await _cached(text, s);
    if (cached != null && cached.existsSync()) {
      await _player.setFilePath(cached.path);
      await _player.play();
      return;
    }
    await _system.setSpeechRate(0.45 * s.speed);
    await _system.speak(text);
    if (cached != null) unawaited(_prepare(text, s, cached));
  }

  /// Renders [lines] ahead of time (after the model arrives or settings change).
  Future<void> prerender(List<String> lines, {KokoroVoice? voice}) async {
    if (!isAndroid) return;
    final current = await _settings();
    final s = voice == null ? current : current.copyWith(voice: voice);
    for (final line in lines) {
      final file = await _cached(line, s);
      if (file != null && !file.existsSync()) await _prepare(line, s, file);
    }
  }

  Future<File?> _cached(String text, VoiceSettings s) async {
    if (s.modelState != VoiceModelState.ready) return null;
    final dir = Directory('${(await _root()).path}/lines');
    await dir.create(recursive: true);
    return File('${dir.path}/${_hash('${s.voice.id}|${s.speed}|$text')}.wav');
  }

  Future<void> _prepare(String text, VoiceSettings s, File out) async {
    if (!_rendering.add(out.path)) return;
    try {
      await _render(
        modelDir: '${(await _root()).path}/$_modelDir',
        text: text,
        speaker: kokoroSpeaker(s.voice),
        speed: s.speed,
        out: out.path,
      );
    } on Object catch (e) {
      debugPrint('Voice render failed: $e');
    } finally {
      _rendering.remove(out.path);
    }
  }

  /// Plays a short sample of [voice] at [speed], so a voice can be chosen
  /// by ear. Without the model, Android's own voice reads it.
  Future<void> sample(
    KokoroVoice voice,
    double speed, {
    String name = '',
  }) async {
    if (!isAndroid) return;
    await stop();
    final s = (await _settings()).copyWith(voice: voice, speed: speed);
    final text = sampleLine(name);
    final file = await _cached(text, s);
    if (file == null) {
      await _system.setSpeechRate(0.45 * speed);
      await _system.speak(text);
      return;
    }
    if (!file.existsSync()) await _prepare(text, s, file);
    if (!file.existsSync()) return;
    await _player.setFilePath(file.path);
    await _player.play();
  }

  Future<void> stop() async {
    await _player.stop();
    await _system.stop();
  }
}

@Riverpod(keepAlive: true)
VeronicaVoice veronicaVoice(Ref ref) => VeronicaVoice(
  () => ref.read(settingsRepositoryProvider).watchVoice().first,
);

/// Veronica's fixed lines, with the user's name, rendered ahead so they play
/// instantly.
List<String> fixedLines(String name) {
  final you = name.isEmpty ? '' : ', $name';
  return [
    'Put it down$you.',
    "Time's up. That was your Binge Time.",
    'Good morning$you.',
    'One minute for yourself$you.',
  ];
}

/// What a voice sample says.
String sampleLine(String name) =>
    "Hi${name.isEmpty ? '' : ' $name'}, I'm Veronica. This is how I sound.";

/// Pre-renders the fixed lines once the model is ready, and again when the
/// voice, speed or name changes.
@Riverpod(keepAlive: true)
void voicePrerender(Ref ref) {
  if (!isAndroid) return;
  String? last;
  Future<void> run() async {
    final model = ref.read(voiceModelProvider).value;
    final voice = ref.read(voiceSettingsProvider).value;
    final name = ref.read(profileProvider).value?.name ?? '';
    if (model?.state != VoiceModelState.ready || voice == null) return;
    final key = '${voice.voice.id}|${voice.speed}|$name';
    if (key == last) return;
    last = key;
    await ref.read(veronicaVoiceProvider).prerender(fixedLines(name));
    // A sample in every voice, so choosing one plays at once.
    for (final v in KokoroVoice.values) {
      await ref.read(veronicaVoiceProvider).prerender([
        sampleLine(name),
      ], voice: v);
    }
  }

  ref
    ..listen(voiceModelProvider, (_, _) => unawaited(run()))
    ..listen(voiceSettingsProvider, (_, _) => unawaited(run()))
    ..listen(
      profileProvider,
      (_, _) => unawaited(run()),
      fireImmediately: true,
    );
}
