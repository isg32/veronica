import '../data/db/codecs.dart';
import '../data/db/database.dart';
import '../data/local/local_repositories.dart';
import '../data/models/models.dart';
import '../data/usage/drift_usage_repository.dart';
import 'mantra_mock.dart';
import 'medicine_mock.dart';
import 'mock_cell.dart';
import 'modes_mock.dart';
import 'sleep_mock.dart';
import 'sounds_mock.dart';
import 'tasks_mock.dart';
import 'usage_mock.dart';
import 'water_mock.dart';

/// Fills [db] with the sample data from `mockdata.md`, through the real
/// repositories. Used by tests, and by "Load sample data" in debug builds.
Future<void> seedSampleData(VeronicaDatabase db) async {
  DateTime now() => mockNow;

  await DriftProfileRepository(db)
      .save(const Profile(name: 'Sapan', onboarded: true));

  final usage = DriftUsageRepository(
    db,
    const MockUsageSource(),
    now,
    refreshEvery: null,
  );
  for (final app in mockWatchedApps) {
    await usage.watch(
      InstalledApp(packageName: app.packageName, name: app.name),
      dailyLimitMin: app.dailyLimitMin,
    );
  }

  final tasks = DriftTaskRepository(db, now);
  for (final t in mockTasks()) {
    await tasks.update(t);
  }

  final water = DriftWaterRepository(db, now);
  await water.saveSettings(mockWaterSettings);
  for (final log in mockWaterToday()) {
    await db
        .into(db.waterLogs)
        .insertOnConflictUpdate(
          WaterLogsCompanion.insert(
            id: log.id,
            at: log.at.millisecondsSinceEpoch,
            ml: log.ml,
          ),
        );
  }

  final medicine = DriftMedicineRepository(db, now);
  await medicine.setEnabled(true);
  for (final m in mockMedicines) {
    await medicine.save(m);
  }
  for (final d in mockDoses().where((d) => d.status == DoseStatus.taken)) {
    await db
        .into(db.doses)
        .insertOnConflictUpdate(
          DosesCompanion.insert(
            medicineId: d.medicineId,
            scheduledAt: d.scheduledAt.millisecondsSinceEpoch,
            status: d.status.index,
          ),
        );
  }

  final modes = DriftModeRepository(db, now);
  for (final m in mockModes) {
    await modes.save(m);
  }
  await db.writePref(PrefKeys.activeMode, Codecs.activeMode(mockActiveMode()));

  final sleep = DriftSleepRepository(
    db,
    pickSound: () async => null,
    nights: (_) async => const [],
    deleteFile: (_) async {},
  );
  await sleep.saveSchedule(mockSleepSchedule);
  for (final a in mockAlarms) {
    await sleep.saveAlarm(a);
  }
  for (final s in mockSounds()) {
    await sleep.addSound(s, '');
  }

  final mantras = DriftMantraRepository(db, now);
  await db.delete(db.mantras).go();
  for (final m in mockMantras()) {
    await mantras.save(m);
  }
  await mantras.saveSettings(mockMantraSettings);
}
