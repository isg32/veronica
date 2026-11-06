import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:home_widget/home_widget.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../app/router.dart';
import '../app/routes.dart';
import '../data/models/models.dart';
import '../data/providers.dart';
import '../features/home_widgets/home_widget_views.dart';
import 'wallpaper.dart';

part 'home_widgets.g.dart';

/// Home widgets run only on Android (not in tests or on the desktop).
bool get _supported => !kIsWeb && Platform.isAndroid;

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

      for (var i = 0; i < 3; i++) {
        await HomeWidget.saveWidgetData<String>(
          'widget_task_${i}_id',
          i < data.tasks.length ? data.tasks[i].id : null,
        );
        await HomeWidget.saveWidgetData<String>(
          'widget_mode_${i}_id',
          i < data.modes.length ? data.modes[i].id : null,
        );
      }
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
        for (final light in const [false, true]) {
          await HomeWidget.renderFlutterWidget(
            HomeWidgetView(
              kind: kind,
              data: data,
              light: light,
              backdrop: backdrop,
            ),
            key: kind.imageKey(light: light),
            logicalSize: kind.size,
            pixelRatio: ratio,
          );
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

/// Turns taps on the home widgets (`veronica://…` links) into actions.
///
/// | Link | Action |
/// | --- | --- |
/// | `veronica://focus` | open Focus |
/// | `veronica://water/add` | log a glass, open Care |
/// | `veronica://sleep` | open Sleep |
/// | `veronica://mode/<id>` | start that mode |
/// | `veronica://tasks` | open Tasks |
/// | `veronica://task/<id>` | open the task |
/// | `veronica://task/<id>/done` | complete the task |
/// | `veronica://mantra` | start the mantra session |
@Riverpod(keepAlive: true)
void homeWidgetLaunch(Ref ref) {
  if (!_supported) return;

  Future<void> handle(Uri? uri) async {
    if (uri == null || uri.scheme != 'veronica') return;
    final router = ref.read(routerProvider);
    final parts = [uri.host, ...uri.pathSegments];

    switch (parts) {
      case ['focus']:
        router.go(Routes.focus);
      case ['water', 'add']:
        await ref.read(waterRepositoryProvider).logGlass();
        router.go(Routes.care);
      case ['sleep']:
        router.go(Routes.sleep);
      case ['mode', final id]:
        final modes = await ref.read(modeRepositoryProvider).watchModes().first;
        final mode = modes.where((m) => m.id == id).firstOrNull;
        if (mode == null) return;
        await ref
            .read(modeRepositoryProvider)
            .start(
              id,
              minutes: mode.timer == ModeTimer.fixed ? mode.timerMin : null,
            );
        router.go(Routes.today);
        unawaited(router.push(Routes.activeMode));
      case ['tasks']:
        router.go(Routes.tasks);
      case ['task', final id, 'done']:
        await ref.read(taskRepositoryProvider).setDone(id, done: true);
        router.go(Routes.tasks);
      case ['task', final id]:
        router.go(Routes.tasks);
        unawaited(router.push(Routes.task(id)));
      case ['mantra']:
        router.go(Routes.today);
        unawaited(router.push(Routes.mantraSession));
    }
  }

  // Launched cold from a widget: wait for the first frame so the router is up.
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    await handle(await HomeWidget.initiallyLaunchedFromHomeWidget());
  });
  final sub = HomeWidget.widgetClicked.listen(handle);
  ref.onDispose(sub.cancel);
}
