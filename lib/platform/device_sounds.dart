import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/providers.dart';
import 'android_usage.dart';

part 'device_sounds.g.dart';

const _channel = MethodChannel('veronica/sounds');

/// Lists the phone's own alarm tones in the sound library, once each time
/// the app starts, so alarms can use them without importing anything.
@Riverpod(keepAlive: true)
Future<void> phoneSoundsSync(Ref ref) async {
  if (!isAndroid) return;
  try {
    final raw = await _channel.invokeListMethod<Map<Object?, Object?>>(
      'alarms',
    );
    final tones = [
      for (final t in raw ?? const <Map<Object?, Object?>>[])
        (
          t['title']! as String,
          t['uri']! as String,
          Duration(milliseconds: (t['ms'] as num?)?.toInt() ?? 0),
        ),
    ];
    if (tones.isEmpty) return;
    await ref.read(sleepRepositoryProvider).syncPhoneSounds(tones);
  } on Object catch (e) {
    debugPrint('Phone alarm tones unavailable: $e');
  }
}

/// A sound's audio: a phone tone (`content://`) or a file in the app.
AudioSource audioSourceFor(String path) => path.startsWith('content://')
    ? AudioSource.uri(Uri.parse(path))
    : AudioSource.file(path);

/// Plays one sound at a time so it can be heard before it is chosen.
/// [playing] is the sound playing now, if any.
class SoundPreview extends ValueNotifier<String?> {
  SoundPreview(this._pathOf) : super(null) {
    _player.playerStateStream.listen((s) {
      if (s.processingState == ProcessingState.completed) value = null;
    });
  }

  final Future<String?> Function(String id) _pathOf;
  final AudioPlayer _player = AudioPlayer();

  String? get playing => value;

  /// Plays [id], or stops it if it is already playing.
  Future<void> toggle(String id) async {
    if (value == id) return stop();
    final path = await _pathOf(id);
    if (path == null || path.isEmpty) return;
    value = id;
    try {
      await _player.setAudioSource(audioSourceFor(path));
      unawaited(_player.play());
    } on Object {
      value = null;
    }
  }

  Future<void> stop() async {
    value = null;
    await _player.stop();
  }

  @override
  void dispose() {
    unawaited(_player.dispose());
    super.dispose();
  }
}
