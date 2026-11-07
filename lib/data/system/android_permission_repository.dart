import 'dart:async';

import 'package:flutter/services.dart';

import '../models/models.dart';
import '../repositories/repositories.dart';

/// The phone's real permission state (see `PermissionsChannel.kt`).
///
/// Permissions are granted in system settings, outside the app, so the state
/// is re-read whenever the app comes back to the front and every few seconds
/// while someone is watching.
class AndroidPermissionRepository implements PermissionRepository {
  AndroidPermissionRepository({this.pollEvery = const Duration(seconds: 3)});

  static const _channel = MethodChannel('veronica/permissions');

  final Duration pollEvery;

  static const _names = {
    AppPermission.usageAccess: 'usageAccess',
    AppPermission.accessibility: 'accessibility',
    AppPermission.overlay: 'overlay',
    AppPermission.dnd: 'dnd',
    AppPermission.notifications: 'notifications',
    AppPermission.exactAlarms: 'exactAlarms',
    AppPermission.battery: 'battery',
  };

  Stream<T> _poll<T>(Future<T> Function() read) {
    late final StreamController<T> controller;
    Timer? timer;
    T? last;
    Future<void> tick() async {
      final value = await read();
      if (controller.isClosed || value == last) return;
      last = value;
      controller.add(value);
    }

    controller = StreamController<T>(
      onListen: () {
        unawaited(tick());
        timer = Timer.periodic(pollEvery, (_) => unawaited(tick()));
      },
      onCancel: () => timer?.cancel(),
    );
    return controller.stream;
  }

  Future<Map<AppPermission, bool>> _status() async {
    final raw = await _channel.invokeMapMethod<String, bool>('status') ?? {};
    return {for (final e in _names.entries) e.key: raw[e.value] ?? false};
  }

  @override
  Stream<Map<AppPermission, bool>> watchGranted() =>
      _poll(_status).distinct(_sameMap);

  @override
  Future<void> request(AppPermission permission) =>
      _channel.invokeMethod<void>('request', _names[permission]);

  Future<AdbStatus> _adb() async {
    final raw = await _channel.invokeMapMethod<String, bool>('adb') ?? {};
    final on = raw['glyphDebugOn'] ?? false;
    return AdbStatus(
      greyscaleGranted: raw['greyscale'] ?? false,
      glyphDebugNeeded: raw['glyphDebugNeeded'] ?? false,
      // Android doesn't report when debug mode expires; it lasts 48 hours.
      glyphDebugExpiresAt: on
          ? DateTime.now().add(const Duration(hours: 48))
          : null,
    );
  }

  @override
  Stream<AdbStatus> watchAdb() => _poll(_adb).distinct(
    (a, b) =>
        a.greyscaleGranted == b.greyscaleGranted &&
        a.glyphDebugNeeded == b.glyphDebugNeeded &&
        (a.glyphDebugExpiresAt == null) == (b.glyphDebugExpiresAt == null),
  );

  @override
  Future<void> recheckAdb() async {}

  static bool _sameMap(
    Map<AppPermission, bool> a,
    Map<AppPermission, bool> b,
  ) => a.length == b.length && a.entries.every((e) => b[e.key] == e.value);
}
