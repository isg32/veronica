// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallpaper.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Persisted in the widgets' native shared preferences (via home_widget), so
/// it survives restarts and needs no extra storage.

@ProviderFor(WidgetGlassController)
final widgetGlassControllerProvider = WidgetGlassControllerProvider._();

/// Persisted in the widgets' native shared preferences (via home_widget), so
/// it survives restarts and needs no extra storage.
final class WidgetGlassControllerProvider
    extends $AsyncNotifierProvider<WidgetGlassController, WidgetGlassSettings> {
  /// Persisted in the widgets' native shared preferences (via home_widget), so
  /// it survives restarts and needs no extra storage.
  WidgetGlassControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'widgetGlassControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$widgetGlassControllerHash();

  @$internal
  @override
  WidgetGlassController create() => WidgetGlassController();
}

String _$widgetGlassControllerHash() =>
    r'8a39692b81bda288b1762f4b1e6a7a3c7dcfefd9';

/// Persisted in the widgets' native shared preferences (via home_widget), so
/// it survives restarts and needs no extra storage.

abstract class _$WidgetGlassController
    extends $AsyncNotifier<WidgetGlassSettings> {
  FutureOr<WidgetGlassSettings> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<WidgetGlassSettings>, WidgetGlassSettings>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<WidgetGlassSettings>, WidgetGlassSettings>,
              AsyncValue<WidgetGlassSettings>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Whether Veronica may read the wallpaper. Re-checked on demand.

@ProviderFor(wallpaperAccess)
final wallpaperAccessProvider = WallpaperAccessProvider._();

/// Whether Veronica may read the wallpaper. Re-checked on demand.

final class WallpaperAccessProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Whether Veronica may read the wallpaper. Re-checked on demand.
  WallpaperAccessProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'wallpaperAccessProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$wallpaperAccessHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return wallpaperAccess(ref);
  }
}

String _$wallpaperAccessHash() => r'4ae11f232edd8397f983f413f77f06a3dc3501a3';

/// The current wallpaper, re-read only when its id changes.

@ProviderFor(WallpaperImage)
final wallpaperImageProvider = WallpaperImageProvider._();

/// The current wallpaper, re-read only when its id changes.
final class WallpaperImageProvider
    extends $AsyncNotifierProvider<WallpaperImage, ui.Image?> {
  /// The current wallpaper, re-read only when its id changes.
  WallpaperImageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'wallpaperImageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$wallpaperImageHash();

  @$internal
  @override
  WallpaperImage create() => WallpaperImage();
}

String _$wallpaperImageHash() => r'96750f8a113e38a86483e3ec8d4ad4fa2da1fb1d';

/// The current wallpaper, re-read only when its id changes.

abstract class _$WallpaperImage extends $AsyncNotifier<ui.Image?> {
  FutureOr<ui.Image?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<ui.Image?>, ui.Image?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ui.Image?>, ui.Image?>,
              AsyncValue<ui.Image?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
