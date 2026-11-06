import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/models/models.dart';
import '../data/repositories/repositories.dart';

part 'android_usage.g.dart';

bool get isAndroid => !kIsWeb && Platform.isAndroid;

const _channel = MethodChannel('veronica/usage');

/// Minutes and installed apps from Android's usage statistics.
/// See `android/.../usage/UsageChannel.kt`.
class AndroidUsageSource implements UsageSource {
  const AndroidUsageSource();

  @override
  Future<List<InstalledApp>> installedApps() async {
    final raw = await _channel.invokeListMethod<Map<Object?, Object?>>(
      'installedApps',
    );
    return [
      for (final m in raw ?? const <Map<Object?, Object?>>[])
        InstalledApp(
          packageName: m['packageName']! as String,
          name: m['name']! as String,
        ),
    ];
  }

  @override
  Future<Map<String, List<int>>> lastSevenDays(Set<String> packageNames) async {
    final raw = await _channel.invokeMapMethod<String, List<Object?>>(
      'lastSevenDays',
      {'packages': packageNames.toList()},
    );
    return {
      for (final p in packageNames)
        p: [for (final v in raw?[p] ?? const <Object?>[]) (v! as num).toInt()],
    }..updateAll((_, v) => v.length == 7 ? v : const [0, 0, 0, 0, 0, 0, 0]);
  }
}

/// The "Usage access" special permission.
abstract final class UsageAccess {
  static Future<bool> granted() async =>
      !isAndroid || (await _channel.invokeMethod<bool>('hasAccess') ?? false);

  static Future<void> request() async {
    if (isAndroid) await _channel.invokeMethod<void>('requestAccess');
  }
}

/// Whether Veronica can read app usage. Invalidate to re-check.
@riverpod
Future<bool> usageAccess(Ref ref) => UsageAccess.granted();
