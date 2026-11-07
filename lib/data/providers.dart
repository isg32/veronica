import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/clock.dart';
import '../mock/medicine_mock.dart';
import '../mock/mantra_mock.dart';
import '../mock/modes_mock.dart';
import '../mock/permissions_mock.dart';
import '../mock/profile_mock.dart';
import '../mock/sleep_mock.dart';
import '../mock/tasks_mock.dart';
import '../mock/usage_mock.dart';
import '../mock/voice_mock.dart';
import '../mock/water_mock.dart';
import '../platform/android_usage.dart';
import 'db/database.dart';
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
ProfileRepository profileRepository(Ref ref) => MockProfileRepository();

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
TaskRepository taskRepository(Ref ref) =>
    MockTaskRepository(ref.watch(clockProvider).now);

@Riverpod(keepAlive: true)
WaterRepository waterRepository(Ref ref) =>
    MockWaterRepository(ref.watch(clockProvider).now);

@Riverpod(keepAlive: true)
MedicineRepository medicineRepository(Ref ref) => MockMedicineRepository();

@Riverpod(keepAlive: true)
ModeRepository modeRepository(Ref ref) =>
    MockModeRepository(ref.watch(clockProvider).now);

@Riverpod(keepAlive: true)
SleepRepository sleepRepository(Ref ref) =>
    MockSleepRepository(ref.watch(clockProvider).now);

@Riverpod(keepAlive: true)
MantraRepository mantraRepository(Ref ref) => MockMantraRepository();

@Riverpod(keepAlive: true)
SettingsRepository settingsRepository(Ref ref) => MockSettingsRepository();

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
Stream<VoiceSettings> voiceSettings(Ref ref) =>
    ref.watch(settingsRepositoryProvider).watchVoice();

@riverpod
Stream<GlyphSettings> glyphSettings(Ref ref) =>
    ref.watch(settingsRepositoryProvider).watchGlyph();
