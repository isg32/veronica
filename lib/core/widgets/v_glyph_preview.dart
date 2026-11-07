import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../theme/v_text.dart';
import 'v_ink.dart';

/// Which Glyph lights are on, for previews on the Phone (2a).
///
/// The 2a has the curved strip C1–C24 (indices 0–23) and the lights A (25)
/// and B (24).
class GlyphFrame {
  const GlyphFrame({this.lit = 0, this.a = false, this.b = false, this.only});

  /// Number of C segments lit from C1.
  final int lit;

  /// A single C segment lit on its own (index 0–23), for the light test.
  final int? only;

  /// Whether C segment [i] is lit.
  bool litC(int i) => only != null ? i == only : i < lit;
  final bool a;
  final bool b;
}

/// A diagram of the Phone (2a) back with its Glyph lights: lit segments are
/// solid, unlit ones dotted.
class VGlyphPreview extends StatelessWidget {
  const VGlyphPreview({super.key, required this.frame, this.scale = 1});

  final GlyphFrame frame;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220 * scale,
      height: 330 * scale,
      child: CustomPaint(
        painter: _GlyphPainter(frame: frame, color: VInk.of(context)),
      ),
    );
  }
}

class _GlyphPainter extends CustomPainter {
  _GlyphPainter({required this.frame, required this.color});

  final GlyphFrame frame;
  final Color color;

  static const double cx = 110;
  static const double cy = 120;
  static const double r = 90;

  Offset _pt(double deg, [double radius = r]) {
    final a = deg * math.pi / 180;
    return Offset(cx + radius * math.cos(a), cy - radius * math.sin(a));
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 220);
    canvas.clipRect(const Rect.fromLTWH(0, 0, 220, 330));

    final line = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Phone outline (cut off at the bottom like the design), camera ring and
    // the tilted camera module.
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(1, 1, 218, 360),
        const Radius.circular(34),
      ),
      line,
    );
    canvas.drawCircle(const Offset(cx, cy), 76, line);
    canvas.save();
    canvas.translate(cx, cy);
    canvas.rotate(-35 * math.pi / 180);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(-46, -25, 92, 50),
        const Radius.circular(25),
      ),
      line,
    );
    canvas.drawCircle(const Offset(-21, 0), 14, line);
    canvas.drawCircle(const Offset(21, 0), 14, line);
    canvas.drawCircle(const Offset(0, -42), 4, line);
    canvas.restore();

    // C1–C24.
    for (var i = 0; i < 24; i++) {
      final d0 = 10 + i * 2.7;
      _arc(canvas, d0, d0 + 2.1, on: frame.litC(i));
    }
    _arc(canvas, 150, 208, on: frame.a);
    _arc(canvas, 254, 286, on: frame.b);

    _label(canvas, 'C1', _pt(8, r - 16));
    _label(canvas, 'C24', _pt(76, r - 16));
    _label(canvas, 'A', _pt(180, r - 16));
    _label(canvas, 'B', _pt(270, r - 18));
    _label(
      canvas,
      'PHONE (2a) BACK',
      const Offset(110, 296),
      style: VText.doto(12),
    );
    canvas.restore();
  }

  void _arc(Canvas canvas, double from, double to, {required bool on}) {
    final rect = Rect.fromCircle(center: const Offset(cx, cy), radius: r);
    // Canvas angles run clockwise from 3 o'clock; the design's run counter-
    // clockwise, so negate.
    final start = -from * math.pi / 180;
    final sweep = -(to - from) * math.pi / 180;
    if (on) {
      canvas.drawArc(
        rect,
        start,
        sweep,
        false,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 7
          ..strokeCap = StrokeCap.round,
      );
      return;
    }
    // Unlit: dotted, 1 px dot every 4 px.
    final length = (to - from) * math.pi / 180 * r;
    final dots = math.max(1, (length / 4).floor());
    final paint = Paint()..color = color;
    for (var i = 0; i <= dots; i++) {
      final d = from + (to - from) * i / dots;
      canvas.drawCircle(_pt(d), 0.6, paint);
    }
  }

  void _label(Canvas canvas, String text, Offset at, {TextStyle? style}) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: (style ?? VText.inter(10)).copyWith(color: color),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, at - Offset(tp.width / 2, tp.height / 2));
  }

  @override
  bool shouldRepaint(_GlyphPainter old) =>
      old.frame.lit != frame.lit ||
      old.frame.only != frame.only ||
      old.frame.a != frame.a ||
      old.frame.b != frame.b ||
      old.color != color;
}
