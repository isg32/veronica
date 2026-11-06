import 'package:flutter/widgets.dart';
import 'package:path_drawing/path_drawing.dart';

import '../widgets/v_ink.dart';

/// Veronica's line icons, drawn on a 24 × 24 grid (paths from the design).
enum VIcon {
  today(
    'M12 8a4 4 0 1 0 0 8a4 4 0 1 0 0-8M12 2v2M12 20v2M4.9 4.9l1.4 1.4'
    'M17.7 17.7l1.4 1.4M2 12h2M20 12h2M4.9 19.1l1.4-1.4M17.7 6.3l1.4-1.4',
  ),
  focus('M12 3a9 9 0 1 0 0 18a9 9 0 1 0 0-18M12 8a4 4 0 1 0 0 8a4 4 0 1 0 0-8'),
  tasks(
    'M5 4h14a1 1 0 0 1 1 1v14a1 1 0 0 1-1 1H5a1 1 0 0 1-1-1V5a1 1 0 0 1 1-1z'
    'M8 12l3 3l5-6',
  ),
  care('M12 3c4 5 6 8 6 11a6 6 0 0 1-12 0c0-3 2-6 6-11z'),
  sleep('M20 14.5A8 8 0 0 1 9.5 4a8 8 0 1 0 10.5 10.5z'),
  gear(
    'M12 9a3 3 0 1 0 0 6a3 3 0 1 0 0-6M12 2v3M12 19v3M2 12h3M19 12h3'
    'M4.9 4.9l2.1 2.1M17 17l2.1 2.1M4.9 19.1L7 17M17 7l2.1-2.1',
  ),
  plus('M12 5v14M5 12h14'),
  minus('M5 12h14'),
  chevron('M9 6l6 6l-6 6'),
  back('M15 6l-6 6l6 6'),
  check('M5 12l5 5l9-10'),
  search('M11 4a7 7 0 1 0 0 14a7 7 0 1 0 0-14M16 16l5 5'),
  close('M6 6l12 12M18 6L6 18');

  const VIcon(this.svgPath);

  final String svgPath;

  static final Map<VIcon, Path> _cache = {};

  Path get path => _cache.putIfAbsent(this, () => parseSvgPathData(svgPath));
}

/// Draws a [VIcon] in the current ink colour.
///
/// [strokeWidth] is in grid units, like the SVG `stroke-width` in the design
/// (1.5 idle, 2 inside a selected pill).
class VIconView extends StatelessWidget {
  const VIconView(
    this.icon, {
    super.key,
    this.size = 20,
    this.strokeWidth = 1.5,
    this.color,
  });

  final VIcon icon;
  final double size;
  final double strokeWidth;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(
        painter: _IconPainter(
          path: icon.path,
          color: color ?? VInk.of(context),
          strokeWidth: strokeWidth,
        ),
      ),
    );
  }
}

class _IconPainter extends CustomPainter {
  _IconPainter({
    required this.path,
    required this.color,
    required this.strokeWidth,
  });

  final Path path;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 24, size.height / 24);
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(_IconPainter old) =>
      old.path != path || old.color != color || old.strokeWidth != strokeWidth;
}
