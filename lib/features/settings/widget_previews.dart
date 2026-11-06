import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/v_colors.dart';
import '../../core/widgets/v_ink.dart';
import '../home_widgets/home_widget_views.dart';

/// The six home-screen widgets laid out on Nothing's 4-column grid, as a
/// preview in Settings. They are the same views the native widgets show.
class WidgetPreviewGrid extends ConsumerWidget {
  const WidgetPreviewGrid({super.key, this.light = false});

  final bool light;

  static const double cell = HomeWidgetKind.cell;
  static const double gap = HomeWidgetKind.gap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(homeWidgetSnapshotProvider);
    Widget view(HomeWidgetKind k) =>
        HomeWidgetView(kind: k, data: data, light: light);

    return Wrap(
      spacing: gap,
      runSpacing: gap,
      children: [
        view(HomeWidgetKind.screenTime),
        SizedBox(
          width: HomeWidgetKind.span(2),
          height: HomeWidgetKind.span(2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              view(HomeWidgetKind.water),
              view(HomeWidgetKind.nextAlarm),
            ],
          ),
        ),
        view(HomeWidgetKind.modeSwitch),
        view(HomeWidgetKind.oldestTasks),
        view(HomeWidgetKind.mantra),
      ],
    );
  }
}

/// A stand-in wallpaper for the widget previews: lots of dim, colourful,
/// out-of-focus light spots, a frosted blur panel over them, and the widgets
/// on top. This is the only place Veronica shows colour (it stands in for the
/// user's wallpaper).
class WidgetPreviewBackdrop extends StatelessWidget {
  const WidgetPreviewBackdrop({
    super.key,
    required this.light,
    required this.child,
  });

  final bool light;
  final Widget child;

  /// Keeps the spots dim so the widgets stay the focus.
  static const double spotOpacity = 0.5;

  @override
  Widget build(BuildContext context) {
    final paper = light ? VColors.white : VColors.black;
    // A hairline in the page's ink frames the preview as its own section.
    return DecoratedBox(
      position: DecorationPosition.foreground,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: VInk.of(context)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: ColoredBox(
          color: paper,
          child: Stack(
            children: [
              Positioned.fill(
                child: Opacity(
                  opacity: spotOpacity,
                  child: CustomPaint(painter: _LightSpotsPainter()),
                ),
              ),
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                  child: const SizedBox.expand(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 22,
                ),
                child: FittedBox(
                  child: SizedBox(
                    width:
                        WidgetPreviewGrid.cell * 4 + WidgetPreviewGrid.gap * 3,
                    child: child,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Soft round light spots (bokeh) at fixed pseudo-random places, in mixed
/// colours and sizes, each fading out from its centre.
class _LightSpotsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(2026);
    const colors = VColors.previewWallpaperSpots;
    for (var i = 0; i < 70; i++) {
      final center = Offset(
        random.nextDouble() * size.width,
        random.nextDouble() * size.height,
      );
      final radius = random.nextDouble() < 0.3
          ? 40 + random.nextDouble() * 50
          : 8 + random.nextDouble() * 22;
      final color = colors[random.nextInt(colors.length)];
      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..shader = RadialGradient(colors: [color, color.withValues(alpha: 0)])
              .createShader(Rect.fromCircle(center: center, radius: radius)),
      );
    }
  }

  @override
  bool shouldRepaint(_LightSpotsPainter old) => false;
}
