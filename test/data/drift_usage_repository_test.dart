import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:veronica/data/db/database.dart';
import 'package:veronica/data/models/models.dart';
import 'package:veronica/data/usage/drift_usage_repository.dart';
import 'package:veronica/mock/usage_mock.dart';

void main() {
  late VeronicaDatabase db;
  late DriftUsageRepository repo;
  var now = DateTime(2026, 11, 6, 21, 4);

  const insta = InstalledApp(
    packageName: 'com.instagram.android',
    name: 'Instagram',
  );

  setUp(() {
    now = DateTime(2026, 11, 6, 21, 4);
    db = VeronicaDatabase(NativeDatabase.memory());
    repo = DriftUsageRepository(db, const MockUsageSource(), () => now);
  });
  tearDown(() => db.close());

  test(
    'starts empty and watches an app with minutes from the source',
    () async {
      expect(await repo.watchWatched().first, isEmpty);
      await repo.watch(insta, dailyLimitMin: 60);
      final apps = await repo.watchWatched().first;
      expect(apps.single.name, 'Instagram');
      expect(apps.single.dailyLimitMin, 60);
      expect(apps.single.minutesToday, 42, reason: 'from the usage source');
      expect(apps.single.lastSevenDays, hasLength(7));
    },
  );

  test('updates rules and keeps them', () async {
    await repo.watch(insta, dailyLimitMin: 60);
    final app = (await repo.watchWatched().first).single;
    await repo.update(
      app.copyWith(dailyLimitMin: 45, hardBlock: true, nudgeAtPercent: 90),
    );
    final saved = (await repo.watchWatched().first).single;
    expect(saved.dailyLimitMin, 45);
    expect(saved.hardBlock, isTrue);
    expect(saved.nudgeAtPercent, 90);
  });

  test(
    'extensions stop at the daily allowance and reset the next day',
    () async {
      await repo.watch(insta, dailyLimitMin: 60);
      for (var i = 0; i < 4; i++) {
        await repo.extend(insta.packageName);
      }
      var app = (await repo.watchWatched().first).single;
      expect(app.extensionsUsedToday, 2);
      expect(app.extensionsLeft, 0);

      now = now.add(const Duration(days: 1));
      app = (await repo.watchWatched().first).single;
      expect(app.extensionsUsedToday, 0);
    },
  );

  test('counts nudges, put-downs and overrides for the week', () async {
    await repo.watch(insta, dailyLimitMin: 60);
    await repo.recordNudge(insta.packageName);
    await repo.recordNudge(insta.packageName);
    await repo.recordPutDown(insta.packageName);
    await repo.logOverride(insta.packageName);
    final stats = await repo.watchWeekNudges().first;
    expect(stats.shown, 2);
    expect(stats.accepted, 1);
    expect(stats.overrides, 1);

    // Eight days later, all of it has left the 7-day window.
    now = now.add(const Duration(days: 8));
    final later = await repo.watchWeekNudges().first;
    expect(later.shown, 0);
    expect(later.overrides, 0);
  });

  test('unwatching removes the app', () async {
    await repo.watch(insta, dailyLimitMin: 60);
    await repo.unwatch(insta.packageName);
    expect(await repo.watchWatched().first, isEmpty);
  });

  test('settings survive closing and reopening the database', () async {
    final dir = Directory.systemTemp.createTempSync('veronica_db');
    addTearDown(() => dir.deleteSync(recursive: true));
    final file = File('${dir.path}/veronica.sqlite');

    final first = VeronicaDatabase(NativeDatabase(file));
    await DriftUsageRepository(
      first,
      const MockUsageSource(),
      () => now,
    ).watch(insta, dailyLimitMin: 30);
    await first.close();

    final second = VeronicaDatabase(NativeDatabase(file));
    addTearDown(second.close);
    final apps = await DriftUsageRepository(
      second,
      const MockUsageSource(),
      () => now,
    ).watchWatched().first;
    expect(apps.single.dailyLimitMin, 30);
  });
}
