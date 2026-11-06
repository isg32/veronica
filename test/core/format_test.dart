import 'package:flutter_test/flutter_test.dart';
import 'package:veronica/core/format.dart';

void main() {
  final friday = DateTime(2026, 11, 6, 21, 4);

  test('durations', () {
    expect(VFormat.minutes(144), '2h 24m');
    expect(VFormat.minutes(45), '45m');
    expect(VFormat.minutes(180), '3h');
    expect(VFormat.clock(const Duration(minutes: 38, seconds: 12)), '38:12');
    expect(VFormat.clock(const Duration(hours: 1, seconds: 5)), '1:00:05');
  });

  test('ages', () {
    expect(VFormat.added(0), 'added today');
    expect(VFormat.added(1), 'added 1 day ago');
    expect(VFormat.added(10), 'added 10 days ago');
    expect(VFormat.ageShort(10), '10d');
    expect(VFormat.ageLong(10), '10 days');
  });

  test('dates', () {
    expect(VFormat.eyebrowDate(friday), 'FRIDAY 6 NOVEMBER');
    expect(VFormat.shortDate(DateTime(2026, 11, 20)), 'Fri 20 Nov');
    expect(VFormat.dayHeading(friday, friday), 'TODAY');
    expect(VFormat.dayLetter(friday), 'F');
  });

  test('day sets', () {
    expect(VFormat.days({1, 2, 3, 4, 5}), 'Mon–Fri');
    expect(VFormat.days({6, 7}), 'Sat, Sun');
    expect(VFormat.days({1, 2, 3, 4, 5, 6, 7}), 'Every day');
    expect(VFormat.daysWord({1, 2, 3, 4, 5}), 'weekdays');
    expect(VFormat.daysWord({6, 7}), 'weekends');
  });

  test('greeting', () {
    expect(VFormat.greeting(friday), 'Good evening');
    expect(VFormat.greeting(DateTime(2026, 11, 6, 7)), 'Good morning');
  });
}
