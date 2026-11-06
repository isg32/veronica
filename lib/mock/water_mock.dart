import '../data/models/models.dart';
import '../data/repositories/repositories.dart';
import 'mock_cell.dart';

const WaterSettings mockWaterSettings = WaterSettings();

List<WaterLog> mockWaterToday() => [
  for (final (i, t) in const [
    DayTime(8, 10),
    DayTime(10, 5),
    DayTime(12, 20),
    DayTime(14, 0),
    DayTime(15, 40),
  ].indexed)
    WaterLog(id: 'w$i', at: t.on(mockNow), ml: mockWaterSettings.glassMl),
];

/// Glasses for Saturday → Thursday; today comes from the log.
const List<int> mockWaterPastSixDays = [8, 6, 7, 8, 4, 7];

class MockWaterRepository implements WaterRepository {
  MockWaterRepository(this._now);

  final DateTime Function() _now;
  final MockCell<WaterSettings> _settings = MockCell(mockWaterSettings);
  final MockCell<List<WaterLog>> _today = MockCell(mockWaterToday());

  @override
  Stream<WaterSettings> watchSettings() => _settings.watch();

  @override
  Future<void> saveSettings(WaterSettings settings) async =>
      _settings.value = settings;

  @override
  Stream<List<WaterLog>> watchToday() => _today.watch();

  @override
  Future<void> logGlass() async => _today.update(
    (logs) => [
      ...logs,
      WaterLog(id: mockId('w'), at: _now(), ml: _settings.value.glassMl),
    ],
  );

  @override
  Future<void> undoLast() async {
    if (_today.value.isEmpty) return;
    _today.update((logs) => logs.sublist(0, logs.length - 1));
  }

  @override
  Stream<List<WaterDay>> watchWeek() => _today.watch().map((today) {
    final goal = _settings.value.goalGlasses;
    return [
      for (var i = 0; i < 6; i++)
        WaterDay(
          date: daysAgo(6 - i),
          glasses: mockWaterPastSixDays[i],
          goal: goal,
        ),
      WaterDay(date: daysAgo(0), glasses: today.length, goal: goal),
    ];
  });
}
