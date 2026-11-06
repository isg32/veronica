import 'package:flutter_test/flutter_test.dart';
import 'package:veronica/mock/mock_cell.dart';
import 'package:veronica/mock/modes_mock.dart';
import 'package:veronica/mock/tasks_mock.dart';
import 'package:veronica/mock/usage_mock.dart';
import 'package:veronica/mock/water_mock.dart';

void main() {
  DateTime now() => mockNow;

  test('mock data matches the design canvas', () {
    final total = mockWatchedApps.fold<int>(0, (s, a) => s + a.minutesToday);
    final limits = mockWatchedApps.fold<int>(0, (s, a) => s + a.dailyLimitMin);
    expect(total, 144, reason: '2h 24m');
    expect(limits, 170, reason: '2h 50m');

    final binge = mockActiveMode();
    expect(
      binge.endsAt!.difference(mockNow),
      const Duration(minutes: 38, seconds: 12),
    );

    final open = mockTasks().where((t) => !t.isDone).toList();
    expect(open.length, 6);
    expect(open.first.ageDays(mockNow), 10);
  });

  test('tasks can be added, completed and deleted', () async {
    final repo = MockTaskRepository(now);
    final added = await repo.add(title: 'Call the bank');
    await repo.setDone(added.id, done: true);
    var all = await repo.watchAll().first;
    expect(all.singleWhere((t) => t.id == added.id).isDone, isTrue);
    await repo.delete(added.id);
    all = await repo.watchAll().first;
    expect(all.any((t) => t.id == added.id), isFalse);
  });

  test('water log and undo', () async {
    final repo = MockWaterRepository(now);
    await repo.logGlass();
    expect((await repo.watchToday().first).length, 6);
    await repo.undoLast();
    await repo.undoLast();
    expect((await repo.watchToday().first).length, 4);
  });

  test('extensions stop at the daily allowance', () async {
    final repo = MockUsageRepository();
    for (var i = 0; i < 5; i++) {
      await repo.extend('com.instagram.android');
    }
    final insta = (await repo.watchWatched().first).singleWhere(
      (a) => a.name == 'Instagram',
    );
    expect(insta.extensionsLeft, 0);
    expect(insta.extensionsUsedToday, insta.extensionsPerDay);
  });

  test('presets cannot be deleted', () async {
    final repo = MockModeRepository(now);
    await repo.delete('work');
    await repo.delete('reading');
    final ids = (await repo.watchModes().first).map((m) => m.id);
    expect(ids, contains('work'));
    expect(ids, isNot(contains('reading')));
  });

  test('WatchedApp reports minutes over', () {
    final yt = mockWatchedApps.first;
    expect(yt.isOver, isTrue);
    expect(yt.minutesOver, 15);
  });
}
