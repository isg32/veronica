// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(clock)
final clockProvider = ClockProvider._();

final class ClockProvider extends $FunctionalProvider<Clock, Clock, Clock>
    with $Provider<Clock> {
  ClockProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clockProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clockHash();

  @$internal
  @override
  $ProviderElement<Clock> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Clock create(Ref ref) {
    return clock(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Clock value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Clock>(value),
    );
  }
}

String _$clockHash() => r'18e43e031d4e8b35f980f763d2c734f26a4c47a4';

/// The on-device database, opened once for the app's lifetime.

@ProviderFor(database)
final databaseProvider = DatabaseProvider._();

/// The on-device database, opened once for the app's lifetime.

final class DatabaseProvider
    extends
        $FunctionalProvider<
          VeronicaDatabase,
          VeronicaDatabase,
          VeronicaDatabase
        >
    with $Provider<VeronicaDatabase> {
  /// The on-device database, opened once for the app's lifetime.
  DatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'databaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$databaseHash();

  @$internal
  @override
  $ProviderElement<VeronicaDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  VeronicaDatabase create(Ref ref) {
    return database(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VeronicaDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VeronicaDatabase>(value),
    );
  }
}

String _$databaseHash() => r'9071f0816f2eb654bc1323e2ac30305ffb366284';

/// Minutes and installed apps: Android's usage stats on the phone, the
/// sample source in tests and on the desktop.

@ProviderFor(usageSource)
final usageSourceProvider = UsageSourceProvider._();

/// Minutes and installed apps: Android's usage stats on the phone, the
/// sample source in tests and on the desktop.

final class UsageSourceProvider
    extends $FunctionalProvider<UsageSource, UsageSource, UsageSource>
    with $Provider<UsageSource> {
  /// Minutes and installed apps: Android's usage stats on the phone, the
  /// sample source in tests and on the desktop.
  UsageSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'usageSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$usageSourceHash();

  @$internal
  @override
  $ProviderElement<UsageSource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UsageSource create(Ref ref) {
    return usageSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UsageSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UsageSource>(value),
    );
  }
}

String _$usageSourceHash() => r'601cff96e7f648cbe8cbd01be41b27ed96861b58';

@ProviderFor(profileRepository)
final profileRepositoryProvider = ProfileRepositoryProvider._();

final class ProfileRepositoryProvider
    extends
        $FunctionalProvider<
          ProfileRepository,
          ProfileRepository,
          ProfileRepository
        >
    with $Provider<ProfileRepository> {
  ProfileRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileRepositoryHash();

  @$internal
  @override
  $ProviderElement<ProfileRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProfileRepository create(Ref ref) {
    return profileRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProfileRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProfileRepository>(value),
    );
  }
}

String _$profileRepositoryHash() => r'19993b908971567f5e7dc1a7fc48318dbed68fb0';

@ProviderFor(permissionRepository)
final permissionRepositoryProvider = PermissionRepositoryProvider._();

final class PermissionRepositoryProvider
    extends
        $FunctionalProvider<
          PermissionRepository,
          PermissionRepository,
          PermissionRepository
        >
    with $Provider<PermissionRepository> {
  PermissionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'permissionRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$permissionRepositoryHash();

  @$internal
  @override
  $ProviderElement<PermissionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PermissionRepository create(Ref ref) {
    return permissionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PermissionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PermissionRepository>(value),
    );
  }
}

String _$permissionRepositoryHash() =>
    r'128c4c82ea4d62e8dda2c4e8fd289b7034947b2e';

@ProviderFor(usageRepository)
final usageRepositoryProvider = UsageRepositoryProvider._();

final class UsageRepositoryProvider
    extends
        $FunctionalProvider<UsageRepository, UsageRepository, UsageRepository>
    with $Provider<UsageRepository> {
  UsageRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'usageRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$usageRepositoryHash();

  @$internal
  @override
  $ProviderElement<UsageRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UsageRepository create(Ref ref) {
    return usageRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UsageRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UsageRepository>(value),
    );
  }
}

String _$usageRepositoryHash() => r'78fa81ef06a94c12af29253b3a71aa301688beae';

@ProviderFor(taskRepository)
final taskRepositoryProvider = TaskRepositoryProvider._();

final class TaskRepositoryProvider
    extends $FunctionalProvider<TaskRepository, TaskRepository, TaskRepository>
    with $Provider<TaskRepository> {
  TaskRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'taskRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$taskRepositoryHash();

  @$internal
  @override
  $ProviderElement<TaskRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TaskRepository create(Ref ref) {
    return taskRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TaskRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TaskRepository>(value),
    );
  }
}

String _$taskRepositoryHash() => r'bb3daca631869ef2afbb76507819eb0fba32ec49';

@ProviderFor(waterRepository)
final waterRepositoryProvider = WaterRepositoryProvider._();

final class WaterRepositoryProvider
    extends
        $FunctionalProvider<WaterRepository, WaterRepository, WaterRepository>
    with $Provider<WaterRepository> {
  WaterRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'waterRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$waterRepositoryHash();

  @$internal
  @override
  $ProviderElement<WaterRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  WaterRepository create(Ref ref) {
    return waterRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WaterRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WaterRepository>(value),
    );
  }
}

String _$waterRepositoryHash() => r'4d61dec650f47e491e9c818a36f8e14d59572ce0';

@ProviderFor(medicineRepository)
final medicineRepositoryProvider = MedicineRepositoryProvider._();

final class MedicineRepositoryProvider
    extends
        $FunctionalProvider<
          MedicineRepository,
          MedicineRepository,
          MedicineRepository
        >
    with $Provider<MedicineRepository> {
  MedicineRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'medicineRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$medicineRepositoryHash();

  @$internal
  @override
  $ProviderElement<MedicineRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MedicineRepository create(Ref ref) {
    return medicineRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MedicineRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MedicineRepository>(value),
    );
  }
}

String _$medicineRepositoryHash() =>
    r'ac65c09ad100aae9b0522c18d90cd431a9b61eea';

@ProviderFor(modeRepository)
final modeRepositoryProvider = ModeRepositoryProvider._();

final class ModeRepositoryProvider
    extends $FunctionalProvider<ModeRepository, ModeRepository, ModeRepository>
    with $Provider<ModeRepository> {
  ModeRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'modeRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$modeRepositoryHash();

  @$internal
  @override
  $ProviderElement<ModeRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ModeRepository create(Ref ref) {
    return modeRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ModeRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ModeRepository>(value),
    );
  }
}

String _$modeRepositoryHash() => r'032e32fe3910d59122f140dd766d72fcd8047d8f';

/// Importing alarm sounds from files (none in tests).

@ProviderFor(soundPicker)
final soundPickerProvider = SoundPickerProvider._();

/// Importing alarm sounds from files (none in tests).

final class SoundPickerProvider
    extends $FunctionalProvider<SoundPicker, SoundPicker, SoundPicker>
    with $Provider<SoundPicker> {
  /// Importing alarm sounds from files (none in tests).
  SoundPickerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'soundPickerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$soundPickerHash();

  @$internal
  @override
  $ProviderElement<SoundPicker> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SoundPicker create(Ref ref) {
    return soundPicker(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SoundPicker value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SoundPicker>(value),
    );
  }
}

String _$soundPickerHash() => r'1971d4fa228e33663ecf8e7d307e4137b1ddee5a';

/// Sleep estimated from screen-off time (empty in tests).

@ProviderFor(nightSource)
final nightSourceProvider = NightSourceProvider._();

/// Sleep estimated from screen-off time (empty in tests).

final class NightSourceProvider
    extends $FunctionalProvider<NightSource, NightSource, NightSource>
    with $Provider<NightSource> {
  /// Sleep estimated from screen-off time (empty in tests).
  NightSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nightSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nightSourceHash();

  @$internal
  @override
  $ProviderElement<NightSource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  NightSource create(Ref ref) {
    return nightSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NightSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NightSource>(value),
    );
  }
}

String _$nightSourceHash() => r'3c1c79a7e33e9643b164eafeec4ab3805cf564b8';

@ProviderFor(sleepRepository)
final sleepRepositoryProvider = SleepRepositoryProvider._();

final class SleepRepositoryProvider
    extends
        $FunctionalProvider<SleepRepository, SleepRepository, SleepRepository>
    with $Provider<SleepRepository> {
  SleepRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sleepRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sleepRepositoryHash();

  @$internal
  @override
  $ProviderElement<SleepRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SleepRepository create(Ref ref) {
    return sleepRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SleepRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SleepRepository>(value),
    );
  }
}

String _$sleepRepositoryHash() => r'ac448ca89111f389bdedcbd98e01af4f158c4b99';

@ProviderFor(mantraRepository)
final mantraRepositoryProvider = MantraRepositoryProvider._();

final class MantraRepositoryProvider
    extends
        $FunctionalProvider<
          MantraRepository,
          MantraRepository,
          MantraRepository
        >
    with $Provider<MantraRepository> {
  MantraRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mantraRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mantraRepositoryHash();

  @$internal
  @override
  $ProviderElement<MantraRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MantraRepository create(Ref ref) {
    return mantraRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MantraRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MantraRepository>(value),
    );
  }
}

String _$mantraRepositoryHash() => r'2e3a9bd5ad6d1753658291ce4562b5bf8ec76bbd';

/// Whether the offline voice model is on the phone.

@ProviderFor(voiceModelState)
final voiceModelStateProvider = VoiceModelStateProvider._();

/// Whether the offline voice model is on the phone.

final class VoiceModelStateProvider
    extends
        $FunctionalProvider<
          AsyncValue<VoiceModelState>,
          VoiceModelState,
          Stream<VoiceModelState>
        >
    with $FutureModifier<VoiceModelState>, $StreamProvider<VoiceModelState> {
  /// Whether the offline voice model is on the phone.
  VoiceModelStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'voiceModelStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$voiceModelStateHash();

  @$internal
  @override
  $StreamProviderElement<VoiceModelState> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<VoiceModelState> create(Ref ref) {
    return voiceModelState(ref);
  }
}

String _$voiceModelStateHash() => r'296ed3be998557c0f42addbee73873f0ec3bf2d3';

@ProviderFor(settingsRepository)
final settingsRepositoryProvider = SettingsRepositoryProvider._();

final class SettingsRepositoryProvider
    extends
        $FunctionalProvider<
          SettingsRepository,
          SettingsRepository,
          SettingsRepository
        >
    with $Provider<SettingsRepository> {
  SettingsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsRepositoryHash();

  @$internal
  @override
  $ProviderElement<SettingsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SettingsRepository create(Ref ref) {
    return settingsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SettingsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SettingsRepository>(value),
    );
  }
}

String _$settingsRepositoryHash() =>
    r'9ed2213f331faf380b68755b81a8cf97bad1b3f6';

/// "Now", ticking once a second (timers and countdowns).

@ProviderFor(now)
final nowProvider = NowProvider._();

/// "Now", ticking once a second (timers and countdowns).

final class NowProvider
    extends
        $FunctionalProvider<AsyncValue<DateTime>, DateTime, Stream<DateTime>>
    with $FutureModifier<DateTime>, $StreamProvider<DateTime> {
  /// "Now", ticking once a second (timers and countdowns).
  NowProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nowProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nowHash();

  @$internal
  @override
  $StreamProviderElement<DateTime> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<DateTime> create(Ref ref) {
    return now(ref);
  }
}

String _$nowHash() => r'786844dda2e90afa2872f6847f927ba728fcfec9';

@ProviderFor(profile)
final profileProvider = ProfileProvider._();

final class ProfileProvider
    extends $FunctionalProvider<AsyncValue<Profile>, Profile, Stream<Profile>>
    with $FutureModifier<Profile>, $StreamProvider<Profile> {
  ProfileProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileHash();

  @$internal
  @override
  $StreamProviderElement<Profile> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Profile> create(Ref ref) {
    return profile(ref);
  }
}

String _$profileHash() => r'69761e416f1e8bba9b4f440926d5b6deccab77cb';

@ProviderFor(permissions)
final permissionsProvider = PermissionsProvider._();

final class PermissionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<AppPermission, bool>>,
          Map<AppPermission, bool>,
          Stream<Map<AppPermission, bool>>
        >
    with
        $FutureModifier<Map<AppPermission, bool>>,
        $StreamProvider<Map<AppPermission, bool>> {
  PermissionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'permissionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$permissionsHash();

  @$internal
  @override
  $StreamProviderElement<Map<AppPermission, bool>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<Map<AppPermission, bool>> create(Ref ref) {
    return permissions(ref);
  }
}

String _$permissionsHash() => r'5ad2fa451aaccc46b6c74aeac4e2bafc7115bde0';

@ProviderFor(adbStatus)
final adbStatusProvider = AdbStatusProvider._();

final class AdbStatusProvider
    extends
        $FunctionalProvider<AsyncValue<AdbStatus>, AdbStatus, Stream<AdbStatus>>
    with $FutureModifier<AdbStatus>, $StreamProvider<AdbStatus> {
  AdbStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adbStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adbStatusHash();

  @$internal
  @override
  $StreamProviderElement<AdbStatus> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<AdbStatus> create(Ref ref) {
    return adbStatus(ref);
  }
}

String _$adbStatusHash() => r'0251fffbf001213f3de44f95a5bdd4a8df4d5da8';

@ProviderFor(watchedApps)
final watchedAppsProvider = WatchedAppsProvider._();

final class WatchedAppsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<WatchedApp>>,
          List<WatchedApp>,
          Stream<List<WatchedApp>>
        >
    with $FutureModifier<List<WatchedApp>>, $StreamProvider<List<WatchedApp>> {
  WatchedAppsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'watchedAppsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$watchedAppsHash();

  @$internal
  @override
  $StreamProviderElement<List<WatchedApp>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<WatchedApp>> create(Ref ref) {
    return watchedApps(ref);
  }
}

String _$watchedAppsHash() => r'74d864d31637e57da2417977c1aefc3a4fe8b1f9';

@ProviderFor(installedApps)
final installedAppsProvider = InstalledAppsProvider._();

final class InstalledAppsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<InstalledApp>>,
          List<InstalledApp>,
          Stream<List<InstalledApp>>
        >
    with
        $FutureModifier<List<InstalledApp>>,
        $StreamProvider<List<InstalledApp>> {
  InstalledAppsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'installedAppsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$installedAppsHash();

  @$internal
  @override
  $StreamProviderElement<List<InstalledApp>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<InstalledApp>> create(Ref ref) {
    return installedApps(ref);
  }
}

String _$installedAppsHash() => r'8cb4bb2fd15f2af374a0d58a5b41abdac55bae14';

@ProviderFor(weekNudges)
final weekNudgesProvider = WeekNudgesProvider._();

final class WeekNudgesProvider
    extends
        $FunctionalProvider<
          AsyncValue<NudgeStats>,
          NudgeStats,
          Stream<NudgeStats>
        >
    with $FutureModifier<NudgeStats>, $StreamProvider<NudgeStats> {
  WeekNudgesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weekNudgesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weekNudgesHash();

  @$internal
  @override
  $StreamProviderElement<NudgeStats> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<NudgeStats> create(Ref ref) {
    return weekNudges(ref);
  }
}

String _$weekNudgesHash() => r'dfddf7362f620f9150ecfba5c26a5699cfe09d0f';

@ProviderFor(tasks)
final tasksProvider = TasksProvider._();

final class TasksProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Task>>,
          List<Task>,
          Stream<List<Task>>
        >
    with $FutureModifier<List<Task>>, $StreamProvider<List<Task>> {
  TasksProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tasksProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tasksHash();

  @$internal
  @override
  $StreamProviderElement<List<Task>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Task>> create(Ref ref) {
    return tasks(ref);
  }
}

String _$tasksHash() => r'3c3aa0652f5472483100266354826932ace5e082';

@ProviderFor(waterSettings)
final waterSettingsProvider = WaterSettingsProvider._();

final class WaterSettingsProvider
    extends
        $FunctionalProvider<
          AsyncValue<WaterSettings>,
          WaterSettings,
          Stream<WaterSettings>
        >
    with $FutureModifier<WaterSettings>, $StreamProvider<WaterSettings> {
  WaterSettingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'waterSettingsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$waterSettingsHash();

  @$internal
  @override
  $StreamProviderElement<WaterSettings> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<WaterSettings> create(Ref ref) {
    return waterSettings(ref);
  }
}

String _$waterSettingsHash() => r'2399ff3f0ce6fc33e6ef677009e3391f7c07c888';

@ProviderFor(waterToday)
final waterTodayProvider = WaterTodayProvider._();

final class WaterTodayProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<WaterLog>>,
          List<WaterLog>,
          Stream<List<WaterLog>>
        >
    with $FutureModifier<List<WaterLog>>, $StreamProvider<List<WaterLog>> {
  WaterTodayProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'waterTodayProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$waterTodayHash();

  @$internal
  @override
  $StreamProviderElement<List<WaterLog>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<WaterLog>> create(Ref ref) {
    return waterToday(ref);
  }
}

String _$waterTodayHash() => r'c4a350c99a211f76dab90bd34921895bacbec978';

@ProviderFor(waterWeek)
final waterWeekProvider = WaterWeekProvider._();

final class WaterWeekProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<WaterDay>>,
          List<WaterDay>,
          Stream<List<WaterDay>>
        >
    with $FutureModifier<List<WaterDay>>, $StreamProvider<List<WaterDay>> {
  WaterWeekProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'waterWeekProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$waterWeekHash();

  @$internal
  @override
  $StreamProviderElement<List<WaterDay>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<WaterDay>> create(Ref ref) {
    return waterWeek(ref);
  }
}

String _$waterWeekHash() => r'1cbe95f5da63b5b5504d7190d40fca02f493741a';

@ProviderFor(medicineEnabled)
final medicineEnabledProvider = MedicineEnabledProvider._();

final class MedicineEnabledProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, Stream<bool>>
    with $FutureModifier<bool>, $StreamProvider<bool> {
  MedicineEnabledProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'medicineEnabledProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$medicineEnabledHash();

  @$internal
  @override
  $StreamProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<bool> create(Ref ref) {
    return medicineEnabled(ref);
  }
}

String _$medicineEnabledHash() => r'9593744c2a8cbc6907d4fdbdbd7cf9b0fa5c5b20';

@ProviderFor(medicines)
final medicinesProvider = MedicinesProvider._();

final class MedicinesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Medicine>>,
          List<Medicine>,
          Stream<List<Medicine>>
        >
    with $FutureModifier<List<Medicine>>, $StreamProvider<List<Medicine>> {
  MedicinesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'medicinesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$medicinesHash();

  @$internal
  @override
  $StreamProviderElement<List<Medicine>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Medicine>> create(Ref ref) {
    return medicines(ref);
  }
}

String _$medicinesHash() => r'76b456b3990ff49f694857ff69b947e9c5ddd941';

@ProviderFor(doses)
final dosesProvider = DosesProvider._();

final class DosesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<DoseLog>>,
          List<DoseLog>,
          Stream<List<DoseLog>>
        >
    with $FutureModifier<List<DoseLog>>, $StreamProvider<List<DoseLog>> {
  DosesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dosesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dosesHash();

  @$internal
  @override
  $StreamProviderElement<List<DoseLog>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<DoseLog>> create(Ref ref) {
    return doses(ref);
  }
}

String _$dosesHash() => r'f3c91b21c32f112f5a20d25573a72442fe7d1d18';

@ProviderFor(modes)
final modesProvider = ModesProvider._();

final class ModesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Mode>>,
          List<Mode>,
          Stream<List<Mode>>
        >
    with $FutureModifier<List<Mode>>, $StreamProvider<List<Mode>> {
  ModesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'modesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$modesHash();

  @$internal
  @override
  $StreamProviderElement<List<Mode>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Mode>> create(Ref ref) {
    return modes(ref);
  }
}

String _$modesHash() => r'b63f15013d710a21db76b0812de76f3767039611';

@ProviderFor(activeMode)
final activeModeProvider = ActiveModeProvider._();

final class ActiveModeProvider
    extends
        $FunctionalProvider<
          AsyncValue<ActiveMode?>,
          ActiveMode?,
          Stream<ActiveMode?>
        >
    with $FutureModifier<ActiveMode?>, $StreamProvider<ActiveMode?> {
  ActiveModeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeModeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeModeHash();

  @$internal
  @override
  $StreamProviderElement<ActiveMode?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<ActiveMode?> create(Ref ref) {
    return activeMode(ref);
  }
}

String _$activeModeHash() => r'023aa7521f19542dabc34c5888feec67925d9a44';

@ProviderFor(sleepSchedule)
final sleepScheduleProvider = SleepScheduleProvider._();

final class SleepScheduleProvider
    extends
        $FunctionalProvider<
          AsyncValue<SleepSchedule>,
          SleepSchedule,
          Stream<SleepSchedule>
        >
    with $FutureModifier<SleepSchedule>, $StreamProvider<SleepSchedule> {
  SleepScheduleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sleepScheduleProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sleepScheduleHash();

  @$internal
  @override
  $StreamProviderElement<SleepSchedule> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<SleepSchedule> create(Ref ref) {
    return sleepSchedule(ref);
  }
}

String _$sleepScheduleHash() => r'de7507c8c4ccdc0874b1fbac40ec3d5380150d69';

@ProviderFor(alarms)
final alarmsProvider = AlarmsProvider._();

final class AlarmsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Alarm>>,
          List<Alarm>,
          Stream<List<Alarm>>
        >
    with $FutureModifier<List<Alarm>>, $StreamProvider<List<Alarm>> {
  AlarmsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'alarmsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$alarmsHash();

  @$internal
  @override
  $StreamProviderElement<List<Alarm>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Alarm>> create(Ref ref) {
    return alarms(ref);
  }
}

String _$alarmsHash() => r'76bfb20bc6c82b38226c2f0e5740f1b5eb6586e1';

@ProviderFor(nights)
final nightsProvider = NightsProvider._();

final class NightsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<NightLog>>,
          List<NightLog>,
          Stream<List<NightLog>>
        >
    with $FutureModifier<List<NightLog>>, $StreamProvider<List<NightLog>> {
  NightsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nightsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nightsHash();

  @$internal
  @override
  $StreamProviderElement<List<NightLog>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<NightLog>> create(Ref ref) {
    return nights(ref);
  }
}

String _$nightsHash() => r'74a81dcc033a13dd72a07ade89c87cfa3a21220a';

@ProviderFor(sounds)
final soundsProvider = SoundsProvider._();

final class SoundsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AlarmSound>>,
          List<AlarmSound>,
          Stream<List<AlarmSound>>
        >
    with $FutureModifier<List<AlarmSound>>, $StreamProvider<List<AlarmSound>> {
  SoundsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'soundsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$soundsHash();

  @$internal
  @override
  $StreamProviderElement<List<AlarmSound>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<AlarmSound>> create(Ref ref) {
    return sounds(ref);
  }
}

String _$soundsHash() => r'c5d7a861a22ba4dff3fe20cb325f084d721f15e8';

@ProviderFor(mantras)
final mantrasProvider = MantrasProvider._();

final class MantrasProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Mantra>>,
          List<Mantra>,
          Stream<List<Mantra>>
        >
    with $FutureModifier<List<Mantra>>, $StreamProvider<List<Mantra>> {
  MantrasProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mantrasProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mantrasHash();

  @$internal
  @override
  $StreamProviderElement<List<Mantra>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Mantra>> create(Ref ref) {
    return mantras(ref);
  }
}

String _$mantrasHash() => r'786a2b5e6b9a0e0322112ce870bb208da7ae8dd0';

@ProviderFor(mantraSettings)
final mantraSettingsProvider = MantraSettingsProvider._();

final class MantraSettingsProvider
    extends
        $FunctionalProvider<
          AsyncValue<MantraSettings>,
          MantraSettings,
          Stream<MantraSettings>
        >
    with $FutureModifier<MantraSettings>, $StreamProvider<MantraSettings> {
  MantraSettingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mantraSettingsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mantraSettingsHash();

  @$internal
  @override
  $StreamProviderElement<MantraSettings> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<MantraSettings> create(Ref ref) {
    return mantraSettings(ref);
  }
}

String _$mantraSettingsHash() => r'fece3a64e74a2467a0eae2dc6a913ee3160cc7e5';

@ProviderFor(voiceSettings)
final voiceSettingsProvider = VoiceSettingsProvider._();

final class VoiceSettingsProvider
    extends
        $FunctionalProvider<
          AsyncValue<VoiceSettings>,
          VoiceSettings,
          Stream<VoiceSettings>
        >
    with $FutureModifier<VoiceSettings>, $StreamProvider<VoiceSettings> {
  VoiceSettingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'voiceSettingsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$voiceSettingsHash();

  @$internal
  @override
  $StreamProviderElement<VoiceSettings> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<VoiceSettings> create(Ref ref) {
    return voiceSettings(ref);
  }
}

String _$voiceSettingsHash() => r'd659e234f766efffa01daee70129a642635957c0';

@ProviderFor(glyphSettings)
final glyphSettingsProvider = GlyphSettingsProvider._();

final class GlyphSettingsProvider
    extends
        $FunctionalProvider<
          AsyncValue<GlyphSettings>,
          GlyphSettings,
          Stream<GlyphSettings>
        >
    with $FutureModifier<GlyphSettings>, $StreamProvider<GlyphSettings> {
  GlyphSettingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'glyphSettingsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$glyphSettingsHash();

  @$internal
  @override
  $StreamProviderElement<GlyphSettings> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<GlyphSettings> create(Ref ref) {
    return glyphSettings(ref);
  }
}

String _$glyphSettingsHash() => r'c244514d8dcfa2844857d6f009badb1a19c79ba2';
