import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:veronica/data/db/database.dart';
import 'package:veronica/data/providers.dart';
import 'package:veronica/data/usage/drift_usage_repository.dart';
import 'package:veronica/mock/seed.dart';

/// A provider container for app-level tests: the real repositories over an
/// in-memory database, filled with the sample data unless [seed] is false.
/// Disposed after the test.
Future<ProviderContainer> testContainer({bool seed = true}) async {
  final db = VeronicaDatabase(NativeDatabase.memory());
  if (seed) await seedSampleData(db);
  final container = ProviderContainer(
    overrides: [
      databaseProvider.overrideWith((ref) {
        ref.onDispose(db.close);
        return db;
      }),
      // No periodic refresh, so no timers outlive a test.
      usageRepositoryProvider.overrideWith(
        (ref) => DriftUsageRepository(
          ref.watch(databaseProvider),
          ref.watch(usageSourceProvider),
          ref.watch(clockProvider).now,
          refreshEvery: null,
        ),
      ),
    ],
  );
  addTearDown(container.dispose);
  return container;
}
