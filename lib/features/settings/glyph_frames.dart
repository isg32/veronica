import 'dart:math' as math;

import '../../core/widgets/v_glyph_preview.dart';
import '../../data/models/models.dart';

/// What each Glyph pattern looks like [t] seconds after it starts, for the
/// preview in Settings. Phase 4 plays the same patterns on the real lights.
GlyphFrame glyphFrameAt(GlyphSignal signal, double t) {
  const n = 24;
  int fill(double p) => (p.clamp(0, 1) * n).round();

  switch (signal) {
    case GlyphSignal.alarmSunrise:
      final p = (t % 7) / 5;
      return GlyphFrame(lit: fill(p), a: p >= 1, b: p >= 1);
    case GlyphSignal.putItDown:
      final c = t % 5;
      final pulse = c > 2 && ((c - 2) * 2).floor().isEven;
      return GlyphFrame(lit: fill(c / 2), a: pulse);
    case GlyphSignal.timesUp:
      return GlyphFrame(lit: fill(1 - (t % 5) / 4));
    case GlyphSignal.water:
      final shown = (t * 2).floor() % 6;
      return GlyphFrame(lit: fill(5 / 8 * math.min(1, shown / 4)));
    case GlyphSignal.medicine:
      final c = t % 3;
      final on = c < 0.2 || (c >= 0.4 && c < 0.6);
      return GlyphFrame(a: on, b: on);
    case GlyphSignal.mantra:
      final c = t % 10;
      final p = c < 4 ? c / 4 : 1 - (c - 4) / 6;
      return GlyphFrame(lit: fill(p));
    case GlyphSignal.focus:
      return GlyphFrame(lit: fill(1 - (t % 8) / 8));
  }
}
