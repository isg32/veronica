import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:veronica/data/db/database.dart';
import 'package:veronica/data/providers.dart';
import 'package:veronica/data/usage/drift_usage_repository.dart';

/// A provider container for app-level tests: real repositories, but an
/// in-memory database so nothing touches the disk. Disposed after the test.
ProviderContainer testContainer() {
  final container = ProviderContainer(
    overrides: [
      databaseProvider.overrideWith((ref) {
        final db = VeronicaDatabase(NativeDatabase.memory());
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
