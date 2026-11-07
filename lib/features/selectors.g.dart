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

/// The current minute. Most screens only change once a minute, so they
/// watch this instead of [currentTimeProvider] and don't rebuild every
/// second; only countdowns need the seconds.

@ProviderFor(currentMinute)
final currentMinuteProvider = CurrentMinuteProvider._();

/// The current minute. Most screens only change once a minute, so they
/// watch this instead of [currentTimeProvider] and don't rebuild every
/// second; only countdowns need the seconds.

final class CurrentMinuteProvider
    extends $FunctionalProvider<DateTime, DateTime, DateTime>
    with $Provider<DateTime> {
  /// The current minute. Most screens only change once a minute, so they
  /// watch this instead of [currentTimeProvider] and don't rebuild every
  /// second; only countdowns need the seconds.
  CurrentMinuteProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentMinuteProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentMinuteHash();

  @$internal
  @override
  $ProviderElement<DateTime> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DateTime create(Ref ref) {
    return currentMinute(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime>(value),
    );
  }
}

String _$currentMinuteHash() => r'77b968b8bc813e2055b08247731ce9c7d51f4742';

/// The mantra shown today: the fixed one, or (rotating) one per calendar day.

@ProviderFor(todayMantra)
final todayMantraProvider = TodayMantraProvider._();

/// The mantra shown today: the fixed one, or (rotating) one per calendar day.

final class TodayMantraProvider
    extends $FunctionalProvider<Mantra?, Mantra?, Mantra?>
    with $Provider<Mantra?> {
  /// The mantra shown today: the fixed one, or (rotating) one per calendar day.
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

String _$todayMantraHash() => r'b3f9656d42b7892c1d197c5414da70fe2dd7de0c';

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

String _$nextUpHash() => r'660bb74cb87c9065fa1556f20ee2840c3eafb3be';

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

String _$nextAlarmHash() => r'8a24c3e1bdc56e9d7cbce33b87dbf8be9a2436fb';
