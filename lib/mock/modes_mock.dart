import '../data/models/models.dart';
import '../data/repositories/repositories.dart';
import 'mock_cell.dart';

const _social = {
  'com.instagram.android',
  'com.google.android.youtube',
  'com.twitter.android',
  'com.reddit.frontpage',
};

const List<Mode> mockModes = [
  Mode(
    id: 'work',
    name: 'Work',
    purpose: 'Deep focus',
    isPreset: true,
    greyscale: true,
    dnd: DndPolicy.starred,
    appPolicy: AppPolicy.blocked,
    blockedApps: _social,
    timer: ModeTimer.pomodoro25,
    glyph: GlyphPattern.focusPulse,
    schedule: ModeSchedule(
      days: Weekdays.weekdays,
      start: DayTime(10, 0),
      end: DayTime(13, 0),
    ),
  ),
  Mode(
    id: 'go-out',
    name: 'Go Out',
    purpose: 'Be present with people',
    isPreset: true,
    greyscale: true,
    dnd: DndPolicy.calls,
    appPolicy: AppPolicy.nudgeAfter,
    waterOn: false,
    glyph: GlyphPattern.callsOnly,
  ),
  Mode(
    id: 'binge',
    name: 'Binge Time',
    purpose: 'Guilt-free leisure, with a cap',
    isPreset: true,
    appPolicy: AppPolicy.allowed,
    timer: ModeTimer.fixed,
    timerMin: 60,
    glyph: GlyphPattern.countdown,
  ),
  Mode(
    id: 'reading',
    name: 'Reading',
    purpose: 'Paper books, phone away',
    greyscale: true,
    dnd: DndPolicy.starred,
    appPolicy: AppPolicy.blocked,
    blockedApps: _social,
    waterOn: false,
    brightness: 0.3,
    ringer: RingerMode.silent,
    hideNotifications: true,
    blackWallpaper: true,
  ),
];

/// Binge Time started 21:48 ago with a 60-minute cap: 38:12 left at 21:04.
ActiveMode mockActiveMode() => ActiveMode(
  modeId: 'binge',
  startedAt: mockNow.subtract(const Duration(minutes: 21, seconds: 48)),
  endsAt: mockNow.add(const Duration(minutes: 38, seconds: 12)),
);

class MockModeRepository implements ModeRepository {
  MockModeRepository(this._now);

  final DateTime Function() _now;
  final MockCell<List<Mode>> _modes = MockCell([...mockModes]);
  final MockCell<ActiveMode?> _active = MockCell(mockActiveMode());

  @override
  Stream<List<Mode>> watchModes() => _modes.watch();

  @override
  Future<void> save(Mode mode) async => _modes.update((list) {
    final exists = list.any((m) => m.id == mode.id);
    return exists
        ? [for (final m in list) m.id == mode.id ? mode : m]
        : [...list, mode];
  });

  @override
  Future<void> delete(String id) async {
    if (_active.value?.modeId == id) _active.value = null;
    _modes.update(
      (list) => list.where((m) => m.id != id || m.isPreset).toList(),
    );
  }

  @override
  Stream<ActiveMode?> watchActive() => _active.watch();

  @override
  Future<void> start(String modeId, {int? minutes}) async {
    final now = _now();
    _active.value = ActiveMode(
      modeId: modeId,
      startedAt: now,
      endsAt: minutes == null ? null : now.add(Duration(minutes: minutes)),
    );
  }

  @override
  Future<void> end() async => _active.value = null;

  @override
  Future<void> adopt(ActiveMode? active) async => _active.value = active;
}
