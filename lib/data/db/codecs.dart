import 'dart:convert';

import '../models/models.dart';

/// JSON for the models stored as documents or single settings.
///
/// Field names are short and stable; unknown or missing fields fall back to
/// the model's defaults so older rows keep loading after a change.
abstract final class Codecs {
  static String encode(Map<String, Object?> map) => jsonEncode(map);

  static Map<String, Object?> decode(String json) =>
      jsonDecode(json) as Map<String, Object?>;

  // Small helpers.

  static String? _time(DayTime? t) => t?.label;

  static DayTime? _parseTime(Object? v) {
    if (v is! String || !v.contains(':')) return null;
    final parts = v.split(':');
    return DayTime(int.parse(parts[0]), int.parse(parts[1]));
  }

  static List<int> _days(Set<int> d) => d.toList()..sort();

  static Set<int> _parseDays(Object? v) =>
      v is List ? {for (final x in v) (x as num).toInt()} : const {};

  static int? _ms(DateTime? t) => t?.millisecondsSinceEpoch;

  static DateTime? _date(Object? v) =>
      v is num ? DateTime.fromMillisecondsSinceEpoch(v.toInt()) : null;

  static T _enum<T extends Enum>(List<T> values, Object? name, T fallback) =>
      values.where((e) => e.name == name).firstOrNull ?? fallback;

  // Profile.

  static String profile(Profile p) =>
      encode({'name': p.name, 'onboarded': p.onboarded});

  static Profile parseProfile(String json) {
    final m = decode(json);
    return Profile(
      name: m['name'] as String? ?? '',
      onboarded: m['onboarded'] as bool? ?? false,
    );
  }

  // Water.

  static String water(WaterSettings s) => encode({
    'unit': s.unit.name,
    'goal': s.goalGlasses,
    'glass': s.glassMl,
    'wake': _time(s.wake),
    'sleep': _time(s.sleep),
  });

  static WaterSettings parseWater(String json) {
    final m = decode(json);
    const d = WaterSettings();
    return WaterSettings(
      unit: _enum(WaterUnit.values, m['unit'], d.unit),
      goalGlasses: (m['goal'] as num?)?.toInt() ?? d.goalGlasses,
      glassMl: (m['glass'] as num?)?.toInt() ?? d.glassMl,
      wake: _parseTime(m['wake']) ?? d.wake,
      sleep: _parseTime(m['sleep']) ?? d.sleep,
    );
  }

  // Sleep.

  static String sleep(SleepSchedule s) => encode({
    'bed': _time(s.bedtime),
    'wake': _time(s.wake),
    'windDown': s.windDownMin,
  });

  static SleepSchedule parseSleep(String json) {
    final m = decode(json);
    const d = SleepSchedule();
    return SleepSchedule(
      bedtime: _parseTime(m['bed']) ?? d.bedtime,
      wake: _parseTime(m['wake']) ?? d.wake,
      windDownMin: (m['windDown'] as num?)?.toInt() ?? d.windDownMin,
    );
  }

  // Mantra settings.

  static String mantraSettings(MantraSettings s) => encode({
    'time': _time(s.time),
    'rotate': s.rotate,
    'fixed': s.fixedMantraId,
  });

  static MantraSettings parseMantraSettings(String json) {
    final m = decode(json);
    const d = MantraSettings();
    return MantraSettings(
      time: _parseTime(m['time']) ?? d.time,
      rotate: m['rotate'] as bool? ?? d.rotate,
      fixedMantraId: m['fixed'] as String?,
    );
  }

  // Voice.

  static String voice(VoiceSettings v) => encode({
    'enabled': v.enabled,
    'voice': v.voice.name,
    'speed': v.speed,
    'moments': [for (final m in v.moments) m.name],
  });

  static VoiceSettings parseVoice(
    String json, {
    required VoiceModelState model,
  }) {
    final m = decode(json);
    const d = VoiceSettings();
    final moments = m['moments'];
    return VoiceSettings(
      enabled: m['enabled'] as bool? ?? d.enabled,
      voice: _enum(KokoroVoice.values, m['voice'], d.voice),
      speed: (m['speed'] as num?)?.toDouble() ?? d.speed,
      moments: moments is List
          ? {
              for (final x in moments)
                ...VoiceMoment.values.where((v) => v.name == x),
            }
          : d.moments,
      modelState: model,
      downloadProgress: model == VoiceModelState.ready ? 1 : 0,
      linesRendered: 0,
      linesTotal: 0,
    );
  }

  // Glyph.

  static String glyph(GlyphSettings g) => encode({
    'brightness': g.brightness,
    'quietFrom': _time(g.quietFrom),
    'quietTo': _time(g.quietTo),
  });

  static GlyphSettings parseGlyph(String json) {
    final m = decode(json);
    const d = GlyphSettings();
    return GlyphSettings(
      brightness: (m['brightness'] as num?)?.toDouble() ?? d.brightness,
      quietFrom: _parseTime(m['quietFrom']) ?? d.quietFrom,
      quietTo: _parseTime(m['quietTo']) ?? d.quietTo,
    );
  }

  // Active mode.

  static String activeMode(ActiveMode a) => encode({
    'mode': a.modeId,
    'started': _ms(a.startedAt),
    'ends': _ms(a.endsAt),
  });

  static ActiveMode parseActiveMode(String json) {
    final m = decode(json);
    return ActiveMode(
      modeId: m['mode']! as String,
      startedAt: _date(m['started']) ?? DateTime.now(),
      endsAt: _date(m['ends']),
    );
  }

  // Modes.

  static String mode(Mode m) => encode({
    'id': m.id,
    'name': m.name,
    'purpose': m.purpose,
    'preset': m.isPreset,
    'greyscale': m.greyscale,
    'dnd': m.dnd.name,
    'apps': m.appPolicy.name,
    'blocked': m.blockedApps.toList(),
    'nudgeAfter': m.nudgeAfterMin,
    'water': m.waterOn,
    'timer': m.timer.name,
    'timerMin': m.timerMin,
    'glyph': m.glyph.name,
    'schedule': m.schedule == null
        ? null
        : {
            'days': _days(m.schedule!.days),
            'start': _time(m.schedule!.start),
            'end': _time(m.schedule!.end),
          },
    'brightness': m.brightness,
    'ringer': m.ringer?.name,
    'media': m.mediaVolume,
    'hideNotifications': m.hideNotifications,
    'blackWallpaper': m.blackWallpaper,
  });

  static Mode parseMode(String json) {
    final m = decode(json);
    final s = m['schedule'];
    final ringer = m['ringer'];
    return Mode(
      id: m['id']! as String,
      name: m['name'] as String? ?? '',
      purpose: m['purpose'] as String? ?? '',
      isPreset: m['preset'] as bool? ?? false,
      greyscale: m['greyscale'] as bool? ?? false,
      dnd: _enum(DndPolicy.values, m['dnd'], DndPolicy.off),
      appPolicy: _enum(AppPolicy.values, m['apps'], AppPolicy.usual),
      blockedApps: {
        for (final x in (m['blocked'] as List?) ?? const []) x as String,
      },
      nudgeAfterMin: (m['nudgeAfter'] as num?)?.toInt() ?? 5,
      waterOn: m['water'] as bool? ?? true,
      timer: _enum(ModeTimer.values, m['timer'], ModeTimer.none),
      timerMin: (m['timerMin'] as num?)?.toInt(),
      glyph: _enum(GlyphPattern.values, m['glyph'], GlyphPattern.off),
      schedule: s is Map
          ? ModeSchedule(
              days: _parseDays(s['days']),
              start: _parseTime(s['start']) ?? const DayTime(10, 0),
              end: _parseTime(s['end']),
            )
          : null,
      brightness: (m['brightness'] as num?)?.toDouble(),
      ringer: ringer == null
          ? null
          : _enum(RingerMode.values, ringer, RingerMode.normal),
      mediaVolume: (m['media'] as num?)?.toDouble(),
      hideNotifications: m['hideNotifications'] as bool? ?? false,
      blackWallpaper: m['blackWallpaper'] as bool? ?? false,
    );
  }

  // Alarms.

  static String alarm(Alarm a) => encode({
    'id': a.id,
    'time': _time(a.time),
    'days': _days(a.days),
    'sound': a.soundId,
    'enabled': a.enabled,
    'fade': a.fadeInMin,
    'sunrise': a.glyphSunrise,
    'snooze': a.snoozeMin,
  });

  static Alarm parseAlarm(String json) {
    final m = decode(json);
    return Alarm(
      id: m['id']! as String,
      time: _parseTime(m['time']) ?? const DayTime(7, 0),
      days: _parseDays(m['days']),
      soundId: m['sound'] as String?,
      enabled: m['enabled'] as bool? ?? true,
      fadeInMin: (m['fade'] as num?)?.toInt() ?? 4,
      glyphSunrise: m['sunrise'] as bool? ?? true,
      snoozeMin: (m['snooze'] as num?)?.toInt() ?? 9,
    );
  }

  // Medicine schedule columns.

  static String times(List<DayTime> times) =>
      ([...times]..sort()).map((t) => t.label).join(',');

  static List<DayTime> parseTimes(String s) => [
    for (final part in s.split(',').where((p) => p.isNotEmpty))
      _parseTime(part)!,
  ];

  static String days(Set<int> days) => _days(days).join(',');

  static Set<int> parseDays(String s) => {
    for (final part in s.split(',').where((p) => p.isNotEmpty)) int.parse(part),
  };
}
