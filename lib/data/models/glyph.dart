import 'day_time.dart';

/// The Glyph patterns Veronica plays on the Phone (2a).
enum GlyphSignal {
  alarmSunrise(
    'Alarm sunrise',
    'C fills from C1 to C24 over the fade-in, then A and B light',
  ),
  putItDown(
    'Put it down',
    'C fills to the share of the limit used, then A pulses three times',
  ),
  timesUp("Time's up", 'C empties from top to bottom over the last minute'),
  water('Water progress', 'C lights one block per glass of the goal'),
  medicine('Medicine due', 'A and B double-flash, repeating every 10 s'),
  mantra('Mantra breathing', 'Whole C strip glows up for 4 s and down for 6 s'),
  focus('Focus countdown', 'C drains as the Work or Binge timer runs'),
  test('Light test', 'Every light in turn, C1 to C24, then B and A, then all');

  /// The patterns Veronica uses (everything but the light test).
  static List<GlyphSignal> get patterns =>
      values.where((s) => s != test).toList();

  const GlyphSignal(this.label, this.description);

  final String label;
  final String description;
}

/// Glyph brightness and quiet hours.
class GlyphSettings {
  const GlyphSettings({
    this.brightness = 0.6,
    this.quietFrom = const DayTime(23, 0),
    this.quietTo = const DayTime(7, 0),
  });

  final double brightness;
  final DayTime quietFrom;
  final DayTime quietTo;

  GlyphSettings copyWith({
    double? brightness,
    DayTime? quietFrom,
    DayTime? quietTo,
  }) => GlyphSettings(
    brightness: brightness ?? this.brightness,
    quietFrom: quietFrom ?? this.quietFrom,
    quietTo: quietTo ?? this.quietTo,
  );
}
