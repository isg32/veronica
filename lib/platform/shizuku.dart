import 'package:flutter/services.dart';

import 'android_usage.dart';

const _channel = MethodChannel('veronica/shizuku');

/// Where Shizuku setup is, in order.
enum ShizukuStep { notInstalled, notRunning, notPermitted, ready }

/// Greyscale without a computer: Shizuku runs an ADB-level service started
/// from Wireless debugging, through which Veronica grants itself
/// `WRITE_SECURE_SETTINGS` once. See `ShizukuChannel.kt`.
abstract final class Shizuku {
  static Future<ShizukuStep> step() async {
    if (!isAndroid) return ShizukuStep.notInstalled;
    final s = await _channel.invokeMapMethod<String, bool>('status') ?? {};
    if (s['installed'] != true) return ShizukuStep.notInstalled;
    if (s['running'] != true) return ShizukuStep.notRunning;
    if (s['permitted'] != true) return ShizukuStep.notPermitted;
    return ShizukuStep.ready;
  }

  static Future<void> open() => _channel.invokeMethod<void>('openShizuku');

  static Future<void> requestPermission() =>
      _channel.invokeMethod<void>('requestPermission');

  /// Grants greyscale; true when Veronica now holds the permission.
  static Future<bool> grantGreyscale() async =>
      await _channel.invokeMethod<bool>('grantGreyscale') ?? false;
}
