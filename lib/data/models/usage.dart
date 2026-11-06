/// An installed app that can be watched.
class InstalledApp {
  const InstalledApp({required this.packageName, required this.name});

  final String packageName;
  final String name;
}

/// An app the user chose to watch, with today's usage.
class WatchedApp {
  const WatchedApp({
    required this.packageName,
    required this.name,
    required this.dailyLimitMin,
    this.nudgeAtPercent = 80,
    this.hardBlock = false,
    this.extensionsPerDay = 2,
    this.extensionsUsedToday = 0,
    this.minutesToday = 0,
    this.lastSevenDays = const [],
  });

  final String packageName;
  final String name;
  final int dailyLimitMin;
  final int nudgeAtPercent;
  final bool hardBlock;

  /// "5 more minutes" allowed per day (0–2).
  final int extensionsPerDay;
  final int extensionsUsedToday;
  final int minutesToday;

  /// Minutes per day, oldest first; the last entry is today.
  final List<int> lastSevenDays;

  double get progress => dailyLimitMin == 0 ? 0 : minutesToday / dailyLimitMin;

  bool get isOver => minutesToday > dailyLimitMin;

  int get minutesOver => isOver ? minutesToday - dailyLimitMin : 0;

  int get extensionsLeft =>
      (extensionsPerDay - extensionsUsedToday).clamp(0, extensionsPerDay);

  WatchedApp copyWith({
    int? dailyLimitMin,
    int? nudgeAtPercent,
    bool? hardBlock,
    int? extensionsPerDay,
    int? extensionsUsedToday,
    int? minutesToday,
  }) => WatchedApp(
    packageName: packageName,
    name: name,
    dailyLimitMin: dailyLimitMin ?? this.dailyLimitMin,
    nudgeAtPercent: nudgeAtPercent ?? this.nudgeAtPercent,
    hardBlock: hardBlock ?? this.hardBlock,
    extensionsPerDay: extensionsPerDay ?? this.extensionsPerDay,
    extensionsUsedToday: extensionsUsedToday ?? this.extensionsUsedToday,
    minutesToday: minutesToday ?? this.minutesToday,
    lastSevenDays: lastSevenDays,
  );
}

/// Nudge and override counts for a period (today or the week).
class NudgeStats {
  const NudgeStats({
    required this.shown,
    required this.accepted,
    required this.overrides,
  });

  final int shown;

  /// Times the phone was put down when asked.
  final int accepted;

  /// Emergency overrides used past a hard block.
  final int overrides;
}
