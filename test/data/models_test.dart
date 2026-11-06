import 'package:flutter_test/flutter_test.dart';
import 'package:veronica/core/widgets/v_surface.dart';
import 'package:veronica/core/widgets/v_tiles.dart';
import 'package:veronica/data/models/models.dart';

void main() {
  group('DayTime', () {
    test('formats as 24 h', () {
      expect(const DayTime(7, 5).label, '07:05');
    });

    test('counts minutes forward across midnight', () {
      expect(const DayTime(23, 30).minutesUntil(const DayTime(7, 0)), 450);
      expect(const DayTime(7, 0).minutesUntil(const DayTime(23, 0)), 960);
    });
  });

  group('Task age', () {
    final now = DateTime(2026, 11, 6, 21, 4);

    test('counts calendar days, not 24 h blocks', () {
      final lateYesterday = Task(
        id: 'a',
        title: 'a',
        createdAt: DateTime(2026, 11, 5, 23, 59),
      );
      expect(lateYesterday.ageDays(now), 1);
    });

    test('outline gets heavier at 3 days and dashed at 7', () {
      expect(TaskAgeOutline.forDays(2).width, 1);
      expect(TaskAgeOutline.forDays(3).width, 2);
      expect(TaskAgeOutline.forDays(5).width, 2.5);
      expect(TaskAgeOutline.forDays(7).outline, VOutline.dashed);
    });
  });

  test('water reminders spread over the waking window', () {
    // 07:00–23:00 for 8 glasses → every 2 h (onboarding shows "2 h").
    expect(const WaterSettings().interval, const Duration(hours: 2));
    expect(const WaterSettings().goalMl, 2000);
  });

  test('sleep length and wind-down start', () {
    const s = SleepSchedule();
    expect(s.sleepLength, const Duration(hours: 7, minutes: 30));
    expect(s.windDownStart, const DayTime(23, 0));
  });
}
