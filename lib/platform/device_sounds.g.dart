// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_sounds.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Lists the phone's own alarm tones in the sound library, once each time
/// the app starts, so alarms can use them without importing anything.

@ProviderFor(phoneSoundsSync)
final phoneSoundsSyncProvider = PhoneSoundsSyncProvider._();

/// Lists the phone's own alarm tones in the sound library, once each time
/// the app starts, so alarms can use them without importing anything.

final class PhoneSoundsSyncProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Lists the phone's own alarm tones in the sound library, once each time
  /// the app starts, so alarms can use them without importing anything.
  PhoneSoundsSyncProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'phoneSoundsSyncProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$phoneSoundsSyncHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return phoneSoundsSync(ref);
  }
}

String _$phoneSoundsSyncHash() => r'8b22ae207b8eb939b7ab7f5ea28052d73a6b5580';
