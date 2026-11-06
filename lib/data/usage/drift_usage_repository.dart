import 'dart:async';

import 'package:drift/drift.dart' show Value;

import '../db/database.dart';
import '../models/models.dart';
import '../repositories/repositories.dart';

/// The real [UsageRepository]: the watched apps, their rules and the day's
/// counters live in drift; minutes come from a [UsageSource] (Android's
/// usage stats on the phone).
class DriftUsageRepository implements UsageRepository {
  DriftUsageRepository(
    this._db,
    this._source,
    this._now, {
    this.refreshEvery = const Duration(minutes: 1),
  });

  final VeronicaDatabase _db;
  final UsageSource _source;
  final DateTime Function() _now;

  /// How often minutes are re-read while someone is watching; null reads
  /// them only when the stored data changes (tests).
  final Duration? refreshEvery;

  String get _today => VeronicaDatabase.dayKey(_now());

  String _daysAgo(int days) =>
      VeronicaDatabase.dayKey(_now().subtract(Duration(days: days)));

  @override
  Stream<List<WatchedApp>> watchWatched() {
    late final StreamController<List<WatchedApp>> controller;
    List<WatchedAppRow>? apps;
    List<UsageDayRow>? days;
    StreamSubscription<List<WatchedAppRow>>? appsSub;
    StreamSubscription<List<UsageDayRow>>? daysSub;
    Timer? timer;
    var generation = 0;

    Future<void> emit() async {
      final a = apps, d = days;
      if (a == null || d == null) return;
      final mine = ++generation;
      final minutes = a.isEmpty
          ? const <String, List<int>>{}
          : await _source.lastSevenDays({for (final r in a) r.packageName});
      // Drop results overtaken by a newer change.
      if (mine != generation || controller.isClosed) return;
      final today = _today;
      controller.add([
        for (final r in a)
          _toModel(
            r,
            d
                .where((x) => x.packageName == r.packageName && x.day == today)
                .firstOrNull,
            minutes[r.packageName] ?? const [0, 0, 0, 0, 0, 0, 0],
          ),
      ]);
    }

    controller = StreamController<List<WatchedApp>>(
      onListen: () {
        appsSub = _db.watchWatchedApps().listen((v) {
          apps = v;
          unawaited(emit());
        });
        daysSub = _db.watchDaysSince(_daysAgo(7)).listen((v) {
          days = v;
          unawaited(emit());
        });
        final every = refreshEvery;
        if (every != null) {
          timer = Timer.periodic(every, (_) => unawaited(emit()));
        }
      },
      onCancel: () async {
        timer?.cancel();
        await appsSub?.cancel();
        await daysSub?.cancel();
      },
    );
    return controller.stream;
  }

  WatchedApp _toModel(WatchedAppRow r, UsageDayRow? today, List<int> week) {
    return WatchedApp(
      packageName: r.packageName,
      name: r.name,
      dailyLimitMin: r.dailyLimitMin,
      nudgeAtPercent: r.nudgeAtPercent,
      hardBlock: r.hardBlock,
      extensionsPerDay: r.extensionsPerDay,
      extensionsUsedToday: today?.extensionsUsed ?? 0,
      minutesToday: week.isEmpty ? 0 : week.last,
      lastSevenDays: week,
    );
  }

  @override
  Stream<List<InstalledApp>> watchInstalled() =>
      Stream.fromFuture(_source.installedApps());

  @override
  Future<void> watch(InstalledApp app, {required int dailyLimitMin}) =>
      _db.upsertWatchedApp(
        WatchedAppsCompanion.insert(
          packageName: app.packageName,
          name: app.name,
          dailyLimitMin: dailyLimitMin,
          addedAt: _now().millisecondsSinceEpoch,
        ),
      );

  @override
  Future<void> unwatch(String packageName) => _db.deleteWatchedApp(packageName);

  @override
  Future<void> update(WatchedApp app) async {
    final rows = await _db.watchWatchedApps().first;
    final existing = rows
        .where((r) => r.packageName == app.packageName)
        .firstOrNull;
    await _db.upsertWatchedApp(
      WatchedAppsCompanion(
        packageName: Value(app.packageName),
        name: Value(app.name),
        dailyLimitMin: Value(app.dailyLimitMin),
        nudgeAtPercent: Value(app.nudgeAtPercent),
        hardBlock: Value(app.hardBlock),
        extensionsPerDay: Value(app.extensionsPerDay),
        addedAt: Value(existing?.addedAt ?? _now().millisecondsSinceEpoch),
      ),
    );
  }

  @override
  Future<void> extend(String packageName) async {
    final apps = await watchWatched().first;
    final app = apps.where((a) => a.packageName == packageName).firstOrNull;
    if (app == null || app.extensionsLeft <= 0) return;
    await _db.bump(packageName, _today, extensions: 1);
  }

  @override
  Future<void> logOverride(String packageName) =>
      _db.logOverride(packageName, _now());

  @override
  Future<void> recordNudge(String packageName) =>
      _db.bump(packageName, _today, nudges: 1);

  @override
  Future<void> recordPutDown(String packageName) =>
      _db.bump(packageName, _today, accepted: 1);

  @override
  Stream<NudgeStats> watchWeekNudges() {
    final first = _daysAgo(6);
    final now = _now();
    final since = DateTime(now.year, now.month, now.day - 6);
    late final StreamController<NudgeStats> controller;
    List<UsageDayRow>? days;
    int? overrides;
    StreamSubscription<List<UsageDayRow>>? a;
    StreamSubscription<int>? b;

    void emit() {
      final d = days, o = overrides;
      if (d == null || o == null || controller.isClosed) return;
      controller.add(
        NudgeStats(
          shown: d.fold(0, (s, r) => s + r.nudgesShown),
          accepted: d.fold(0, (s, r) => s + r.putDownAccepted),
          overrides: o,
        ),
      );
    }

    controller = StreamController<NudgeStats>(
      onListen: () {
        a = _db.watchDaysSince(first).listen((v) {
          days = v;
          emit();
        });
        b = _db.watchOverridesSince(since).listen((v) {
          overrides = v;
          emit();
        });
      },
      onCancel: () async {
        await a?.cancel();
        await b?.cancel();
      },
    );
    return controller.stream;
  }
}
