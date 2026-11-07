import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
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
