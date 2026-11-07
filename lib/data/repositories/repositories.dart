/// Every feature reads and writes through these interfaces.
///
/// Phase 0 implements them with in-memory mocks (`lib/mock/`); later phases
/// add drift- and platform-backed versions. Which one is used is decided in
/// one place: `lib/data/providers.dart`.
library;

import '../models/models.dart';

abstract interface class ProfileRepository {
  Stream<Profile> watch();
  Future<void> save(Profile profile);
}

abstract interface class PermissionRepository {
  Stream<Map<AppPermission, bool>> watchGranted();

  /// Opens the right system screen; the stream updates when granted.
  Future<void> request(AppPermission permission);

  Stream<AdbStatus> watchAdb();

  /// Re-checks the ADB grants ("Check again").
  Future<void> recheckAdb();
}

abstract interface class UsageRepository {
  Stream<List<WatchedApp>> watchWatched();
  Stream<List<InstalledApp>> watchInstalled();
  Future<void> watch(InstalledApp app, {required int dailyLimitMin});
  Future<void> unwatch(String packageName);
  Future<void> update(WatchedApp app);

  /// Uses one "5 more minutes" for today.
  Future<void> extend(String packageName);

  /// Logs an emergency override past a hard block.
  Future<void> logOverride(String packageName);

  /// Re-reads minutes now (e.g. after usage access was granted).
  void refresh();

  /// Counts a soft nudge (or a Put it down card) shown for the app today.
  Future<void> recordNudge(String packageName);

  /// Counts a "Close app" from Put it down: the phone was put down.
  Future<void> recordPutDown(String packageName);

  /// Nudges for the last seven days.
  Stream<NudgeStats> watchWeekNudges();
}

abstract interface class TaskRepository {
  Stream<List<Task>> watchAll();
  Future<Task> add({required String title, String notes, DateTime? dueAt});
  Future<void> update(Task task);
  Future<void> setDone(String id, {required bool done});
  Future<void> delete(String id);
}

abstract interface class WaterRepository {
  Stream<WaterSettings> watchSettings();
  Future<void> saveSettings(WaterSettings settings);

  /// Today's drinks, oldest first.
  Stream<List<WaterLog>> watchToday();
  Future<void> logGlass();
  Future<void> undoLast();

  /// The last seven days, oldest first.
  Stream<List<WaterDay>> watchWeek();
}

abstract interface class MedicineRepository {
  /// Medicine is off by default.
  Stream<bool> watchEnabled();
  Future<void> setEnabled(bool enabled);
  Stream<List<Medicine>> watchMedicines();
  Future<void> save(Medicine medicine);
  Future<void> delete(String id);

  /// Doses for the last seven days including today, newest first.
  Stream<List<DoseLog>> watchDoses();
  Future<void> setDoseStatus(DoseLog dose, DoseStatus status);
}

abstract interface class ModeRepository {
  Stream<List<Mode>> watchModes();
  Future<void> save(Mode mode);
  Future<void> delete(String id);
  Stream<ActiveMode?> watchActive();
  Future<void> start(String modeId, {int? minutes});
  Future<void> end();

  /// Records a mode that was started or ended outside the app (by a
  /// schedule), without applying anything.
  Future<void> adopt(ActiveMode? active);
}

abstract interface class SleepRepository {
  Stream<SleepSchedule> watchSchedule();
  Future<void> saveSchedule(SleepSchedule schedule);
  Stream<List<Alarm>> watchAlarms();
  Future<void> saveAlarm(Alarm alarm);
  Future<void> deleteAlarm(String id);

  /// The last seven nights, oldest first.
  Stream<List<NightLog>> watchNights();
  Stream<List<AlarmSound>> watchSounds();

  /// Where a sound's audio lives on the phone, for playback.
  Future<String?> soundPath(String id);
  Future<void> importSound();

  /// Lists the phone's own alarm [tones] (title, content URI, length)
  /// alongside the imported sounds, in the given order.
  Future<void> syncPhoneSounds(List<(String, String, Duration)> tones);
  Future<void> renameSound(String id, String name);
  Future<void> deleteSound(String id);
}

abstract interface class MantraRepository {
  Stream<List<Mantra>> watchMantras();
  Future<void> save(Mantra mantra);
  Future<void> delete(String id);
  Stream<MantraSettings> watchSettings();
  Future<void> saveSettings(MantraSettings settings);
}

abstract interface class SettingsRepository {
  Stream<VoiceSettings> watchVoice();
  Future<void> saveVoice(VoiceSettings settings);
  Stream<GlyphSettings> watchGlyph();
  Future<void> saveGlyph(GlyphSettings settings);
}

/// Where minutes of use and the list of installed apps come from: Android's
/// usage statistics on the phone, a fixed set in tests and Phase 0.
abstract interface class UsageSource {
  Future<List<InstalledApp>> installedApps();

  /// Minutes in each app for each of the seven days ending today, oldest
  /// first, keyed by package name.
  Future<Map<String, List<int>>> lastSevenDays(Set<String> packageNames);
}
