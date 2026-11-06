/// A wall-clock time of day (no date), e.g. 07:00 or 23:30.
class DayTime implements Comparable<DayTime> {
  const DayTime(this.hour, this.minute)
    : assert(hour >= 0 && hour < 24),
      assert(minute >= 0 && minute < 60);

  factory DayTime.fromMinutes(int minutes) {
    final m = minutes % (24 * 60);
    return DayTime(m ~/ 60, m % 60);
  }

  factory DayTime.of(DateTime t) => DayTime(t.hour, t.minute);

  final int hour;
  final int minute;

  int get inMinutes => hour * 60 + minute;

  DayTime add(Duration d) => DayTime.fromMinutes(inMinutes + d.inMinutes);

  /// Today's (or [day]'s) date at this time.
  DateTime on(DateTime day) =>
      DateTime(day.year, day.month, day.day, hour, minute);

  /// Minutes from this time forward to [other], wrapping past midnight.
  int minutesUntil(DayTime other) {
    final diff = other.inMinutes - inMinutes;
    return diff < 0 ? diff + 24 * 60 : diff;
  }

  /// `07:00`.
  String get label =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

  @override
  int compareTo(DayTime other) => inMinutes.compareTo(other.inMinutes);

  @override
  bool operator ==(Object other) =>
      other is DayTime && other.hour == hour && other.minute == minute;

  @override
  int get hashCode => Object.hash(hour, minute);

  @override
  String toString() => label;
}

/// Weekdays as `DateTime.weekday` numbers: 1 = Monday … 7 = Sunday.
abstract final class Weekdays {
  static const Set<int> all = {1, 2, 3, 4, 5, 6, 7};
  static const Set<int> weekdays = {1, 2, 3, 4, 5};
  static const Set<int> weekend = {6, 7};
}
