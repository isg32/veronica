// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mode_engine.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Keeps the phone in step with the running mode:
/// - starting a mode applies it natively (greyscale, Do Not Disturb, …) and
///   arms its "Time's up"; ending it restores the phone;
/// - mode schedules are armed as exact alarms that work with the app closed;
/// - a mode a schedule started or ended while the app was away is picked up
///   when the app starts or comes back.

@ProviderFor(modeEngine)
final modeEngineProvider = ModeEngineProvider._();

/// Keeps the phone in step with the running mode:
/// - starting a mode applies it natively (greyscale, Do Not Disturb, …) and
///   arms its "Time's up"; ending it restores the phone;
/// - mode schedules are armed as exact alarms that work with the app closed;
/// - a mode a schedule started or ended while the app was away is picked up
///   when the app starts or comes back.

final class ModeEngineProvider extends $FunctionalProvider<void, void, void>
    with $Provider<void> {
  /// Keeps the phone in step with the running mode:
  /// - starting a mode applies it natively (greyscale, Do Not Disturb, …) and
  ///   arms its "Time's up"; ending it restores the phone;
  /// - mode schedules are armed as exact alarms that work with the app closed;
  /// - a mode a schedule started or ended while the app was away is picked up
  ///   when the app starts or comes back.
  ModeEngineProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'modeEngineProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$modeEngineHash();

  @$internal
  @override
  $ProviderElement<void> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  void create(Ref ref) {
    return modeEngine(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$modeEngineHash() => r'87dead89ccfb19881b5b8e15a7e7b7f676144c45';
