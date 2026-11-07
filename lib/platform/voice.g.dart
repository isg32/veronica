// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voice.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Download and readiness of the Kokoro model, with progress.
///
/// Android's DownloadManager fetches it, so the download carries on in the
/// background with its own notification, even if Veronica is closed. When
/// it has finished, the app unpacks it (straight away if open, else the
/// next time it runs).

@ProviderFor(VoiceModel)
final voiceModelProvider = VoiceModelProvider._();

/// Download and readiness of the Kokoro model, with progress.
///
/// Android's DownloadManager fetches it, so the download carries on in the
/// background with its own notification, even if Veronica is closed. When
/// it has finished, the app unpacks it (straight away if open, else the
/// next time it runs).
final class VoiceModelProvider
    extends
        $AsyncNotifierProvider<
          VoiceModel,
          ({double progress, VoiceModelState state})
        > {
  /// Download and readiness of the Kokoro model, with progress.
  ///
  /// Android's DownloadManager fetches it, so the download carries on in the
  /// background with its own notification, even if Veronica is closed. When
  /// it has finished, the app unpacks it (straight away if open, else the
  /// next time it runs).
  VoiceModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'voiceModelProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$voiceModelHash();

  @$internal
  @override
  VoiceModel create() => VoiceModel();
}

String _$voiceModelHash() => r'1995c87ecd339f8362ad3f04cd1dc213d72122f9';

/// Download and readiness of the Kokoro model, with progress.
///
/// Android's DownloadManager fetches it, so the download carries on in the
/// background with its own notification, even if Veronica is closed. When
/// it has finished, the app unpacks it (straight away if open, else the
/// next time it runs).

abstract class _$VoiceModel
    extends $AsyncNotifier<({double progress, VoiceModelState state})> {
  FutureOr<({double progress, VoiceModelState state})> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<({double progress, VoiceModelState state})>,
              ({double progress, VoiceModelState state})
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<({double progress, VoiceModelState state})>,
                ({double progress, VoiceModelState state})
              >,
              AsyncValue<({double progress, VoiceModelState state})>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(veronicaVoice)
final veronicaVoiceProvider = VeronicaVoiceProvider._();

final class VeronicaVoiceProvider
    extends $FunctionalProvider<VeronicaVoice, VeronicaVoice, VeronicaVoice>
    with $Provider<VeronicaVoice> {
  VeronicaVoiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'veronicaVoiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$veronicaVoiceHash();

  @$internal
  @override
  $ProviderElement<VeronicaVoice> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  VeronicaVoice create(Ref ref) {
    return veronicaVoice(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VeronicaVoice value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VeronicaVoice>(value),
    );
  }
}

String _$veronicaVoiceHash() => r'658b8f7627c53486e2e883cebca6f976c0b9fa9c';

/// Pre-renders the fixed lines once the model is ready, and again when the
/// voice, speed or name changes.

@ProviderFor(voicePrerender)
final voicePrerenderProvider = VoicePrerenderProvider._();

/// Pre-renders the fixed lines once the model is ready, and again when the
/// voice, speed or name changes.

final class VoicePrerenderProvider extends $FunctionalProvider<void, void, void>
    with $Provider<void> {
  /// Pre-renders the fixed lines once the model is ready, and again when the
  /// voice, speed or name changes.
  VoicePrerenderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'voicePrerenderProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$voicePrerenderHash();

  @$internal
  @override
  $ProviderElement<void> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  void create(Ref ref) {
    return voicePrerender(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$voicePrerenderHash() => r'35cda2eb368977cc0cfd1fb58a7f916d0795fa58';
