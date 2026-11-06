// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selectors.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The current second (falls back to the clock before the first tick).

@ProviderFor(currentTime)
final currentTimeProvider = CurrentTimeProvider._();

/// The current second (falls back to the clock before the first tick).

final class CurrentTimeProvider
    extends $FunctionalProvider<DateTime, DateTime, DateTime>
    with $Provider<DateTime> {
  /// The current second (falls back to the clock before the first tick).
  CurrentTimeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentTimeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentTimeHash();

  @$internal
  @override
  $ProviderElement<DateTime> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DateTime create(Ref ref) {
    return currentTime(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime>(value),
    );
  }
}

String _$currentTimeHash() => r'658d86c68f1fbecf7d0414919aa3ea76a558e84b';

/// The mantra shown today: the fixed one, or (rotating) the one already shown
/// today, else the least recently shown.

@ProviderFor(todayMantra)
final todayMantraProvider = TodayMantraProvider._();

/// The mantra shown today: the fixed one, or (rotating) the one already shown
/// today, else the least recently shown.

final class TodayMantraProvider
    extends $FunctionalProvider<Mantra?, Mantra?, Mantra?>
    with $Provider<Mantra?> {
  /// The mantra shown today: the fixed one, or (rotating) the one already shown
  /// today, else the least recently shown.
  TodayMantraProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todayMantraProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todayMantraHash();

  @$internal
  @override
  $ProviderElement<Mantra?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Mantra? create(Ref ref) {
    return todayMantra(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Mantra? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Mantra?>(value),
    );
  }
}

String _$todayMantraHash() => r'5152f2ca3986689505d781b4680fdaae476ec73f';

/// Open tasks, oldest first.

@ProviderFor(openTasksOldestFirst)
final openTasksOldestFirstProvider = OpenTasksOldestFirstProvider._();

/// Open tasks, oldest first.

final class OpenTasksOldestFirstProvider
    extends $FunctionalProvider<List<Task>, List<Task>, List<Task>>
    with $Provider<List<Task>> {
  /// Open tasks, oldest first.
  OpenTasksOldestFirstProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'openTasksOldestFirstProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$openTasksOldestFirstHash();

  @$internal
  @override
  $ProviderElement<List<Task>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Task> create(Ref ref) {
    return openTasksOldestFirst(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Task> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Task>>(value),
    );
  }
}

String _$openTasksOldestFirstHash() =>
    r'e212d76cc7e0e8bdad886c2c0407ea38a910133f';

/// The next medicine dose (only when medicine is on), alarm and mantra.

@ProviderFor(nextUp)
final nextUpProvider = NextUpProvider._();

/// The next medicine dose (only when medicine is on), alarm and mantra.

final class NextUpProvider
    extends
        $FunctionalProvider<
          List<NextUpItem>,
          List<NextUpItem>,
          List<NextUpItem>
        >
    with $Provider<List<NextUpItem>> {
  /// The next medicine dose (only when medicine is on), alarm and mantra.
  NextUpProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nextUpProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nextUpHash();

  @$internal
  @override
  $ProviderElement<List<NextUpItem>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<NextUpItem> create(Ref ref) {
    return nextUp(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<NextUpItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<NextUpItem>>(value),
    );
  }
}

String _$nextUpHash() => r'866cd75367295fa4010edebcff94f96f9cf2c93a';

/// The next alarm that will ring, if any.

@ProviderFor(nextAlarm)
final nextAlarmProvider = NextAlarmProvider._();

/// The next alarm that will ring, if any.

final class NextAlarmProvider
    extends
        $FunctionalProvider<
          ({Alarm alarm, DateTime at})?,
          ({Alarm alarm, DateTime at})?,
          ({Alarm alarm, DateTime at})?
        >
    with $Provider<({Alarm alarm, DateTime at})?> {
  /// The next alarm that will ring, if any.
  NextAlarmProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nextAlarmProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nextAlarmHash();

  @$internal
  @override
  $ProviderElement<({Alarm alarm, DateTime at})?> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ({Alarm alarm, DateTime at})? create(Ref ref) {
    return nextAlarm(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(({Alarm alarm, DateTime at})? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<({Alarm alarm, DateTime at})?>(
        value,
      ),
    );
  }
}

String _$nextAlarmHash() => r'28c025ae011e5cb55a8a0fb6f62586f5fdd46efd';
