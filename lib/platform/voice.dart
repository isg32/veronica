import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:isolate';

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

/// Kokoro v1.0 (int8) for sherpa-onnx, from the sherpa-onnx author's
/// Hugging Face repository, which is far faster than GitHub releases.
/// Only the English files are fetched, about 150 MB, once. It is the only
/// thing Veronica downloads.
const kokoroRepo =
    'https://huggingface.co/csukuangfj/kokoro-int8-multi-lang-v1_0/resolve/main';
const _modelDir = 'kokoro-int8-multi-lang-v1_0';

/// The model's files; the first (the large model) shows the notification.
const _modelFiles = [
  'model.int8.onnx',
  'voices.bin',
  'tokens.txt',
  'lexicon-us-en.txt',
];

/// Speaker ids in Kokoro v1.0 (from the model's metadata): 2 af_bella,
/// 3 af_heart, 6 af_nicole, 21 bf_emma.
int kokoroSpeaker(KokoroVoice v) => switch (v) {
  KokoroVoice.afHeart => 3,
  KokoroVoice.afBella => 2,
  KokoroVoice.afNicole => 6,
  KokoroVoice.bfEmma => 21,
};

/// Rendered lines are kept here.
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

  static Future<bool> _installed() async {
    final dir = await modelDirectory();
    return dir != null && File('${dir.path}/.complete').existsSync();
  }

  /// The earlier model (Kokoro v0.19, from GitHub), no longer used.
  static Future<void> _dropOldModel() async {
    final root = await _root();
    for (final name in ['kokoro-en-v0_19', 'kokoro.tar.bz2']) {
      final path = '${root.path}/$name';
      switch (FileSystemEntity.typeSync(path)) {
        case FileSystemEntityType.directory:
          await Directory(path).delete(recursive: true);
        case FileSystemEntityType.file:
          await File(path).delete();
        default:
          break;
      }
    }
  }

  @override
  Future<({VoiceModelState state, double progress})> build() async {
    ref.onDispose(() => _poll?.cancel());
    if (!isAndroid) {
      return (state: VoiceModelState.notDownloaded, progress: 0.0);
    }
    unawaited(_dropOldModel().catchError((Object _) {}));
    if (await _installed()) {
      return (state: VoiceModelState.ready, progress: 1.0);
    }
    return _check();
  }

  /// Starts (or rejoins) the background download.
  Future<void> download() async {
    await _download.invokeMethod<void>(
      'start',
      jsonEncode([
        for (final (i, f) in _modelFiles.indexed)
          {
            'url': '$kokoroRepo/$f',
            'path': 'voice/$_modelDir/$f',
            'visible': i == 0,
          },
      ]),
    );
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

  /// Where the system download is; marks the model ready once every
  /// file has arrived.
  Future<({VoiceModelState state, double progress})> _check() async {
    final status = await _download.invokeMapMethod<String, Object?>('status');
    final received = (status?['received'] as num?)?.toDouble() ?? 0;
    final total = (status?['total'] as num?)?.toDouble() ?? 0;
    switch (status?['state']) {
      case 'running':
        _watch();
        return (
          state: VoiceModelState.downloading,
          progress: total > 0 ? received / total : 0.0,
        );
      case 'done':
        final dir = await modelDirectory();
        final complete =
            dir != null &&
            _modelFiles.every((f) => File('${dir.path}/$f').existsSync());
        if (complete) {
          await File('${dir.path}/.complete').writeAsString('ok');
          await _download.invokeMethod<void>('forget', false);
          return (state: VoiceModelState.ready, progress: 1.0);
        }
        await _download.invokeMethod<void>('forget', true);
        return (state: VoiceModelState.notDownloaded, progress: 0.0);
      case 'failed':
        await _download.invokeMethod<void>('forget', true);
        return (state: VoiceModelState.notDownloaded, progress: 0.0);
      default:
        return (state: VoiceModelState.notDownloaded, progress: 0.0);
    }
  }
}

/// Where the model's files are (the app's external files folder).
Future<Directory?> modelDirectory() async {
  final base = await getExternalStorageDirectory();
  return base == null ? null : Directory('${base.path}/voice/$_modelDir');
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
          model: '$modelDir/model.int8.onnx',
          voices: '$modelDir/voices.bin',
          tokens: '$modelDir/tokens.txt',
          lexicon: '$modelDir/lexicon-us-en.txt',
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
        modelDir: (await modelDirectory())!.path,
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
