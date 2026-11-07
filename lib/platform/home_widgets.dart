import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:home_widget/home_widget.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../app/router.dart';
import '../app/routes.dart';
import '../data/models/models.dart';
import '../core/theme/v_colors.dart';
import '../core/widgets/v_ink.dart';
import '../data/providers.dart';
import '../features/home_widgets/home_widget_views.dart';
import 'mode_engine.dart';
import 'wallpaper.dart';

part 'home_widgets.g.dart';

/// Home widgets run only on Android (not in tests or on the desktop).
bool get _supported => !kIsWeb && Platform.isAndroid;

/// When a widget's picture changes on its own as time passes: the next
/// alarm's "in 9 h" (hourly, then every 5 minutes in the last two hours) and
/// Binge Time's minutes left (every 5 minutes, then every minute in the last
/// fifteen). Each is rendered ahead as a frame, so the widget stays current
/// with the app closed. Other widgets have a single frame.
List<DateTime> frameTimes(
  HomeWidgetKind kind,
  HomeWidgetSnapshot d,
  DateTime now,
) {
  final times = <DateTime>{now};
  void add(DateTime t) {
    if (t.isAfter(now)) times.add(t);
  }

  switch (kind) {
    case HomeWidgetKind.nextAlarm:
      final at = d.alarmAt;
      if (at == null) break;
      for (var h = 24; h >= 2; h--) {
        add(at.subtract(Duration(hours: h)));
      }
      for (var m = 115; m >= 0; m -= 5) {
        add(at.subtract(Duration(minutes: m)));
      }
    case HomeWidgetKind.modeSwitch:
      final end = d.modes.where((m) => m.active).firstOrNull?.endsAt;
      if (end == null) break;
      for (var m = 120; m > 15; m -= 5) {
        add(end.subtract(Duration(minutes: m)));
      }
      for (var m = 15; m >= 0; m--) {
        add(end.subtract(Duration(minutes: m)));
      }
    default:
      break;
  }
  return times.toList()..sort();
}

/// The pictures a widget needs, as (state, data): the state is the suffix
/// Android picks by (see `VeronicaWidgets.kt`), so a tap shows its result
/// at once, with the app closed:
/// - water: `_w0`…`_w4`, one to four glasses more than now;
/// - mode switch: `_none` and `_m0`…`_m2`, which mode is running;
/// - the rest: a single state, `""`.
List<(String, HomeWidgetSnapshot)> widgetStates(
  HomeWidgetKind kind,
  HomeWidgetSnapshot data,
) => switch (kind) {
  HomeWidgetKind.water => [
    for (var k = 0; k <= 4; k++) ('_w$k', data.variant(water: data.water + k)),
  ],
  HomeWidgetKind.modeSwitch => [
    ('_none', data.variant(active: -1)),
    for (var i = 0; i < data.modes.length; i++)
      ('_m$i', data.variant(active: i)),
  ],
  _ => [('', data)],
};

/// What the native widgets need to act on a tap by themselves.
Future<void> _saveTapData(HomeWidgetSnapshot data, List<Mode> modes) async {
  await HomeWidget.saveWidgetData<int>('widget_water_base', data.water);
  for (var i = 0; i < 3; i++) {
    final widgetMode = i < data.modes.length ? data.modes[i] : null;
    final mode = modes.where((m) => m.id == widgetMode?.id).firstOrNull;
    await HomeWidget.saveWidgetData<String>('widget_mode_${i}_id', mode?.id);
    await HomeWidget.saveWidgetData<String>(
      'widget_mode_${i}_json',
      mode == null
          ? null
          : jsonEncode({
              ...nativeMode(mode),
              if (mode.timer == ModeTimer.fixed) 'timerMin': mode.timerMin,
            }),
    );
  }
  for (var i = 0; i < TaskRows.rendered; i++) {
    final task = i < data.tasks.length ? data.tasks[i] : null;
    await HomeWidget.saveWidgetData<String>('widget_task_${i}_id', task?.id);
    await HomeWidget.saveWidgetData<String>(
      'widget_task_${i}_title',
      task?.title,
    );
  }
}

/// Each task row as its own transparent picture, in both inks.
Future<void> _renderTaskRows(HomeWidgetSnapshot data, double ratio) async {
  for (final (i, task) in data.tasks.indexed) {
    for (final light in const [false, true]) {
      final variant = light ? 'light' : 'dark';
      await HomeWidget.renderFlutterWidget(
        VInkScope(
          ink: light ? VColors.black : VColors.white,
          child: HomeWidgetTaskRow(task: task),
        ),
        key: 'widget_task_${i}_${variant}_image',
        logicalSize: Size(HomeWidgetKind.oldestTasks.size.width, TaskRows.row),
        pixelRatio: ratio,
      );
    }
  }
}

/// Keeps the six native home widgets in step with the app.
///
/// Each widget is drawn from [HomeWidgetView] into a transparent PNG; the
/// native provider shows that image and turns taps into `veronica://` links.
/// Every widget is rendered twice, dark glass and light glass; Android
/// shows the one matching the system theme, so switching light or dark needs
/// no re-render. Widgets re-render when their data or glass settings change,
/// when the app is left or reopened, and once a minute while it runs (for
/// countdowns and "alarm in").
@Riverpod(keepAlive: true)
void homeWidgetSync(Ref ref) {
  if (!_supported) return;

  String? lastSignature;
  var rendering = false;
  var pending = false;
  Timer? debounce;

  Future<void> render() async {
    if (rendering) {
      pending = true;
      return;
    }
    rendering = true;
    try {
      final data = ref.read(homeWidgetSnapshotProvider);
      final glass = await ref.read(widgetGlassControllerProvider.future);

      // Fake blur: the wallpaper, re-read only when it changes.
      final view = PlatformDispatcher.instance.implicitView;
      final screen = view == null
          ? null
          : view.physicalSize / view.devicePixelRatio;
      ui.Image? wallpaper;
      if (glass.style == WidgetGlass.blur && screen != null) {
        await ref.read(wallpaperImageProvider.future);
        await ref.read(wallpaperImageProvider.notifier).refreshIfChanged();
        wallpaper = ref.read(wallpaperImageProvider).value;
      }

      final signature = [
        data.signature,
        glass.signature,
        wallpaper == null ? 'tinted' : identityHashCode(wallpaper),
      ].join('#');
      if (signature == lastSignature) {
        return;
      }
      final ratio =
          PlatformDispatcher.instance.implicitView?.devicePixelRatio ?? 3;

      await _saveTapData(data, ref.read(modesProvider).value ?? const []);

      for (final kind in HomeWidgetKind.values) {
        final backdrop = wallpaper == null || screen == null
            ? null
            : WidgetBackdrop(
                wallpaper: wallpaper,
                screen: screen,
                topLeft: glass
                    .positionOf(kind)
                    .scale(screen.width, screen.height),
              );
        for (final (state, snapshot) in widgetStates(kind, data)) {
          final times = frameTimes(kind, snapshot, DateTime.now());
          for (final light in const [false, true]) {
            final variant = light ? 'light' : 'dark';
            final frames = <Map<String, Object>>[];
            for (final (n, t) in times.indexed) {
              final path = await HomeWidget.renderFlutterWidget(
                HomeWidgetView(
                  kind: kind,
                  data: snapshot,
                  light: light,
                  backdrop: backdrop,
                  now: t,
                  tasksBackgroundOnly: true,
                ),
                key: 'widget_${kind.name}${state}_${variant}_$n',
                logicalSize: kind.size,
                pixelRatio: ratio,
              );
              frames.add({'at': t.millisecondsSinceEpoch, 'path': path});
            }
            await HomeWidget.saveWidgetData<String>(
              'widget_${kind.name}${state}_${variant}_frames',
              jsonEncode(frames),
            );
          }
          // Android redraws at each later frame, with the app closed.
          if (times.length > 1) {
            await HomeWidget.scheduleWidgetUpdates(
              times.skip(1).toList(),
              qualifiedAndroidName: kind.qualifiedAndroidName,
            );
          }
        }
        if (kind == HomeWidgetKind.oldestTasks) {
          await _renderTaskRows(data, ratio);
        }
        await HomeWidget.updateWidget(
          qualifiedAndroidName: kind.qualifiedAndroidName,
        );
      }
      lastSignature = signature;
    } catch (error, stack) {
      debugPrint('Home widget sync failed: $error\n$stack');
    } finally {
      rendering = false;
      if (pending) {
        pending = false;
        unawaited(render());
      }
    }
  }

  void schedule() {
    debounce?.cancel();
    debounce = Timer(const Duration(milliseconds: 800), render);
  }

  ref.listen(
    homeWidgetSnapshotProvider,
    (_, _) => schedule(),
    fireImmediately: true,
  );
  ref
    ..listen(widgetGlassControllerProvider, (_, _) => schedule())
    ..listen(wallpaperImageProvider, (_, _) => schedule());

  final observer = _LifecycleObserver(schedule);
  WidgetsBinding.instance.addObserver(observer);
  final minute = Timer.periodic(const Duration(minutes: 1), (_) => schedule());

  ref.onDispose(() {
    debounce?.cancel();
    minute.cancel();
    WidgetsBinding.instance.removeObserver(observer);
  });
}

class _LifecycleObserver with WidgetsBindingObserver {
  _LifecycleObserver(this.onChange);

  final VoidCallback onChange;

  @override
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Leaving: make sure the widgets are current. Coming back: the wallpaper
    // may have changed, or wallpaper access was just granted.
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.resumed) {
      onChange();
    }
  }
}

/// Opens the app where a home widget points (`veronica://…` links). Taps
/// that change something (+1 glass, a mode, a task) are handled by Android
/// without opening the app (see `WidgetActions.kt`).
///
/// | Link | Opens |
/// | --- | --- |
/// | `veronica://focus` | Focus |
/// | `veronica://care` | Care |
/// | `veronica://sleep` | Sleep |
/// | `veronica://mantra` | the mantra session |
@Riverpod(keepAlive: true)
void homeWidgetLaunch(Ref ref) {
  if (!_supported) return;

  void handle(Uri? uri) {
    if (uri == null || uri.scheme != 'veronica') return;
    final router = ref.read(routerProvider);
    switch (uri.host) {
      case 'focus':
        router.go(Routes.focus);
      case 'care':
        router.go(Routes.care);
      case 'sleep':
        router.go(Routes.sleep);
      case 'mantra':
        router.go(Routes.today);
        unawaited(router.push(Routes.mantraSession));
    }
  }

  // Launched cold from a widget: wait for the first frame so the router is up.
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    handle(await HomeWidget.initiallyLaunchedFromHomeWidget());
  });
  final sub = HomeWidget.widgetClicked.listen(handle);
  ref.onDispose(sub.cancel);
}
