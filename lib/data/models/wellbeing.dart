import 'day_time.dart';

/// A mantra, user-written or from the starter list.
class Mantra {
  const Mantra({
    required this.id,
    required this.text,
    this.isStarter = false,
    this.lastShownAt,
  });

  final String id;
  final String text;
  final bool isStarter;
  final DateTime? lastShownAt;
}

/// How today's quote is chosen.
class MantraSettings {
  const MantraSettings({this.rotate = true, this.fixedMantraId});

  /// Rotate daily, or always show [fixedMantraId].
  final bool rotate;
  final String? fixedMantraId;

  MantraSettings copyWith({bool? rotate, String? fixedMantraId}) =>
      MantraSettings(
        rotate: rotate ?? this.rotate,
        fixedMantraId: fixedMantraId ?? this.fixedMantraId,
      );
}

/// An audio mantra to listen to: a file on the phone (MP3, FLAC, …) or a
/// YouTube video, streamed as audio.
class AudioMantra {
  const AudioMantra({
    required this.id,
    required this.title,
    required this.source,
    required this.addedAt,
    this.youTube = false,
    this.length = Duration.zero,
  });

  final String id;
  final String title;

  /// The file's path in the app, or the YouTube video's link.
  final String source;
  final bool youTube;

  /// Zero when not known yet (a YouTube video before it first plays).
  final Duration length;
  final DateTime addedAt;
}

/// The daily mantra listening session.
class ListeningSettings {
  const ListeningSettings({
    this.enabled = true,
    this.time = const DayTime(7, 15),
    this.days = Weekdays.all,
    this.playId,
  });

  /// Whether Veronica reminds you at [time] on [days].
  final bool enabled;
  final DayTime time;
  final Set<int> days;

  /// The one mantra a session plays, or null to play them all in order.
  final String? playId;

  ListeningSettings copyWith({
    bool? enabled,
    DayTime? time,
    Set<int>? days,
    String? Function()? playId,
  }) => ListeningSettings(
    enabled: enabled ?? this.enabled,
    time: time ?? this.time,
    days: days ?? this.days,
    playId: playId == null ? this.playId : playId(),
  );
}

/// Moments Veronica may speak.
enum VoiceMoment {
  putItDown('Put it down'),
  timesUp("Time's up"),
  water('Water reminder'),
  medicine('Medicine due'),
  mantra('Mantra session'),
  wakeUp('Wake-up greeting'),
  goodnight('Goodnight');

  const VoiceMoment(this.label);

  final String label;
}

/// A Kokoro voice to audition.
enum KokoroVoice {
  afHeart('af', 'Warm, soft (default)'),
  afBella('af_bella', 'Bright'),
  afNicole('af_nicole', 'Very soft, near-whisper'),
  bfEmma('bf_emma', 'British');

  const KokoroVoice(this.id, this.description);

  final String id;
  final String description;
}

enum VoiceModelState { notDownloaded, downloading, ready }

/// Veronica's voice settings and the state of the offline model.
class VoiceSettings {
  const VoiceSettings({
    this.enabled = true,
    this.voice = KokoroVoice.afHeart,
    this.speed = 1.0,
    this.moments = const {...VoiceMoment.values},
    this.modelState = VoiceModelState.ready,
    this.downloadProgress = 1,
    this.linesRendered = 14,
    this.linesTotal = 14,
  });

  final bool enabled;
  final KokoroVoice voice;

  /// 0.9, 1.0 or 1.1.
  final double speed;
  final Set<VoiceMoment> moments;
  final VoiceModelState modelState;
  final double downloadProgress;
  final int linesRendered;
  final int linesTotal;

  VoiceSettings copyWith({
    bool? enabled,
    KokoroVoice? voice,
    double? speed,
    Set<VoiceMoment>? moments,
  }) => VoiceSettings(
    enabled: enabled ?? this.enabled,
    voice: voice ?? this.voice,
    speed: speed ?? this.speed,
    moments: moments ?? this.moments,
    modelState: modelState,
    downloadProgress: downloadProgress,
    linesRendered: linesRendered,
    linesTotal: linesTotal,
  );
}
