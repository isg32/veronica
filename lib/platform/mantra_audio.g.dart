// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mantra_audio.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Plays a listening session: the chosen mantra, or all of them in order.
///
/// Files play from the phone. YouTube videos stream as audio only; when a
/// video can't be streamed, it opens in the YouTube app instead and the
/// session moves on.

@ProviderFor(MantraPlayer)
final mantraPlayerProvider = MantraPlayerProvider._();

/// Plays a listening session: the chosen mantra, or all of them in order.
///
/// Files play from the phone. YouTube videos stream as audio only; when a
/// video can't be streamed, it opens in the YouTube app instead and the
/// session moves on.
final class MantraPlayerProvider
    extends $NotifierProvider<MantraPlayer, ListeningState> {
  /// Plays a listening session: the chosen mantra, or all of them in order.
  ///
  /// Files play from the phone. YouTube videos stream as audio only; when a
  /// video can't be streamed, it opens in the YouTube app instead and the
  /// session moves on.
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

String _$mantraPlayerHash() => r'2768af074d5f63da591d0eb87677f84a8e89bf51';

/// Plays a listening session: the chosen mantra, or all of them in order.
///
/// Files play from the phone. YouTube videos stream as audio only; when a
/// video can't be streamed, it opens in the YouTube app instead and the
/// session moves on.

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
