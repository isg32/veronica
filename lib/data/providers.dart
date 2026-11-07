import 'dart:io';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/clock.dart';
import '../mock/permissions_mock.dart';
import '../mock/usage_mock.dart';
import '../platform/android_usage.dart';
import '../platform/mantra_audio.dart';
import '../platform/reminders.dart';
import '../platform/voice.dart';
import 'db/database.dart';
import 'local/local_repositories.dart';
import 'system/android_permission_repository.dart';
import 'models/models.dart';
import 'usage/drift_usage_repository.dart';
import 'repositories/repositories.dart';

part 'providers.g.dart';

// ---------------------------------------------------------------------------
// The one switch between mock and real data. Each repository flips to its
// real implementation as its phase lands (and `mockdata.md` is updated).
// ---------------------------------------------------------------------------

@Riverpod(keepAlive: true)
Clock clock(Ref ref) => const Clock.system();

/// The on-device database, opened once for the app's lifetime.
@Riverpod(keepAlive: true)
VeronicaDatabase database(Ref ref) {
  final db = VeronicaDatabase();
  ref.onDispose(db.close);
  return db;
}

/// Minutes and installed apps: Android's usage stats on the phone, the
/// sample source in tests and on the desktop.
@Riverpod(keepAlive: true)
UsageSource usageSource(Ref ref) =>
    isAndroid ? const AndroidUsageSource() : const MockUsageSource();

@Riverpod(keepAlive: true)
ProfileRepository profileRepository(Ref ref) =>
    DriftProfileRepository(ref.watch(databaseProvider));

@Riverpod(keepAlive: true)
PermissionRepository permissionRepository(Ref ref) =>
    isAndroid ? AndroidPermissionRepository() : MockPermissionRepository();

@Riverpod(keepAlive: true)
UsageRepository usageRepository(Ref ref) => DriftUsageRepository(
  ref.watch(databaseProvider),
  ref.watch(usageSourceProvider),
  ref.watch(clockProvider).now,
);

@Riverpod(keepAlive: true)
TaskRepository taskRepository(Ref ref) => DriftTaskRepository(
  ref.watch(databaseProvider),
  ref.watch(clockProvider).now,
);

@Riverpod(keepAlive: true)
WaterRepository waterRepository(Ref ref) => DriftWaterRepository(
  ref.watch(databaseProvider),
  ref.watch(clockProvider).now,
);

@Riverpod(keepAlive: true)
MedicineRepository medicineRepository(Ref ref) => DriftMedicineRepository(
  ref.watch(databaseProvider),
  ref.watch(clockProvider).now,
);

@Riverpod(keepAlive: true)
ModeRepository modeRepository(Ref ref) => DriftModeRepository(
  ref.watch(databaseProvider),
  ref.watch(clockProvider).now,
);

/// Importing alarm sounds from files (none in tests).
@Riverpod(keepAlive: true)
SoundPicker soundPicker(Ref ref) =>
    isAndroid ? pickAlarmSound : () async => null;

/// Sleep estimated from screen-off time (empty in tests).
@Riverpod(keepAlive: true)
NightSource nightSource(Ref ref) =>
    isAndroid ? androidNights : (schedule) async => const [];

@Riverpod(keepAlive: true)
SleepRepository sleepRepository(Ref ref) => DriftSleepRepository(
  ref.watch(databaseProvider),
  pickSound: ref.watch(soundPickerProvider),
  nights: ref.watch(nightSourceProvider),
  deleteFile: (path) async {
    final file = File(path);
    if (file.existsSync()) await file.delete();
  },
);

@Riverpod(keepAlive: true)
MantraRepository mantraRepository(Ref ref) => DriftMantraRepository(
  ref.watch(databaseProvider),
  ref.watch(clockProvider).now,
);

@Riverpod(keepAlive: true)
ListeningRepository listeningRepository(Ref ref) => DriftListeningRepository(
  ref.watch(databaseProvider),
  ref.watch(clockProvider).now,
  pickFiles: isAndroid ? pickMantraFiles : () async => const [],
  lookUp: lookUpYouTube,
  deleteFile: (path) async {
    final file = File(path);
    if (file.existsSync()) await file.delete();
  },
);

/// Whether the offline voice model is on the phone.
@Riverpod(keepAlive: true)
Stream<VoiceModelState> voiceModelState(Ref ref) async* {
  final model = await ref.watch(voiceModelProvider.future);
  yield model.state;
}

@Riverpod(keepAlive: true)
SettingsRepository settingsRepository(Ref ref) => DriftSettingsRepository(
  ref.watch(databaseProvider),
  voiceModel: ref.watch(voiceModelStateProvider.future).asStream(),
);

// ---------------------------------------------------------------------------
// Streams the UI watches.
// ---------------------------------------------------------------------------

/// "Now", ticking once a second (timers and countdowns).
@Riverpod(keepAlive: true)
Stream<DateTime> now(Ref ref) async* {
  final clock = ref.watch(clockProvider);
  yield clock.now();
  yield* Stream.periodic(const Duration(seconds: 1), (_) => clock.now());
}

@riverpod
Stream<Profile> profile(Ref ref) =>
    ref.watch(profileRepositoryProvider).watch();

@riverpod
Stream<Map<AppPermission, bool>> permissions(Ref ref) =>
    ref.watch(permissionRepositoryProvider).watchGranted();

@riverpod
Stream<AdbStatus> adbStatus(Ref ref) =>
    ref.watch(permissionRepositoryProvider).watchAdb();

@riverpod
Stream<List<WatchedApp>> watchedApps(Ref ref) =>
    ref.watch(usageRepositoryProvider).watchWatched();

@riverpod
Stream<List<InstalledApp>> installedApps(Ref ref) =>
    ref.watch(usageRepositoryProvider).watchInstalled();

@riverpod
Stream<NudgeStats> weekNudges(Ref ref) =>
    ref.watch(usageRepositoryProvider).watchWeekNudges();

@riverpod
Stream<List<Task>> tasks(Ref ref) =>
    ref.watch(taskRepositoryProvider).watchAll();

@riverpod
Stream<WaterSettings> waterSettings(Ref ref) =>
    ref.watch(waterRepositoryProvider).watchSettings();

@riverpod
Stream<List<WaterLog>> waterToday(Ref ref) =>
    ref.watch(waterRepositoryProvider).watchToday();

@riverpod
Stream<List<WaterDay>> waterWeek(Ref ref) =>
    ref.watch(waterRepositoryProvider).watchWeek();

@riverpod
Stream<bool> medicineEnabled(Ref ref) =>
    ref.watch(medicineRepositoryProvider).watchEnabled();

@riverpod
Stream<List<Medicine>> medicines(Ref ref) =>
    ref.watch(medicineRepositoryProvider).watchMedicines();

@riverpod
Stream<List<DoseLog>> doses(Ref ref) =>
    ref.watch(medicineRepositoryProvider).watchDoses();

@riverpod
Stream<List<Mode>> modes(Ref ref) =>
    ref.watch(modeRepositoryProvider).watchModes();

@riverpod
Stream<ActiveMode?> activeMode(Ref ref) =>
    ref.watch(modeRepositoryProvider).watchActive();

@riverpod
Stream<SleepSchedule> sleepSchedule(Ref ref) =>
    ref.watch(sleepRepositoryProvider).watchSchedule();

@riverpod
Stream<List<Alarm>> alarms(Ref ref) =>
    ref.watch(sleepRepositoryProvider).watchAlarms();

@riverpod
Stream<List<NightLog>> nights(Ref ref) =>
    ref.watch(sleepRepositoryProvider).watchNights();

@riverpod
Stream<List<AlarmSound>> sounds(Ref ref) =>
    ref.watch(sleepRepositoryProvider).watchSounds();

@riverpod
Stream<List<Mantra>> mantras(Ref ref) =>
    ref.watch(mantraRepositoryProvider).watchMantras();

@riverpod
Stream<MantraSettings> mantraSettings(Ref ref) =>
    ref.watch(mantraRepositoryProvider).watchSettings();

@riverpod
Stream<List<AudioMantra>> audioMantras(Ref ref) =>
    ref.watch(listeningRepositoryProvider).watchAudio();

@riverpod
Stream<ListeningSettings> listeningSettings(Ref ref) =>
    ref.watch(listeningRepositoryProvider).watchSettings();

@riverpod
Stream<VoiceSettings> voiceSettings(Ref ref) =>
    ref.watch(settingsRepositoryProvider).watchVoice();

@riverpod
Stream<GlyphSettings> glyphSettings(Ref ref) =>
    ref.watch(settingsRepositoryProvider).watchGlyph();
