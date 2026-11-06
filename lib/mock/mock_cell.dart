import 'dart:async';

import '../core/ids.dart';

/// The moment all mock data is anchored to (see `mockdata.md`).
final DateTime mockNow = DateTime(2026, 11, 6, 21, 4);

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
