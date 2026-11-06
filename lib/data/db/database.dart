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

/// Veronica's on-device database. Phase 1 holds usage; later phases add
/// tasks, water, medicine, modes, sleep and mantras (see docs/PLAN.md).
@DriftDatabase(tables: [WatchedApps, UsageDays, OverrideLogs])
class VeronicaDatabase extends _$VeronicaDatabase {
  VeronicaDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'veronica'));

  @override
  int get schemaVersion => 1;

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
