// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mantra_audio.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The media service playing listening sessions; [initMantraAudio] makes
/// it in main(), which overrides this.

@ProviderFor(mantraHandler)
final mantraHandlerProvider = MantraHandlerProvider._();

/// The media service playing listening sessions; [initMantraAudio] makes
/// it in main(), which overrides this.

final class MantraHandlerProvider
    extends
        $FunctionalProvider<
          MantraAudioHandler,
          MantraAudioHandler,
          MantraAudioHandler
        >
    with $Provider<MantraAudioHandler> {
  /// The media service playing listening sessions; [initMantraAudio] makes
  /// it in main(), which overrides this.
  MantraHandlerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mantraHandlerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mantraHandlerHash();

  @$internal
  @override
  $ProviderElement<MantraAudioHandler> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MantraAudioHandler create(Ref ref) {
    return mantraHandler(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MantraAudioHandler value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MantraAudioHandler>(value),
    );
  }
}

String _$mantraHandlerHash() => r'f8ad7e0258189bfea376aaf2ecb1c77b7e94db90';

/// The listening session, for the pages (see [MantraAudioHandler]).

@ProviderFor(MantraPlayer)
final mantraPlayerProvider = MantraPlayerProvider._();

/// The listening session, for the pages (see [MantraAudioHandler]).
final class MantraPlayerProvider
    extends $NotifierProvider<MantraPlayer, ListeningState> {
  /// The listening session, for the pages (see [MantraAudioHandler]).
  MantraPlayerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mantraPlayerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mantraPlayerHash();

  @$internal
  @override
  MantraPlayer create() => MantraPlayer();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ListeningState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ListeningState>(value),
    );
  }
}

String _$mantraPlayerHash() => r'7528d19a6718ef02ee312043b37e8701f45899c0';

/// The listening session, for the pages (see [MantraAudioHandler]).

abstract class _$MantraPlayer extends $Notifier<ListeningState> {
  ListeningState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ListeningState, ListeningState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ListeningState, ListeningState>,
              ListeningState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
