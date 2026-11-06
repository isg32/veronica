import 'day_time.dart';

enum WaterUnit { glasses, ml }

/// The water goal and the window reminders may fire in.
class WaterSettings {
  const WaterSettings({
    this.unit = WaterUnit.glasses,
    this.goalGlasses = 8,
    this.glassMl = 250,
    this.wake = const DayTime(7, 0),
    this.sleep = const DayTime(23, 0),
  });

  final WaterUnit unit;
  final int goalGlasses;
  final int glassMl;
  final DayTime wake;
  final DayTime sleep;

  int get goalMl => goalGlasses * glassMl;

  /// Reminders are spread evenly over the waking window.
  Duration get interval {
    final window = wake.minutesUntil(sleep);
    if (goalGlasses <= 0) return Duration(minutes: window);
    return Duration(minutes: window ~/ goalGlasses);
  }

  WaterSettings copyWith({
    WaterUnit? unit,
    int? goalGlasses,
    int? glassMl,
    DayTime? wake,
    DayTime? sleep,
  }) => WaterSettings(
    unit: unit ?? this.unit,
    goalGlasses: goalGlasses ?? this.goalGlasses,
    glassMl: glassMl ?? this.glassMl,
    wake: wake ?? this.wake,
    sleep: sleep ?? this.sleep,
  );
}

/// One logged drink.
class WaterLog {
  const WaterLog({required this.id, required this.at, required this.ml});

  final String id;
  final DateTime at;
  final int ml;
}

/// Glasses drunk on one day, for the weekly view.
class WaterDay {
  const WaterDay({
    required this.date,
    required this.glasses,
    required this.goal,
  });

  final DateTime date;
  final int glasses;
  final int goal;
}
