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

/// When the mantra shows and how it is chosen.
class MantraSettings {
  const MantraSettings({
    this.time = const DayTime(7, 15),
    this.rotate = true,
    this.fixedMantraId,
  });

  final DayTime time;

  /// Rotate daily, or always show [fixedMantraId].
  final bool rotate;
  final String? fixedMantraId;

  MantraSettings copyWith({
    DayTime? time,
    bool? rotate,
    String? fixedMantraId,
  }) => MantraSettings(
    time: time ?? this.time,
    rotate: rotate ?? this.rotate,
    fixedMantraId: fixedMantraId ?? this.fixedMantraId,
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
  afHeart('af_heart', 'Warm, soft'),
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
