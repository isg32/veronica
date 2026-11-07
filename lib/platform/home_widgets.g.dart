// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_widgets.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Keeps the six native home widgets in step with the app.
///
/// Each widget is drawn from [HomeWidgetView] into a transparent PNG; the
/// native provider shows that image and turns taps into `veronica://` links.
/// Every widget is rendered twice, dark glass and light glass; Android
/// shows the one matching the system theme, so switching light or dark needs
/// no re-render. Widgets re-render when their data or glass settings change,
/// when the app is left or reopened, and once a minute while it runs (for
/// countdowns and "alarm in").

@ProviderFor(homeWidgetSync)
final homeWidgetSyncProvider = HomeWidgetSyncProvider._();

/// Keeps the six native home widgets in step with the app.
///
/// Each widget is drawn from [HomeWidgetView] into a transparent PNG; the
/// native provider shows that image and turns taps into `veronica://` links.
/// Every widget is rendered twice, dark glass and light glass; Android
/// shows the one matching the system theme, so switching light or dark needs
/// no re-render. Widgets re-render when their data or glass settings change,
/// when the app is left or reopened, and once a minute while it runs (for
/// countdowns and "alarm in").

final class HomeWidgetSyncProvider extends $FunctionalProvider<void, void, void>
    with $Provider<void> {
  /// Keeps the six native home widgets in step with the app.
  ///
  /// Each widget is drawn from [HomeWidgetView] into a transparent PNG; the
  /// native provider shows that image and turns taps into `veronica://` links.
  /// Every widget is rendered twice, dark glass and light glass; Android
  /// shows the one matching the system theme, so switching light or dark needs
  /// no re-render. Widgets re-render when their data or glass settings change,
  /// when the app is left or reopened, and once a minute while it runs (for
  /// countdowns and "alarm in").
  HomeWidgetSyncProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeWidgetSyncProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeWidgetSyncHash();

  @$internal
  @override
  $ProviderElement<void> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  void create(Ref ref) {
    return homeWidgetSync(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$homeWidgetSyncHash() => r'779089db524bf4e70792e1ac1be3863fd0ff89e4';

/// Opens the app where a home widget points (`veronica://…` links). Taps
/// that change something (+1 glass, a mode, a task) are handled by Android
/// without opening the app (see `WidgetActions.kt`).
///
/// | Link | Opens |
/// | --- | --- |
/// | `veronica://focus` | Focus |
/// | `veronica://care` | Care |
/// | `veronica://sleep` | Sleep |
/// | `veronica://mantra` | the mantra session |

@ProviderFor(homeWidgetLaunch)
final homeWidgetLaunchProvider = HomeWidgetLaunchProvider._();

/// Opens the app where a home widget points (`veronica://…` links). Taps
/// that change something (+1 glass, a mode, a task) are handled by Android
/// without opening the app (see `WidgetActions.kt`).
///
/// | Link | Opens |
/// | --- | --- |
/// | `veronica://focus` | Focus |
/// | `veronica://care` | Care |
/// | `veronica://sleep` | Sleep |
/// | `veronica://mantra` | the mantra session |

final class HomeWidgetLaunchProvider
    extends $FunctionalProvider<void, void, void>
    with $Provider<void> {
  /// Opens the app where a home widget points (`veronica://…` links). Taps
  /// that change something (+1 glass, a mode, a task) are handled by Android
  /// without opening the app (see `WidgetActions.kt`).
  ///
  /// | Link | Opens |
  /// | --- | --- |
  /// | `veronica://focus` | Focus |
  /// | `veronica://care` | Care |
  /// | `veronica://sleep` | Sleep |
  /// | `veronica://mantra` | the mantra session |
  HomeWidgetLaunchProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeWidgetLaunchProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeWidgetLaunchHash();

  @$internal
  @override
  $ProviderElement<void> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  void create(Ref ref) {
    return homeWidgetLaunch(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$homeWidgetLaunchHash() => r'e5718c5bafa2448810e056118cd95a62556f568e';
