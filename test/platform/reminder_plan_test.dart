import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:veronica/data/db/database.dart';
import 'package:veronica/data/providers.dart';
import 'package:veronica/mock/seed.dart';
import 'package:veronica/platform/reminders.dart';

void main() {
  late VeronicaDatabase db;
  late ProviderContainer container;

  setUp(() async {
    db = VeronicaDatabase(NativeDatabase.memory());
    await seedSampleData(db);
    container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(db),
        // A fixed "now", so no ticking timer outlives the test.
        nowProvider.overrideWith((ref) => Stream.value(DateTime.now())),
      ],
    );
  });
  tearDown(() async {
    container.dispose();
    await db.close();
  });

  Future<List<PlannedReminder>> plan() async {
    // Let every stream behind the plan deliver its first value.
    final sub = container.listen(reminderPlanProvider, (_, _) {});
    for (var i = 0; i < 20; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 10));
    }
    final value = container.read(reminderPlanProvider);
    sub.close();
    return value;
  }

  test('the plan covers water and medicine', () async {
    // (The sample alarms may fall outside the next 48 hours, depending on
    // the weekday, so they are not asserted here.)
    final kinds = (await plan()).map((r) => r.kind).toSet();
    expect(kinds, containsAll(['water', 'medicine']));
  });

  test('a mantra session is planned once there is a mantra', () async {
    expect((await plan()).where((r) => r.kind == 'mantra'), isEmpty);
    await db
        .into(db.audioMantras)
        .insert(
          AudioMantrasCompanion.insert(
            id: 'listen-1',
            title: 'Om chanting',
            source: '/x.flac',
            addedAt: 0,
          ),
        );
    final mantra = (await plan()).where((r) => r.kind == 'mantra');
    expect(mantra, isNotEmpty);
    expect(mantra.first.body, 'Om chanting');
    expect(mantra.first.route, '/now/mantra-time');
  });

  test(
    'a snoozed dose comes back in 15 minutes, and taking it clears it',
    () async {
      await snoozeMedicine(db, 'm2');
      var reminders = await plan();
      final snoozed = reminders.where((r) => r.id.startsWith('med-snooze-m2'));
      expect(snoozed, hasLength(1));
      expect(
        snoozed.single.at.difference(DateTime.now()).inMinutes,
        inInclusiveRange(13, 15),
      );

      await snoozeMedicine(db, null);
      reminders = await plan();
      expect(reminders.where((r) => r.id.startsWith('med-snooze')), isEmpty);
    },
  );

  test('a task due tomorrow reminds at 9:00, until it is done', () async {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final tasks = container.read(taskRepositoryProvider);
    await tasks.add(title: 'Call the bank', dueAt: tomorrow);

    var reminders = await plan();
    final task = reminders.where((r) => r.kind == 'task').single;
    expect(task.title, 'Call the bank');
    expect(task.at, tomorrow.add(const Duration(hours: 9)));
    expect(task.task, isNotNull);

    await tasks.setDone(task.task!, done: true);
    reminders = await plan();
    expect(reminders.where((r) => r.kind == 'task'), isEmpty);
  });
}
