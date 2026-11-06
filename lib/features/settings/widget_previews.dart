import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format.dart';
import '../../core/theme/v_colors.dart';
import '../../core/theme/v_text.dart';
import '../../core/widgets/v_ink.dart';
import '../../core/widgets/v_progress.dart';
import '../../core/widgets/v_tiles.dart';
import '../../data/models/models.dart';
import '../../data/providers.dart';
import '../selectors.dart';

/// The six home-screen widgets on Nothing's 4-column grid, drawn in Flutter
/// as a preview. The real widgets are native Android layouts (Phase 4).
/// Tinted glass: no border, black at 40 % (dark) or white at 50 % (light).
class WidgetPreviewGrid extends ConsumerWidget {
  const WidgetPreviewGrid({super.key, this.light = false});

  final bool light;

  static const double cell = 76;
  static const double gap = 8;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ink = light ? VColors.black : VColors.white;
    final tint = light ? VColors.widgetLight : VColors.widgetDark;
    final solid = light ? VColors.white : VColors.black;

    final apps = ref.watch(watchedAppsProvider).value ?? const <WatchedApp>[];
    final used = apps.fold<int>(0, (s, a) => s + a.minutesToday);
    final limit = apps.fold<int>(0, (s, a) => s + a.dailyLimitMin);
    final water = ref.watch(waterTodayProvider).value?.length ?? 0;
    final goal = ref.watch(waterSettingsProvider).value?.goalGlasses ?? 8;
    final next = ref.watch(nextAlarmProvider);
    final now = ref.watch(currentTimeProvider);
    final modes = ref.watch(modesProvider).value ?? const <Mode>[];
    final active = ref.watch(activeModeProvider).value;
    final tasks = ref.watch(openTasksOldestFirstProvider).take(3).toList();
    final mantra = ref.watch(todayMantraProvider);

    double w(int cols) => cols * cell + (cols - 1) * gap;

    Widget box(
      int cols,
      int rows,
      double radius,
      Widget child, {
      EdgeInsets padding = EdgeInsets.zero,
    }) {
      return Container(
        width: w(cols),
        height: w(rows),
        padding: padding,
        decoration: BoxDecoration(
          color: tint,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: child,
      );
    }

    final presets = modes.where((m) => m.isPreset).toList();

    return VInkScope(
      ink: ink,
      child: Wrap(
        spacing: gap,
        runSpacing: gap,
        children: [
          // Screen time, 2×2 circle.
          Container(
            width: w(2),
            height: w(2),
            decoration: BoxDecoration(color: tint, shape: BoxShape.circle),
            child: VRing(
              value: limit == 0 ? 0 : used / limit,
              size: w(2),
              strokeWidth: 5,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'SCREEN TIME',
                    style: VText.inter(10, weight: 500, letterSpacing: 1),
                  ),
                  Text(
                    VFormat.minutes(used),
                    style: VText.doto(28, weight: 900, height: 1.1),
                  ),
                  Text('of ${VFormat.minutes(limit)}', style: VText.inter(11)),
                ],
              ),
            ),
          ),
          SizedBox(
            width: w(2),
            height: w(2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Water, 2×1 pill with +1.
                box(
                  2,
                  1,
                  38,
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$water/$goal',
                              style: VText.doto(16, height: 1),
                            ),
                            const SizedBox(height: 7),
                            VDots(
                              filled: water,
                              total: goal,
                              size: 9,
                              gap: 4,
                              columns: 4,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: solid,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text('+1', style: VText.doto(20, weight: 900)),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.fromLTRB(18, 0, 8, 0),
                ),
                // Next alarm, 2×1.
                box(
                  2,
                  1,
                  30,
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        next == null ? '--:--' : next.alarm.time.label,
                        style: VText.doto(28, weight: 900, height: 1),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        next == null
                            ? 'No alarm'
                            : 'Alarm · ${VFormat.hm(next.at.difference(now))}',
                        style: VText.inter(11),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                ),
              ],
            ),
          ),
          // Mode switch, 4×1.
          box(
            4,
            1,
            38,
            Row(
              children: [
                for (final m in presets)
                  Expanded(
                    flex: m.id == active?.modeId ? 12 : 10,
                    child: Container(
                      height: 60,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        color: m.id == active?.modeId
                            ? solid
                            : VColors.transparent,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            m.name.replaceAll(' Time', ''),
                            style: VText.inter(
                              13,
                              weight: m.id == active?.modeId ? 600 : 500,
                            ),
                          ),
                          if (m.id == active?.modeId && active?.endsAt != null)
                            Text(
                              VFormat.clock(active!.endsAt!.difference(now)),
                              style: VText.doto(13),
                            ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            padding: const EdgeInsets.all(5),
          ),
          // Oldest tasks, 4×2.
          box(
            4,
            2,
            44,
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'OLDEST TASKS',
                  style: VText.inter(10, weight: 500, letterSpacing: 1),
                ),
                for (final t in tasks)
                  Row(
                    children: [
                      VTaskCheck(ageDays: t.ageDays(now), size: 18),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          t.title,
                          style: VText.inter(14, weight: 500),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        VFormat.ageShort(t.ageDays(now)),
                        style: VText.doto(15),
                      ),
                    ],
                  ),
              ],
            ),
            padding: const EdgeInsets.fromLTRB(24, 18, 24, 18),
          ),
          // Mantra, 4×1.
          box(
            4,
            1,
            38,
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MANTRA',
                  style: VText.inter(10, weight: 500, letterSpacing: 1),
                ),
                const SizedBox(height: 3),
                Text(
                  mantra?.text ?? '',
                  style: VText.inter(16),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 26),
          ),
        ],
      ),
    );
  }
}

/// A stand-in wallpaper for the widget previews: dim, scattered dots of
/// different sizes, a frosted blur panel over them, and the widgets on top.
/// The blur turns the dots into a soft glow so they never compete with the
/// widgets.
class WidgetPreviewBackdrop extends StatelessWidget {
  const WidgetPreviewBackdrop({
    super.key,
    required this.light,
    required this.child,
  });

  final bool light;
  final Widget child;

  /// How visible the dots are before the blur; low keeps the backdrop dim.
  static const double dotOpacity = 0.45;

  @override
  Widget build(BuildContext context) {
    final paper = light ? VColors.white : VColors.black;
    final dot = light ? VColors.black : VColors.white;
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: ColoredBox(
        color: paper,
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: dotOpacity,
                child: CustomPaint(painter: _ScatterPainter(dot)),
              ),
            ),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                child: const SizedBox.expand(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 22),
              child: FittedBox(
                child: SizedBox(
                  width: WidgetPreviewGrid.cell * 4 + WidgetPreviewGrid.gap * 3,
                  child: child,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Dots scattered at fixed pseudo-random places (the same every frame), a few
/// large and many small, like out-of-focus lights.
class _ScatterPainter extends CustomPainter {
  _ScatterPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(2026);
    final paint = Paint()..color = color;
    for (var i = 0; i < 90; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final big = random.nextDouble() < 0.15;
      final r = big
          ? 10 + random.nextDouble() * 18
          : 1 + random.nextDouble() * 3.5;
      canvas.drawCircle(Offset(x, y), r, paint);
    }
  }

  @override
  bool shouldRepaint(_ScatterPainter old) => old.color != color;
}
