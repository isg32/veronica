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

  test('the plan covers water, medicine and the mantra', () async {
    // (The sample alarms may fall outside the next 48 hours, depending on
    // the weekday, so they are not asserted here.)
    final kinds = (await plan()).map((r) => r.kind).toSet();
    expect(kinds, containsAll(['water', 'medicine', 'mantra']));
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
}
