import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../app/router.dart';
import '../data/models/models.dart';
import '../data/providers.dart';
import 'android_usage.dart';

part 'watcher.g.dart';

const _channel = MethodChannel('veronica/watcher');

/// The app's side of the native watcher (an accessibility service).
/// See `android/.../watcher/`.
abstract final class Watcher {
  /// Whether the watcher is turned on in Accessibility settings.
  static Future<bool> enabled() async =>
      !isAndroid || (await _channel.invokeMethod<bool>('isEnabled') ?? false);

  static Future<void> openSettings() async {
    if (isAndroid) await _channel.invokeMethod<void>('openSettings');
  }

  static Future<bool> canNotify() async =>
      !isAndroid || (await _channel.invokeMethod<bool>('canNotify') ?? false);

  static Future<void> requestNotify() async {
    if (isAndroid) await _channel.invokeMethod<void>('requestNotify');
  }

  /// Keeps the watcher quiet for [packageName] for [minutes].
  static Future<void> grantGrace(String packageName, {int minutes = 5}) async {
    if (!isAndroid) return;
    await _channel.invokeMethod<void>('grantGrace', {
      'packageName': packageName,
      'minutes': minutes,
    });
  }

  /// Sends the user to the home screen.
  static Future<void> goHome() async {
    if (isAndroid) await _channel.invokeMethod<void>('goHome');
  }

  /// Leaves Veronica and returns to whatever app was in front before.
  static Future<void> returnToApp() => SystemNavigator.pop();
}

/// Keeps the watcher's copy of the rules in step with the watched apps.
@Riverpod(keepAlive: true)
void watcherRulesSync(Ref ref) {
  if (!isAndroid) return;
  ref.listen(watchedAppsProvider, (_, next) {
    final apps = next.value;
    if (apps == null) return;
    final json = jsonEncode({
      for (final WatchedApp a in apps)
        a.packageName: {
          'name': a.name,
          'limit': a.dailyLimitMin,
          'nudge': a.nudgeAtPercent,
          'hard': a.hardBlock,
          'extLeft': a.extensionsLeft,
        },
    });
    unawaited(_channel.invokeMethod<void>('setRules', json));
  }, fireImmediately: true);
}

/// Opens the pages the watcher asks for (Put it down, Focus).
@Riverpod(keepAlive: true)
void watcherRoutes(Ref ref) {
  if (!isAndroid) return;

  void open(String route) {
    final router = ref.read(routerProvider);
    if (route.startsWith('/now/')) {
      unawaited(router.push(route));
    } else {
      router.go(route);
    }
  }

  _channel.setMethodCallHandler((call) async {
    if (call.method == 'route') {
      // Delivered now; drop the copy kept for a cold start.
      await _channel.invokeMethod<String>('takeRoute');
      open(call.arguments as String);
    }
  });
  // Opened by the watcher before Flutter was running.
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    final route = await _channel.invokeMethod<String>('takeRoute');
    if (route != null) open(route);
  });
  ref.onDispose(() => _channel.setMethodCallHandler(null));
}

/// The watcher's setup, in the order to fix it.
enum WatcherSetup { usageAccess, accessibility, notifications, ready }

@riverpod
Future<WatcherSetup> watcherSetup(Ref ref) async {
  if (!await UsageAccess.granted()) return WatcherSetup.usageAccess;
  if (!await Watcher.enabled()) return WatcherSetup.accessibility;
  if (!await Watcher.canNotify()) return WatcherSetup.notifications;
  return WatcherSetup.ready;
}
