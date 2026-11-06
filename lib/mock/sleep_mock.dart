import '../data/models/models.dart';
import '../data/repositories/repositories.dart';
import 'mock_cell.dart';
import 'sounds_mock.dart';

const SleepSchedule mockSleepSchedule = SleepSchedule();

const List<Alarm> mockAlarms = [
  Alarm(id: 'a1', time: DayTime(7, 0), days: Weekdays.weekdays, soundId: 's1'),
  Alarm(
    id: 'a2',
    time: DayTime(9, 0),
    days: Weekdays.weekend,
    soundId: 's2',
    enabled: false,
    glyphSunrise: false,
  ),
];

/// The seven nights before today, oldest first (Fri 30 Oct → Thu 5 Nov).
/// Weekend nights plan 8 h, weekdays 7 h 30 m; actual averages 6 h 48 m.
List<NightLog> mockNights() {
  const actual = [400, 430, 330, 450, 372, 470, 404];
  return [
    for (var i = 0; i < 7; i++)
      NightLog(
        date: daysAgo(7 - i, hour: 23, minute: 30),
        planned: Duration(minutes: i < 2 ? 480 : 450),
        actual: Duration(minutes: actual[i]),
      ),
  ];
}

class MockSleepRepository implements SleepRepository {
  MockSleepRepository(this._now);

  final DateTime Function() _now;
  final MockCell<SleepSchedule> _schedule = MockCell(mockSleepSchedule);
  final MockCell<List<Alarm>> _alarms = MockCell([...mockAlarms]);
  final MockCell<List<AlarmSound>> _sounds = MockCell(mockSounds());

  @override
  Stream<SleepSchedule> watchSchedule() => _schedule.watch();

  @override
  Future<void> saveSchedule(SleepSchedule schedule) async =>
      _schedule.value = schedule;

  @override
  Stream<List<Alarm>> watchAlarms() => _alarms.watch();

  @override
  Future<void> saveAlarm(Alarm alarm) async => _alarms.update((list) {
    final exists = list.any((a) => a.id == alarm.id);
    final next = exists
        ? [for (final a in list) a.id == alarm.id ? alarm : a]
        : [...list, alarm];
    return next..sort((a, b) => a.time.compareTo(b.time));
  });

  @override
  Future<void> deleteAlarm(String id) async =>
      _alarms.update((list) => list.where((a) => a.id != id).toList());

  @override
  Stream<List<NightLog>> watchNights() => Stream.value(mockNights());

  @override
  Stream<List<AlarmSound>> watchSounds() => _sounds.watch();

  /// The mock "imports" a placeholder; the real one opens the file picker.
  @override
  Future<void> importSound() async => _sounds.update(
    (list) => [
      ...list,
      AlarmSound(
        id: mockId('s'),
        name: 'New sound ${list.length + 1}',
        length: const Duration(seconds: 30),
        importedAt: _now(),
      ),
    ],
  );

  @override
  Future<void> renameSound(String id, String name) async => _sounds.update(
    (list) => [for (final s in list) s.id == id ? s.rename(name) : s],
  );

  @override
  Future<void> deleteSound(String id) async =>
      _sounds.update((list) => list.where((s) => s.id != id).toList());
}
