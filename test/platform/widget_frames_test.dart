import 'package:flutter_test/flutter_test.dart';
import 'package:veronica/features/home_widgets/home_widget_views.dart';
import 'package:veronica/platform/home_widgets.dart';

HomeWidgetSnapshot snapshot({DateTime? alarmAt, DateTime? bingeEnds}) =>
    HomeWidgetSnapshot(
      usedMin: 0,
      limitMin: 0,
      water: 0,
      waterGoal: 8,
      alarmTime: alarmAt == null ? null : '07:00',
      alarmAt: alarmAt,
      modes: [
        WidgetMode(
          id: 'binge',
          label: 'Binge',
          active: bingeEnds != null,
          endsAt: bingeEnds,
        ),
      ],
      tasks: const [],
      mantra: null,
    );

void main() {
  final now = DateTime(2026, 11, 7, 21, 4);

  test('static widgets have one frame', () {
    expect(frameTimes(HomeWidgetKind.water, snapshot(), now), [now]);
  });

  test(
    'next alarm: hourly frames, then every 5 minutes in the last two hours',
    () {
      final alarm = DateTime(2026, 11, 8, 7);
      final data = snapshot(alarmAt: alarm);
      final times = frameTimes(HomeWidgetKind.nextAlarm, data, now);
      expect(times.first, now);
      expect(times.last, alarm);
      expect(times, contains(alarm.subtract(const Duration(hours: 5))));
      expect(times, contains(alarm.subtract(const Duration(minutes: 35))));

      // Each frame's label is the one shown from that moment on.
      expect(
        data.alarmInAt(alarm.subtract(const Duration(hours: 5))),
        'in 5 h',
      );
      expect(
        data.alarmInAt(alarm.subtract(const Duration(minutes: 35))),
        'in 35m',
      );
    },
  );

  test('Binge Time: a frame every minute in the last quarter hour', () {
    final end = now.add(const Duration(minutes: 38));
    final data = snapshot(bingeEnds: end);
    final times = frameTimes(HomeWidgetKind.modeSwitch, data, now);
    expect(times, contains(end.subtract(const Duration(minutes: 7))));
    expect(times, contains(end));
    expect(
      data.modes.single.leftAt(end.subtract(const Duration(minutes: 7))),
      '7 min',
    );
    expect(
      data.modes.single.leftAt(end.add(const Duration(seconds: 1))),
      'ended',
    );
  });
}
