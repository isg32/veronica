// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminders.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// A snoozed alarm, if any.

@ProviderFor(alarmSnooze)
final alarmSnoozeProvider = AlarmSnoozeProvider._();

/// A snoozed alarm, if any.

final class AlarmSnoozeProvider
    extends
        $FunctionalProvider<
          AsyncValue<({String alarmId, DateTime at})?>,
          ({String alarmId, DateTime at})?,
          Stream<({String alarmId, DateTime at})?>
        >
    with
        $FutureModifier<({String alarmId, DateTime at})?>,
        $StreamProvider<({String alarmId, DateTime at})?> {
  /// A snoozed alarm, if any.
  AlarmSnoozeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'alarmSnoozeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$alarmSnoozeHash();

  @$internal
  @override
  $StreamProviderElement<({String alarmId, DateTime at})?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<({String alarmId, DateTime at})?> create(Ref ref) {
    return alarmSnooze(ref);
  }
}

String _$alarmSnoozeHash() => r'c3a85a94757a2bf7dc01fb3a74450dd2b88262ae';

/// A snoozed medicine dose, if any.

@ProviderFor(medicineSnooze)
final medicineSnoozeProvider = MedicineSnoozeProvider._();

/// A snoozed medicine dose, if any.

final class MedicineSnoozeProvider
    extends
        $FunctionalProvider<
          AsyncValue<({DateTime at, String medicineId})?>,
          ({DateTime at, String medicineId})?,
          Stream<({DateTime at, String medicineId})?>
        >
    with
        $FutureModifier<({DateTime at, String medicineId})?>,
        $StreamProvider<({DateTime at, String medicineId})?> {
  /// A snoozed medicine dose, if any.
  MedicineSnoozeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'medicineSnoozeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$medicineSnoozeHash();

  @$internal
  @override
  $StreamProviderElement<({DateTime at, String medicineId})?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<({DateTime at, String medicineId})?> create(Ref ref) {
    return medicineSnooze(ref);
  }
}

String _$medicineSnoozeHash() => r'bbed6181cb63bb1f3a86082f4bb4dfc65bb32583';

/// Everything Veronica should remind about in the next 48 hours.

@ProviderFor(reminderPlan)
final reminderPlanProvider = ReminderPlanProvider._();

/// Everything Veronica should remind about in the next 48 hours.

final class ReminderPlanProvider
    extends
        $FunctionalProvider<
          List<PlannedReminder>,
          List<PlannedReminder>,
          List<PlannedReminder>
        >
    with $Provider<List<PlannedReminder>> {
  /// Everything Veronica should remind about in the next 48 hours.
  ReminderPlanProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reminderPlanProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reminderPlanHash();

  @$internal
  @override
  $ProviderElement<List<PlannedReminder>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<PlannedReminder> create(Ref ref) {
    return reminderPlan(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<PlannedReminder> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<PlannedReminder>>(value),
    );
  }
}

String _$reminderPlanHash() => r'1f46ed100573b538d8c31cb9bb69917776b6b0f0';

/// Sends the plan to Android whenever it changes, and refreshes the screens
/// when "+1 glass" was logged from a notification.

@ProviderFor(reminderSync)
final reminderSyncProvider = ReminderSyncProvider._();

/// Sends the plan to Android whenever it changes, and refreshes the screens
/// when "+1 glass" was logged from a notification.

final class ReminderSyncProvider extends $FunctionalProvider<void, void, void>
    with $Provider<void> {
  /// Sends the plan to Android whenever it changes, and refreshes the screens
  /// when "+1 glass" was logged from a notification.
  ReminderSyncProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reminderSyncProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reminderSyncHash();

  @$internal
  @override
  $ProviderElement<void> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  void create(Ref ref) {
    return reminderSync(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$reminderSyncHash() => r'03813e5f1122ac3dc2e885a09f0035ae3cc3beb1';
