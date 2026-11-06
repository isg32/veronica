import 'dart:async';

import '../core/ids.dart';

/// The moment the remaining mock data is anchored to: when the app started,
/// to the minute (see `mockdata.md`). Ages, logs and timers are relative to it.
final DateTime mockNow = () {
  final t = DateTime.now();
  return DateTime(t.year, t.month, t.day, t.hour, t.minute);
}();

/// A value that emits its current state to every new listener and every
/// change after that. Mock repositories are built from these.
class MockCell<T> {
  MockCell(this._value);

  T _value;
  final StreamController<T> _changes = StreamController<T>.broadcast();

  T get value => _value;

  set value(T next) {
    _value = next;
    _changes.add(next);
  }

  void update(T Function(T current) change) => value = change(_value);

  Stream<T> watch() async* {
    yield _value;
    yield* _changes.stream;
  }
}

/// Short unique ids for things created while the app runs.
String mockId(String prefix) => newId(prefix);

/// A date relative to [mockNow].
DateTime daysAgo(int days, {int hour = 9, int minute = 0}) {
  final d = mockNow.subtract(Duration(days: days));
  return DateTime(d.year, d.month, d.day, hour, minute);
}
