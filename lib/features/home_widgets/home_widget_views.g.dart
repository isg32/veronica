// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_widget_views.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The widget data right now. Times are rounded to the minute so the native
/// widgets don't need re-rendering every second.

@ProviderFor(homeWidgetSnapshot)
final homeWidgetSnapshotProvider = HomeWidgetSnapshotProvider._();

/// The widget data right now. Times are rounded to the minute so the native
/// widgets don't need re-rendering every second.

final class HomeWidgetSnapshotProvider
    extends
        $FunctionalProvider<
          HomeWidgetSnapshot,
          HomeWidgetSnapshot,
          HomeWidgetSnapshot
        >
    with $Provider<HomeWidgetSnapshot> {
  /// The widget data right now. Times are rounded to the minute so the native
  /// widgets don't need re-rendering every second.
  HomeWidgetSnapshotProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeWidgetSnapshotProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeWidgetSnapshotHash();

  @$internal
  @override
  $ProviderElement<HomeWidgetSnapshot> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  HomeWidgetSnapshot create(Ref ref) {
    return homeWidgetSnapshot(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HomeWidgetSnapshot value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HomeWidgetSnapshot>(value),
    );
  }
}

String _$homeWidgetSnapshotHash() =>
    r'1f8789f48b53cb3a7a263413cd3da2d5c8b5869b';
