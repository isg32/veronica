/// Source of "now", so mock data and the UI agree on the time.
abstract class Clock {
  const Clock();

  /// The real system time.
  const factory Clock.system() = _SystemClock;

  /// Starts at [start] and runs forward in real time from there.
  factory Clock.from(DateTime start) = _OffsetClock;

  DateTime now();
}

class _SystemClock extends Clock {
  const _SystemClock();

  @override
  DateTime now() => DateTime.now();
}

class _OffsetClock extends Clock {
  _OffsetClock(this.start) : _watch = Stopwatch()..start();

  final DateTime start;
  final Stopwatch _watch;

  @override
  DateTime now() => start.add(_watch.elapsed);
}
