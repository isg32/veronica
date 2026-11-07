import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/v_colors.dart';
import '../core/theme/v_palette.dart';
import '../core/theme/v_text.dart';
import '../core/theme/v_theme.dart';
import '../platform/home_widgets.dart';
import '../platform/mode_engine.dart';
import '../platform/reminders.dart';
import '../platform/voice.dart';
import '../platform/watcher.dart';
import 'router.dart';

/// Follows the system light/dark setting; there is no in-app toggle.
class VeronicaApp extends ConsumerWidget {
  const VeronicaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Native home widgets and the usage watcher.
    ref
      ..watch(homeWidgetSyncProvider)
      ..watch(homeWidgetLaunchProvider)
      ..watch(watcherRulesSyncProvider)
      ..watch(watcherRoutesProvider)
      ..watch(modeEngineProvider)
      ..watch(reminderSyncProvider)
      ..watch(voicePrerenderProvider);
    final palette = VPalette.of(context);
    return CupertinoApp.router(
      title: 'Veronica',
      debugShowCheckedModeBanner: false,
      theme: VTheme.of(palette),
      color: palette.paper,
      routerConfig: ref.watch(routerProvider),
      builder: (context, child) {
        final p = VPalette.of(context);
        final icons = p.isDark ? Brightness.light : Brightness.dark;
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: VColors.transparent,
            systemNavigationBarColor: VColors.transparent,
            statusBarIconBrightness: icons,
            systemNavigationBarIconBrightness: icons,
            statusBarBrightness: p.brightness,
          ),
          child: DefaultTextStyle(
            style: VText.body.copyWith(color: p.ink),
            child: ColoredBox(color: p.paper, child: child),
          ),
        );
      },
    );
  }
}
