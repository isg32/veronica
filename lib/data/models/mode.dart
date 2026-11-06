import 'day_time.dart';

enum DndPolicy {
  off('Off'),
  starred('Starred contacts can call'),
  calls('Calls allowed');

  const DndPolicy(this.label);

  final String label;
}

/// What happens to watched apps while the mode runs.
enum AppPolicy { usual, blocked, nudgeAfter, allowed }

/// The mode's timer.
enum ModeTimer {
  none('None'),
  pomodoro25('25 / 5'),
  pomodoro50('50 / 10'),
  fixed('Fixed');

  const ModeTimer(this.label);

  final String label;
}

enum GlyphPattern {
  off('Off'),
  focusPulse('Slow focus pulse'),
  callsOnly('Off except calls'),
  countdown('Countdown');

  const GlyphPattern(this.label);

  final String label;
}

enum RingerMode { normal, vibrate, silent }

/// When a mode starts and ends by itself.
class ModeSchedule {
  const ModeSchedule({required this.days, required this.start, this.end});

  final Set<int> days;
  final DayTime start;
  final DayTime? end;
}

/// A bundle of settings applied in one tap and reverted when it ends.
class Mode {
  const Mode({
    required this.id,
    required this.name,
    required this.purpose,
    this.isPreset = false,
    this.greyscale = false,
    this.dnd = DndPolicy.off,
    this.appPolicy = AppPolicy.usual,
    this.blockedApps = const {},
    this.nudgeAfterMin = 5,
    this.waterOn = true,
    this.timer = ModeTimer.none,
    this.timerMin,
    this.glyph = GlyphPattern.off,
    this.schedule,
    this.brightness,
    this.ringer,
    this.mediaVolume,
    this.hideNotifications = false,
    this.blackWallpaper = false,
  });

  final String id;
  final String name;

  /// One line under the name, e.g. "Deep focus".
  final String purpose;

  /// Work, Go Out and Binge Time can be reset but not deleted.
  final bool isPreset;
  final bool greyscale;
  final DndPolicy dnd;
  final AppPolicy appPolicy;

  /// Package names blocked while the mode runs.
  final Set<String> blockedApps;
  final int nudgeAfterMin;
  final bool waterOn;
  final ModeTimer timer;

  /// Length for a fixed timer (Binge Time: 30 / 60 / 90).
  final int? timerMin;
  final GlyphPattern glyph;
  final ModeSchedule? schedule;

  // Extras for custom modes.

  /// Screen brightness 0–1 while the mode runs; null keeps it.
  final double? brightness;
  final RingerMode? ringer;

  /// Media volume 0–1; null keeps it.
  final double? mediaVolume;
  final bool hideNotifications;
  final bool blackWallpaper;

  Mode copyWith({
    String? name,
    String? purpose,
    bool? greyscale,
    DndPolicy? dnd,
    AppPolicy? appPolicy,
    Set<String>? blockedApps,
    bool? waterOn,
    ModeTimer? timer,
    int? timerMin,
    GlyphPattern? glyph,
    ModeSchedule? schedule,
    bool clearSchedule = false,
    double? brightness,
    bool clearBrightness = false,
    RingerMode? ringer,
    bool clearRinger = false,
    bool? hideNotifications,
    bool? blackWallpaper,
  }) => Mode(
    id: id,
    name: name ?? this.name,
    purpose: purpose ?? this.purpose,
    isPreset: isPreset,
    greyscale: greyscale ?? this.greyscale,
    dnd: dnd ?? this.dnd,
    appPolicy: appPolicy ?? this.appPolicy,
    blockedApps: blockedApps ?? this.blockedApps,
    nudgeAfterMin: nudgeAfterMin,
    waterOn: waterOn ?? this.waterOn,
    timer: timer ?? this.timer,
    timerMin: timerMin ?? this.timerMin,
    glyph: glyph ?? this.glyph,
    schedule: clearSchedule ? null : (schedule ?? this.schedule),
    brightness: clearBrightness ? null : (brightness ?? this.brightness),
    ringer: clearRinger ? null : (ringer ?? this.ringer),
    mediaVolume: mediaVolume,
    hideNotifications: hideNotifications ?? this.hideNotifications,
    blackWallpaper: blackWallpaper ?? this.blackWallpaper,
  );
}

/// The mode that is running right now.
class ActiveMode {
  const ActiveMode({
    required this.modeId,
    required this.startedAt,
    this.endsAt,
  });

  final String modeId;
  final DateTime startedAt;

  /// When a timed mode (Binge Time) ends; null for open-ended modes.
  final DateTime? endsAt;
}
