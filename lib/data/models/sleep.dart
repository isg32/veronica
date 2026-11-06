import 'day_time.dart';

/// Bedtime and wake targets with a wind-down before bed.
class SleepSchedule {
  const SleepSchedule({
    this.bedtime = const DayTime(23, 30),
    this.wake = const DayTime(7, 0),
    this.windDownMin = 30,
  });

  final DayTime bedtime;
  final DayTime wake;

  /// 15, 30 or 60.
  final int windDownMin;

  Duration get sleepLength => Duration(minutes: bedtime.minutesUntil(wake));

  DayTime get windDownStart => bedtime.add(Duration(minutes: -windDownMin));

  SleepSchedule copyWith({DayTime? bedtime, DayTime? wake, int? windDownMin}) =>
      SleepSchedule(
        bedtime: bedtime ?? this.bedtime,
        wake: wake ?? this.wake,
        windDownMin: windDownMin ?? this.windDownMin,
      );
}

/// A calm alarm.
class Alarm {
  const Alarm({
    required this.id,
    required this.time,
    required this.days,
    required this.soundId,
    this.enabled = true,
    this.fadeInMin = 4,
    this.glyphSunrise = true,
    this.snoozeMin = 9,
  });

  final String id;
  final DayTime time;
  final Set<int> days;
  final String? soundId;
  final bool enabled;

  /// 1–5 minutes.
  final int fadeInMin;
  final bool glyphSunrise;

  /// 5, 9 or 15.
  final int snoozeMin;

  Alarm copyWith({
    DayTime? time,
    Set<int>? days,
    String? soundId,
    bool? enabled,
    int? fadeInMin,
    bool? glyphSunrise,
    int? snoozeMin,
  }) => Alarm(
    id: id,
    time: time ?? this.time,
    days: days ?? this.days,
    soundId: soundId ?? this.soundId,
    enabled: enabled ?? this.enabled,
    fadeInMin: fadeInMin ?? this.fadeInMin,
    glyphSunrise: glyphSunrise ?? this.glyphSunrise,
    snoozeMin: snoozeMin ?? this.snoozeMin,
  );
}

/// A sound the user imported. No sounds ship with the app.
class AlarmSound {
  const AlarmSound({
    required this.id,
    required this.name,
    required this.length,
    required this.importedAt,
  });

  final String id;
  final String name;
  final Duration length;
  final DateTime importedAt;

  AlarmSound rename(String name) =>
      AlarmSound(id: id, name: name, length: length, importedAt: importedAt);
}

/// Planned vs estimated sleep for one night.
class NightLog {
  const NightLog({
    required this.date,
    required this.planned,
    required this.actual,
  });

  final DateTime date;
  final Duration planned;

  /// Estimated from screen-off time.
  final Duration actual;
}
