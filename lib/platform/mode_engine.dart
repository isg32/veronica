import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/models/models.dart';
import '../data/providers.dart';
import 'android_usage.dart';
import 'reminders.dart';

part 'mode_engine.g.dart';

const _channel = MethodChannel('veronica/modes');

/// What the phone should do while [mode] runs (see `PhoneControl.kt`).
Map<String, Object?> modeConfig(Mode mode) => {
  'greyscale': mode.greyscale,
  'dnd': mode.dnd.name,
  'hideNotifications': mode.hideNotifications,
  'brightness': mode.brightness,
  'ringer': mode.ringer?.name,
  'media': mode.mediaVolume,
  'blackWallpaper': mode.blackWallpaper,
};

/// The native copy of [mode] (see `ModeState.kt`), running when [active].
Map<String, Object?> nativeMode(Mode mode, {ActiveMode? active}) => {
  'id': mode.id,
  'name': mode.name,
  'started': ?active?.startedAt.millisecondsSinceEpoch,
  'ends': ?active?.endsAt?.millisecondsSinceEpoch,
  'config': modeConfig(mode),
  'policy': mode.appPolicy.name,
  'blocked': mode.blockedApps.toList(),
  'nudgeAfter': mode.nudgeAfterMin,
};

/// Keeps the phone in step with the running mode:
/// - starting a mode applies it natively (greyscale, Do Not Disturb, …) and
///   arms its "Time's up"; ending it restores the phone;
/// - mode schedules are armed as exact alarms that work with the app closed;
/// - a mode a schedule started or ended while the app was away is picked up
///   when the app starts or comes back.
@Riverpod(keepAlive: true)
void modeEngine(Ref ref) {
  if (!isAndroid) return;
  String? lastSent;

  Future<void> push() async {
    final active = ref.read(activeModeProvider).value;
    final modes = ref.read(modesProvider).value;
    if (modes == null) return;
    final mode = active == null
        ? null
        : modes.where((m) => m.id == active.modeId).firstOrNull;
    final json = mode == null
        ? null
        : jsonEncode(nativeMode(mode, active: active));
    final signature = json ?? 'none';
    if (signature == lastSent) return;
    lastSent = signature;
    await _channel.invokeMethod<void>('setActive', json);
  }

  Future<void> pushSchedules() async {
    final modes = ref.read(modesProvider).value;
    final sleep = ref.read(sleepScheduleProvider).value;
    if (modes == null) return;
    final scheduled = [
      // Wind-down overrides any mode, every night.
      ?(sleep == null ? null : windDownSchedule(sleep)),
      for (final m in modes.where((m) => m.schedule != null))
        {
          ...nativeMode(m),
          'days': m.schedule!.days.toList(),
          'start': m.schedule!.start.label,
          'end': m.schedule!.end?.label,
        },
    ];
    await _channel.invokeMethod<void>('setSchedules', jsonEncode(scheduled));
  }

  /// Adopts a mode the native side started or ended on its own.
  Future<void> reconcile() async {
    final raw = await _channel.invokeMethod<String>('getActive');
    final native = raw == null ? null : jsonDecode(raw) as Map<String, Object?>;
    final current = await ref.read(modeRepositoryProvider).watchActive().first;
    final nativeId = native?['id'] as String?;
    if (nativeId == current?.modeId) return;
    final adopted = native == null
        ? null
        : ActiveMode(
            modeId: nativeId!,
            startedAt: DateTime.fromMillisecondsSinceEpoch(
              (native['started'] as num?)?.toInt() ??
                  DateTime.now().millisecondsSinceEpoch,
            ),
            endsAt: native['ends'] is num
                ? DateTime.fromMillisecondsSinceEpoch(
                    (native['ends']! as num).toInt(),
                  )
                : null,
          );
    // Already applied natively: don't send it back.
    lastSent = null;
    await ref.read(modeRepositoryProvider).adopt(adopted);
  }

  ref
    ..listen(activeModeProvider, (_, _) => unawaited(push()))
    ..listen(modesProvider, (_, _) {
      unawaited(push());
      unawaited(pushSchedules());
    }, fireImmediately: true)
    ..listen(
      sleepScheduleProvider,
      (_, _) => unawaited(pushSchedules()),
      fireImmediately: true,
    );

  ref.listen(externalChangesProvider, (_, _) => unawaited(reconcile()));
  final observer = _ResumeObserver(() => unawaited(reconcile()));
  WidgetsBinding.instance.addObserver(observer);
  unawaited(reconcile());
  ref.onDispose(() => WidgetsBinding.instance.removeObserver(observer));
}

class _ResumeObserver with WidgetsBindingObserver {
  _ResumeObserver(this.onResume);

  final VoidCallback onResume;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) onResume();
  }
}
