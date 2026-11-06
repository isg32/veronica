import '../data/models/models.dart';
import '../data/repositories/repositories.dart';
import 'mock_cell.dart';

/// Minutes per day, Saturday → Friday (today).
const List<WatchedApp> mockWatchedApps = [
  WatchedApp(
    packageName: 'com.google.android.youtube',
    name: 'YouTube',
    dailyLimitMin: 60,
    minutesToday: 75,
    extensionsUsedToday: 1,
    lastSevenDays: [70, 80, 55, 85, 60, 95, 75],
  ),
  WatchedApp(
    packageName: 'com.instagram.android',
    name: 'Instagram',
    dailyLimitMin: 60,
    minutesToday: 42,
    extensionsUsedToday: 1,
    lastSevenDays: [40, 50, 32, 59, 45, 52, 42],
  ),
  WatchedApp(
    packageName: 'com.twitter.android',
    name: 'X',
    dailyLimitMin: 30,
    minutesToday: 18,
    lastSevenDays: [20, 25, 22, 30, 18, 28, 18],
  ),
  WatchedApp(
    packageName: 'com.reddit.frontpage',
    name: 'Reddit',
    dailyLimitMin: 20,
    minutesToday: 9,
    lastSevenDays: [15, 14, 12, 18, 10, 20, 9],
  ),
];

const List<InstalledApp> mockInstalledApps = [
  InstalledApp(packageName: 'com.instagram.android', name: 'Instagram'),
  InstalledApp(packageName: 'com.google.android.youtube', name: 'YouTube'),
  InstalledApp(packageName: 'com.twitter.android', name: 'X'),
  InstalledApp(packageName: 'com.reddit.frontpage', name: 'Reddit'),
  InstalledApp(packageName: 'com.whatsapp', name: 'WhatsApp'),
  InstalledApp(packageName: 'com.android.chrome', name: 'Chrome'),
  InstalledApp(packageName: 'com.spotify.music', name: 'Spotify'),
  InstalledApp(packageName: 'com.netflix.mediaclient', name: 'Netflix'),
  InstalledApp(packageName: 'com.instagram.barcelona', name: 'Threads'),
  InstalledApp(packageName: 'org.telegram.messenger', name: 'Telegram'),
  InstalledApp(packageName: 'com.google.android.gm', name: 'Gmail'),
  InstalledApp(packageName: 'com.google.android.apps.maps', name: 'Maps'),
];

const NudgeStats mockWeekNudges = NudgeStats(
  shown: 9,
  accepted: 7,
  overrides: 0,
);

class MockUsageRepository implements UsageRepository {
  final MockCell<List<WatchedApp>> _watched = MockCell([...mockWatchedApps]);
  final MockCell<NudgeStats> _nudges = MockCell(mockWeekNudges);

  @override
  Stream<List<WatchedApp>> watchWatched() => _watched.watch();

  @override
  Stream<List<InstalledApp>> watchInstalled() =>
      Stream.value(mockInstalledApps);

  @override
  Future<void> watch(InstalledApp app, {required int dailyLimitMin}) async {
    if (_watched.value.any((w) => w.packageName == app.packageName)) return;
    _watched.update(
      (list) => [
        ...list,
        WatchedApp(
          packageName: app.packageName,
          name: app.name,
          dailyLimitMin: dailyLimitMin,
          lastSevenDays: const [0, 0, 0, 0, 0, 0, 0],
        ),
      ],
    );
  }

  @override
  Future<void> unwatch(String packageName) async => _watched.update(
    (list) => list.where((w) => w.packageName != packageName).toList(),
  );

  @override
  Future<void> update(WatchedApp app) async => _watched.update(
    (list) => [
      for (final w in list) w.packageName == app.packageName ? app : w,
    ],
  );

  @override
  Future<void> extend(String packageName) async => _watched.update(
    (list) => [
      for (final w in list)
        w.packageName == packageName && w.extensionsLeft > 0
            ? w.copyWith(extensionsUsedToday: w.extensionsUsedToday + 1)
            : w,
    ],
  );

  @override
  Future<void> logOverride(String packageName) async => _nudges.update(
    (n) => NudgeStats(
      shown: n.shown,
      accepted: n.accepted,
      overrides: n.overrides + 1,
    ),
  );

  @override
  Future<void> recordNudge(String packageName) async => _nudges.update(
    (n) => NudgeStats(
      shown: n.shown + 1,
      accepted: n.accepted,
      overrides: n.overrides,
    ),
  );

  @override
  Future<void> recordPutDown(String packageName) async => _nudges.update(
    (n) => NudgeStats(
      shown: n.shown,
      accepted: n.accepted + 1,
      overrides: n.overrides,
    ),
  );

  @override
  Stream<NudgeStats> watchWeekNudges() => _nudges.watch();
}

/// A fixed [UsageSource]: the sample apps and their minutes. Used in tests
/// and wherever the phone's usage stats are not available.
class MockUsageSource implements UsageSource {
  const MockUsageSource();

  @override
  Future<List<InstalledApp>> installedApps() async => mockInstalledApps;

  @override
  Future<Map<String, List<int>>> lastSevenDays(Set<String> packageNames) async {
    final byPackage = {
      for (final a in mockWatchedApps) a.packageName: a.lastSevenDays,
    };
    return {
      for (final p in packageNames)
        p: byPackage[p] ?? const [0, 0, 0, 0, 0, 0, 0],
    };
  }
}
