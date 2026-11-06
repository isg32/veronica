// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'android_usage.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Whether Veronica can read app usage. Invalidate to re-check.

@ProviderFor(usageAccess)
final usageAccessProvider = UsageAccessProvider._();

/// Whether Veronica can read app usage. Invalidate to re-check.

final class UsageAccessProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Whether Veronica can read app usage. Invalidate to re-check.
  UsageAccessProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'usageAccessProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$usageAccessHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return usageAccess(ref);
  }
}

String _$usageAccessHash() => r'85e88345146b8f2edbb2153189e31ff90d793ee3';
