// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watcher.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Keeps the watcher's copy of the rules in step with the watched apps.

@ProviderFor(watcherRulesSync)
final watcherRulesSyncProvider = WatcherRulesSyncProvider._();

/// Keeps the watcher's copy of the rules in step with the watched apps.

final class WatcherRulesSyncProvider
    extends $FunctionalProvider<void, void, void>
    with $Provider<void> {
  /// Keeps the watcher's copy of the rules in step with the watched apps.
  WatcherRulesSyncProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'watcherRulesSyncProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$watcherRulesSyncHash();

  @$internal
  @override
  $ProviderElement<void> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  void create(Ref ref) {
    return watcherRulesSync(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$watcherRulesSyncHash() => r'7374ad1a17403f24e08ae5160b86a339ccf20a2c';

/// Opens the pages the watcher asks for (Put it down, Focus).

@ProviderFor(watcherRoutes)
final watcherRoutesProvider = WatcherRoutesProvider._();

/// Opens the pages the watcher asks for (Put it down, Focus).

final class WatcherRoutesProvider extends $FunctionalProvider<void, void, void>
    with $Provider<void> {
  /// Opens the pages the watcher asks for (Put it down, Focus).
  WatcherRoutesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'watcherRoutesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$watcherRoutesHash();

  @$internal
  @override
  $ProviderElement<void> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  void create(Ref ref) {
    return watcherRoutes(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$watcherRoutesHash() => r'cd4d6d18e7d5092599cf5dffc6d781809baf0d26';

@ProviderFor(watcherSetup)
final watcherSetupProvider = WatcherSetupProvider._();

final class WatcherSetupProvider
    extends
        $FunctionalProvider<
          AsyncValue<WatcherSetup>,
          WatcherSetup,
          FutureOr<WatcherSetup>
        >
    with $FutureModifier<WatcherSetup>, $FutureProvider<WatcherSetup> {
  WatcherSetupProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'watcherSetupProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$watcherSetupHash();

  @$internal
  @override
  $FutureProviderElement<WatcherSetup> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<WatcherSetup> create(Ref ref) {
    return watcherSetup(ref);
  }
}

String _$watcherSetupHash() => r'7b34a8e5f42afbc3f6feea631a8210e12ed40ef7';
