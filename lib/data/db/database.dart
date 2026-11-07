import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

/// An app the user chose to watch, with its rules.
@DataClassName('WatchedAppRow')
class WatchedApps extends Table {
  TextColumn get packageName => text()();
  TextColumn get name => text()();
  IntColumn get dailyLimitMin => integer()();
  IntColumn get nudgeAtPercent => integer().withDefault(const Constant(80))();
  BoolColumn get hardBlock => boolean().withDefault(const Constant(false))();

  /// "5 more minutes" allowed per day (0–2).
  IntColumn get extensionsPerDay => integer().withDefault(const Constant(2))();

  /// Epoch milliseconds.
  IntColumn get addedAt => integer()();

  @override
  Set<Column<Object>> get primaryKey => {packageName};
}

/// What happened with one watched app on one day. Minutes used are not
/// stored here: Android's usage stats are the source of truth for those.
@DataClassName('UsageDayRow')
class UsageDays extends Table {
  TextColumn get packageName => text()();

  /// Local calendar day, `yyyy-mm-dd`.
  TextColumn get day => text()();
  IntColumn get nudgesShown => integer().withDefault(const Constant(0))();

  /// Times the phone was put down when asked.
  IntColumn get putDownAccepted => integer().withDefault(const Constant(0))();
  IntColumn get extensionsUsed => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {packageName, day};
}

/// An emergency override past a hard block.
@DataClassName('OverrideRow')
class OverrideLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get packageName => text()();

  /// Epoch milliseconds.
  IntColumn get at => integer()();
}

/// Small single values (settings, the profile, the running mode), each a
/// JSON document under a key. See `codecs.dart`.
@DataClassName('PrefRow')
class Prefs extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

@DataClassName('TaskRow')
class Tasks extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get notes => text().withDefault(const Constant(''))();
  IntColumn get createdAt => integer()();
  IntColumn get dueAt => integer().nullable()();
  IntColumn get completedAt => integer().nullable()();

  /// TaskPriority index.
  IntColumn get priority => integer().withDefault(const Constant(1))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('WaterLogRow')
class WaterLogs extends Table {
  TextColumn get id => text()();
  IntColumn get at => integer()();
  IntColumn get ml => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('MedicineRow')
class Medicines extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get dose => text()();

  /// `HH:MM,HH:MM`.
  TextColumn get times => text()();

  /// `1,2,3` (Monday = 1).
  TextColumn get days => text()();
  IntColumn get refillCount => integer().withDefault(const Constant(0))();
  BoolColumn get remindRefill => boolean().withDefault(const Constant(true))();
  IntColumn get refillRemindAt => integer().withDefault(const Constant(5))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// A dose that was answered. Unanswered doses are worked out from the
/// medicines' schedules (due, or missed once well past their time).
@DataClassName('DoseRow')
class Doses extends Table {
  TextColumn get medicineId => text()();
  IntColumn get scheduledAt => integer()();

  /// DoseStatus index.
  IntColumn get status => integer()();

  @override
  Set<Column<Object>> get primaryKey => {medicineId, scheduledAt};
}

/// Modes, alarms and sounds are stored as JSON documents (see codecs.dart).
@DataClassName('ModeRow')
class Modes extends Table {
  TextColumn get id => text()();
  IntColumn get position => integer()();
  TextColumn get json => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('AlarmRow')
class Alarms extends Table {
  TextColumn get id => text()();
  TextColumn get json => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('SoundRow')
class Sounds extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get lengthMs => integer()();
  IntColumn get importedAt => integer()();

  /// Copy of the audio inside the app's storage.
  TextColumn get path => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('MantraRow')
class Mantras extends Table {
  TextColumn get id => text()();
  TextColumn get body => text()();
  BoolColumn get isStarter => boolean().withDefault(const Constant(false))();
  IntColumn get lastShownAt => integer().nullable()();
  IntColumn get addedAt => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Veronica's on-device database (see docs/PLAN.md, "Data model").
@DriftDatabase(
  tables: [
    WatchedApps,
    UsageDays,
    OverrideLogs,
    Prefs,
    Tasks,
    WaterLogs,
    Medicines,
    Doses,
    Modes,
    Alarms,
    Sounds,
    Mantras,
  ],
)
class VeronicaDatabase extends _$VeronicaDatabase {
  VeronicaDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'veronica'));

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      // 1 → 2: everything beyond usage. Usage tables are kept as they are.
      if (from < 2) {
        for (final TableInfo<Table, Object?> table in [
          prefs,
          tasks,
          waterLogs,
          medicines,
          doses,
          modes,
          alarms,
          sounds,
          mantras,
        ]) {
          await m.createTable(table);
        }
      }
    },
  );

  /// Deletes everything; the presets and starter mantras come back on next
  /// read, and onboarding runs again.
  Future<void> resetAll() => transaction(() async {
    for (final table in allTables) {
      await delete(table).go();
    }
  });

  // Prefs.

  Stream<String?> watchPref(String key) => (select(
    prefs,
  )..where((t) => t.key.equals(key))).watchSingleOrNull().map((r) => r?.value);

  Future<String?> readPref(String key) => watchPref(key).first;

  Future<void> writePref(String key, String? value) => value == null
      ? (delete(prefs)..where((t) => t.key.equals(key))).go()
      : into(
          prefs,
        ).insertOnConflictUpdate(PrefsCompanion.insert(key: key, value: value));

  /// `yyyy-mm-dd` for [t] in local time.
  static String dayKey(DateTime t) =>
      '${t.year.toString().padLeft(4, '0')}-'
      '${t.month.toString().padLeft(2, '0')}-'
      '${t.day.toString().padLeft(2, '0')}';

  // Watched apps.

  Stream<List<WatchedAppRow>> watchWatchedApps() => (select(
    watchedApps,
  )..orderBy([(t) => OrderingTerm.asc(t.addedAt)])).watch();

  Future<void> upsertWatchedApp(WatchedAppsCompanion row) =>
      into(watchedApps).insertOnConflictUpdate(row);

  Future<void> deleteWatchedApp(String packageName) => (delete(
    watchedApps,
  )..where((t) => t.packageName.equals(packageName))).go();

  // Days.

  Stream<List<UsageDayRow>> watchDay(String day) =>
      (select(usageDays)..where((t) => t.day.equals(day))).watch();

  Stream<List<UsageDayRow>> watchDaysSince(String firstDay) => (select(
    usageDays,
  )..where((t) => t.day.isBiggerOrEqualValue(firstDay))).watch();

  /// Adds to one of today's counters, creating the row if needed.
  Future<void> bump(
    String packageName,
    String day, {
    int nudges = 0,
    int accepted = 0,
    int extensions = 0,
  }) async {
    // Make sure the row exists without touching existing counts.
    await into(usageDays).insert(
      UsageDaysCompanion.insert(packageName: packageName, day: day),
      mode: InsertMode.insertOrIgnore,
    );
    await customUpdate(
      'UPDATE usage_days SET '
      'nudges_shown = nudges_shown + ?, '
      'put_down_accepted = put_down_accepted + ?, '
      'extensions_used = extensions_used + ? '
      'WHERE package_name = ? AND day = ?',
      variables: [
        Variable.withInt(nudges),
        Variable.withInt(accepted),
        Variable.withInt(extensions),
        Variable.withString(packageName),
        Variable.withString(day),
      ],
      updates: {usageDays},
    );
  }

  // Overrides.

  Future<void> logOverride(String packageName, DateTime at) =>
      into(overrideLogs).insert(
        OverrideLogsCompanion.insert(
          packageName: packageName,
          at: at.millisecondsSinceEpoch,
        ),
      );

  Stream<int> watchOverridesSince(DateTime since) {
    final count = overrideLogs.id.count();
    final query = selectOnly(overrideLogs)
      ..addColumns([count])
      ..where(
        overrideLogs.at.isBiggerOrEqualValue(since.millisecondsSinceEpoch),
      );
    return query.map((r) => r.read(count) ?? 0).watchSingle();
  }
}
