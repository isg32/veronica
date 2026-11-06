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

String _$homeWidgetSyncHash() => r'e9cd18ca8487632851e8adc010600d74e87440ec';

/// Turns taps on the home widgets (`veronica://…` links) into actions.
///
/// | Link | Action |
/// | --- | --- |
/// | `veronica://focus` | open Focus |
/// | `veronica://water/add` | log a glass, open Care |
/// | `veronica://sleep` | open Sleep |
/// | `veronica://mode/<id>` | start that mode |
/// | `veronica://tasks` | open Tasks |
/// | `veronica://task/<id>` | open the task |
/// | `veronica://task/<id>/done` | complete the task |
/// | `veronica://mantra` | start the mantra session |

@ProviderFor(homeWidgetLaunch)
final homeWidgetLaunchProvider = HomeWidgetLaunchProvider._();

/// Turns taps on the home widgets (`veronica://…` links) into actions.
///
/// | Link | Action |
/// | --- | --- |
/// | `veronica://focus` | open Focus |
/// | `veronica://water/add` | log a glass, open Care |
/// | `veronica://sleep` | open Sleep |
/// | `veronica://mode/<id>` | start that mode |
/// | `veronica://tasks` | open Tasks |
/// | `veronica://task/<id>` | open the task |
/// | `veronica://task/<id>/done` | complete the task |
/// | `veronica://mantra` | start the mantra session |

final class HomeWidgetLaunchProvider
    extends $FunctionalProvider<void, void, void>
    with $Provider<void> {
  /// Turns taps on the home widgets (`veronica://…` links) into actions.
  ///
  /// | Link | Action |
  /// | --- | --- |
  /// | `veronica://focus` | open Focus |
  /// | `veronica://water/add` | log a glass, open Care |
  /// | `veronica://sleep` | open Sleep |
  /// | `veronica://mode/<id>` | start that mode |
  /// | `veronica://tasks` | open Tasks |
  /// | `veronica://task/<id>` | open the task |
  /// | `veronica://task/<id>/done` | complete the task |
  /// | `veronica://mantra` | start the mantra session |
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

String _$homeWidgetLaunchHash() => r'6f48f81527ca1e2579f5080d66c6963ebbf365e6';
