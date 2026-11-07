// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $WatchedAppsTable extends WatchedApps
    with TableInfo<$WatchedAppsTable, WatchedAppRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WatchedAppsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _packageNameMeta = const VerificationMeta(
    'packageName',
  );
  @override
  late final GeneratedColumn<String> packageName = GeneratedColumn<String>(
    'package_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dailyLimitMinMeta = const VerificationMeta(
    'dailyLimitMin',
  );
  @override
  late final GeneratedColumn<int> dailyLimitMin = GeneratedColumn<int>(
    'daily_limit_min',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nudgeAtPercentMeta = const VerificationMeta(
    'nudgeAtPercent',
  );
  @override
  late final GeneratedColumn<int> nudgeAtPercent = GeneratedColumn<int>(
    'nudge_at_percent',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(80),
  );
  static const VerificationMeta _hardBlockMeta = const VerificationMeta(
    'hardBlock',
  );
  @override
  late final GeneratedColumn<bool> hardBlock = GeneratedColumn<bool>(
    'hard_block',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("hard_block" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _extensionsPerDayMeta = const VerificationMeta(
    'extensionsPerDay',
  );
  @override
  late final GeneratedColumn<int> extensionsPerDay = GeneratedColumn<int>(
    'extensions_per_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(2),
  );
  static const VerificationMeta _addedAtMeta = const VerificationMeta(
    'addedAt',
  );
  @override
  late final GeneratedColumn<int> addedAt = GeneratedColumn<int>(
    'added_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    packageName,
    name,
    dailyLimitMin,
    nudgeAtPercent,
    hardBlock,
    extensionsPerDay,
    addedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'watched_apps';
  @override
  VerificationContext validateIntegrity(
    Insertable<WatchedAppRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('package_name')) {
      context.handle(
        _packageNameMeta,
        packageName.isAcceptableOrUnknown(
          data['package_name']!,
          _packageNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_packageNameMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('daily_limit_min')) {
      context.handle(
        _dailyLimitMinMeta,
        dailyLimitMin.isAcceptableOrUnknown(
          data['daily_limit_min']!,
          _dailyLimitMinMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dailyLimitMinMeta);
    }
    if (data.containsKey('nudge_at_percent')) {
      context.handle(
        _nudgeAtPercentMeta,
        nudgeAtPercent.isAcceptableOrUnknown(
          data['nudge_at_percent']!,
          _nudgeAtPercentMeta,
        ),
      );
    }
    if (data.containsKey('hard_block')) {
      context.handle(
        _hardBlockMeta,
        hardBlock.isAcceptableOrUnknown(data['hard_block']!, _hardBlockMeta),
      );
    }
    if (data.containsKey('extensions_per_day')) {
      context.handle(
        _extensionsPerDayMeta,
        extensionsPerDay.isAcceptableOrUnknown(
          data['extensions_per_day']!,
          _extensionsPerDayMeta,
        ),
      );
    }
    if (data.containsKey('added_at')) {
      context.handle(
        _addedAtMeta,
        addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_addedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {packageName};
  @override
  WatchedAppRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WatchedAppRow(
      packageName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}package_name'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      dailyLimitMin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}daily_limit_min'],
      )!,
      nudgeAtPercent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}nudge_at_percent'],
      )!,
      hardBlock: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}hard_block'],
      )!,
      extensionsPerDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}extensions_per_day'],
      )!,
      addedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}added_at'],
      )!,
    );
  }

  @override
  $WatchedAppsTable createAlias(String alias) {
    return $WatchedAppsTable(attachedDatabase, alias);
  }
}

class WatchedAppRow extends DataClass implements Insertable<WatchedAppRow> {
  final String packageName;
  final String name;
  final int dailyLimitMin;
  final int nudgeAtPercent;
  final bool hardBlock;

  /// "5 more minutes" allowed per day (0–2).
  final int extensionsPerDay;

  /// Epoch milliseconds.
  final int addedAt;
  const WatchedAppRow({
    required this.packageName,
    required this.name,
    required this.dailyLimitMin,
    required this.nudgeAtPercent,
    required this.hardBlock,
    required this.extensionsPerDay,
    required this.addedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['package_name'] = Variable<String>(packageName);
    map['name'] = Variable<String>(name);
    map['daily_limit_min'] = Variable<int>(dailyLimitMin);
    map['nudge_at_percent'] = Variable<int>(nudgeAtPercent);
    map['hard_block'] = Variable<bool>(hardBlock);
    map['extensions_per_day'] = Variable<int>(extensionsPerDay);
    map['added_at'] = Variable<int>(addedAt);
    return map;
  }

  WatchedAppsCompanion toCompanion(bool nullToAbsent) {
    return WatchedAppsCompanion(
      packageName: Value(packageName),
      name: Value(name),
      dailyLimitMin: Value(dailyLimitMin),
      nudgeAtPercent: Value(nudgeAtPercent),
      hardBlock: Value(hardBlock),
      extensionsPerDay: Value(extensionsPerDay),
      addedAt: Value(addedAt),
    );
  }

  factory WatchedAppRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WatchedAppRow(
      packageName: serializer.fromJson<String>(json['packageName']),
      name: serializer.fromJson<String>(json['name']),
      dailyLimitMin: serializer.fromJson<int>(json['dailyLimitMin']),
      nudgeAtPercent: serializer.fromJson<int>(json['nudgeAtPercent']),
      hardBlock: serializer.fromJson<bool>(json['hardBlock']),
      extensionsPerDay: serializer.fromJson<int>(json['extensionsPerDay']),
      addedAt: serializer.fromJson<int>(json['addedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'packageName': serializer.toJson<String>(packageName),
      'name': serializer.toJson<String>(name),
      'dailyLimitMin': serializer.toJson<int>(dailyLimitMin),
      'nudgeAtPercent': serializer.toJson<int>(nudgeAtPercent),
      'hardBlock': serializer.toJson<bool>(hardBlock),
      'extensionsPerDay': serializer.toJson<int>(extensionsPerDay),
      'addedAt': serializer.toJson<int>(addedAt),
    };
  }

  WatchedAppRow copyWith({
    String? packageName,
    String? name,
    int? dailyLimitMin,
    int? nudgeAtPercent,
    bool? hardBlock,
    int? extensionsPerDay,
    int? addedAt,
  }) => WatchedAppRow(
    packageName: packageName ?? this.packageName,
    name: name ?? this.name,
    dailyLimitMin: dailyLimitMin ?? this.dailyLimitMin,
    nudgeAtPercent: nudgeAtPercent ?? this.nudgeAtPercent,
    hardBlock: hardBlock ?? this.hardBlock,
    extensionsPerDay: extensionsPerDay ?? this.extensionsPerDay,
    addedAt: addedAt ?? this.addedAt,
  );
  WatchedAppRow copyWithCompanion(WatchedAppsCompanion data) {
    return WatchedAppRow(
      packageName: data.packageName.present
          ? data.packageName.value
          : this.packageName,
      name: data.name.present ? data.name.value : this.name,
      dailyLimitMin: data.dailyLimitMin.present
          ? data.dailyLimitMin.value
          : this.dailyLimitMin,
      nudgeAtPercent: data.nudgeAtPercent.present
          ? data.nudgeAtPercent.value
          : this.nudgeAtPercent,
      hardBlock: data.hardBlock.present ? data.hardBlock.value : this.hardBlock,
      extensionsPerDay: data.extensionsPerDay.present
          ? data.extensionsPerDay.value
          : this.extensionsPerDay,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WatchedAppRow(')
          ..write('packageName: $packageName, ')
          ..write('name: $name, ')
          ..write('dailyLimitMin: $dailyLimitMin, ')
          ..write('nudgeAtPercent: $nudgeAtPercent, ')
          ..write('hardBlock: $hardBlock, ')
          ..write('extensionsPerDay: $extensionsPerDay, ')
          ..write('addedAt: $addedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    packageName,
    name,
    dailyLimitMin,
    nudgeAtPercent,
    hardBlock,
    extensionsPerDay,
    addedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WatchedAppRow &&
          other.packageName == this.packageName &&
          other.name == this.name &&
          other.dailyLimitMin == this.dailyLimitMin &&
          other.nudgeAtPercent == this.nudgeAtPercent &&
          other.hardBlock == this.hardBlock &&
          other.extensionsPerDay == this.extensionsPerDay &&
          other.addedAt == this.addedAt);
}

class WatchedAppsCompanion extends UpdateCompanion<WatchedAppRow> {
  final Value<String> packageName;
  final Value<String> name;
  final Value<int> dailyLimitMin;
  final Value<int> nudgeAtPercent;
  final Value<bool> hardBlock;
  final Value<int> extensionsPerDay;
  final Value<int> addedAt;
  final Value<int> rowid;
  const WatchedAppsCompanion({
    this.packageName = const Value.absent(),
    this.name = const Value.absent(),
    this.dailyLimitMin = const Value.absent(),
    this.nudgeAtPercent = const Value.absent(),
    this.hardBlock = const Value.absent(),
    this.extensionsPerDay = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WatchedAppsCompanion.insert({
    required String packageName,
    required String name,
    required int dailyLimitMin,
    this.nudgeAtPercent = const Value.absent(),
    this.hardBlock = const Value.absent(),
    this.extensionsPerDay = const Value.absent(),
    required int addedAt,
    this.rowid = const Value.absent(),
  }) : packageName = Value(packageName),
       name = Value(name),
       dailyLimitMin = Value(dailyLimitMin),
       addedAt = Value(addedAt);
  static Insertable<WatchedAppRow> custom({
    Expression<String>? packageName,
    Expression<String>? name,
    Expression<int>? dailyLimitMin,
    Expression<int>? nudgeAtPercent,
    Expression<bool>? hardBlock,
    Expression<int>? extensionsPerDay,
    Expression<int>? addedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (packageName != null) 'package_name': packageName,
      if (name != null) 'name': name,
      if (dailyLimitMin != null) 'daily_limit_min': dailyLimitMin,
      if (nudgeAtPercent != null) 'nudge_at_percent': nudgeAtPercent,
      if (hardBlock != null) 'hard_block': hardBlock,
      if (extensionsPerDay != null) 'extensions_per_day': extensionsPerDay,
      if (addedAt != null) 'added_at': addedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WatchedAppsCompanion copyWith({
    Value<String>? packageName,
    Value<String>? name,
    Value<int>? dailyLimitMin,
    Value<int>? nudgeAtPercent,
    Value<bool>? hardBlock,
    Value<int>? extensionsPerDay,
    Value<int>? addedAt,
    Value<int>? rowid,
  }) {
    return WatchedAppsCompanion(
      packageName: packageName ?? this.packageName,
      name: name ?? this.name,
      dailyLimitMin: dailyLimitMin ?? this.dailyLimitMin,
      nudgeAtPercent: nudgeAtPercent ?? this.nudgeAtPercent,
      hardBlock: hardBlock ?? this.hardBlock,
      extensionsPerDay: extensionsPerDay ?? this.extensionsPerDay,
      addedAt: addedAt ?? this.addedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (packageName.present) {
      map['package_name'] = Variable<String>(packageName.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (dailyLimitMin.present) {
      map['daily_limit_min'] = Variable<int>(dailyLimitMin.value);
    }
    if (nudgeAtPercent.present) {
      map['nudge_at_percent'] = Variable<int>(nudgeAtPercent.value);
    }
    if (hardBlock.present) {
      map['hard_block'] = Variable<bool>(hardBlock.value);
    }
    if (extensionsPerDay.present) {
      map['extensions_per_day'] = Variable<int>(extensionsPerDay.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<int>(addedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WatchedAppsCompanion(')
          ..write('packageName: $packageName, ')
          ..write('name: $name, ')
          ..write('dailyLimitMin: $dailyLimitMin, ')
          ..write('nudgeAtPercent: $nudgeAtPercent, ')
          ..write('hardBlock: $hardBlock, ')
          ..write('extensionsPerDay: $extensionsPerDay, ')
          ..write('addedAt: $addedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UsageDaysTable extends UsageDays
    with TableInfo<$UsageDaysTable, UsageDayRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsageDaysTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _packageNameMeta = const VerificationMeta(
    'packageName',
  );
  @override
  late final GeneratedColumn<String> packageName = GeneratedColumn<String>(
    'package_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumn<String> day = GeneratedColumn<String>(
    'day',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nudgesShownMeta = const VerificationMeta(
    'nudgesShown',
  );
  @override
  late final GeneratedColumn<int> nudgesShown = GeneratedColumn<int>(
    'nudges_shown',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _putDownAcceptedMeta = const VerificationMeta(
    'putDownAccepted',
  );
  @override
  late final GeneratedColumn<int> putDownAccepted = GeneratedColumn<int>(
    'put_down_accepted',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _extensionsUsedMeta = const VerificationMeta(
    'extensionsUsed',
  );
  @override
  late final GeneratedColumn<int> extensionsUsed = GeneratedColumn<int>(
    'extensions_used',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    packageName,
    day,
    nudgesShown,
    putDownAccepted,
    extensionsUsed,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'usage_days';
  @override
  VerificationContext validateIntegrity(
    Insertable<UsageDayRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('package_name')) {
      context.handle(
        _packageNameMeta,
        packageName.isAcceptableOrUnknown(
          data['package_name']!,
          _packageNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_packageNameMeta);
    }
    if (data.containsKey('day')) {
      context.handle(
        _dayMeta,
        day.isAcceptableOrUnknown(data['day']!, _dayMeta),
      );
    } else if (isInserting) {
      context.missing(_dayMeta);
    }
    if (data.containsKey('nudges_shown')) {
      context.handle(
        _nudgesShownMeta,
        nudgesShown.isAcceptableOrUnknown(
          data['nudges_shown']!,
          _nudgesShownMeta,
        ),
      );
    }
    if (data.containsKey('put_down_accepted')) {
      context.handle(
        _putDownAcceptedMeta,
        putDownAccepted.isAcceptableOrUnknown(
          data['put_down_accepted']!,
          _putDownAcceptedMeta,
        ),
      );
    }
    if (data.containsKey('extensions_used')) {
      context.handle(
        _extensionsUsedMeta,
        extensionsUsed.isAcceptableOrUnknown(
          data['extensions_used']!,
          _extensionsUsedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {packageName, day};
  @override
  UsageDayRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UsageDayRow(
      packageName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}package_name'],
      )!,
      day: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day'],
      )!,
      nudgesShown: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}nudges_shown'],
      )!,
      putDownAccepted: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}put_down_accepted'],
      )!,
      extensionsUsed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}extensions_used'],
      )!,
    );
  }

  @override
  $UsageDaysTable createAlias(String alias) {
    return $UsageDaysTable(attachedDatabase, alias);
  }
}

class UsageDayRow extends DataClass implements Insertable<UsageDayRow> {
  final String packageName;

  /// Local calendar day, `yyyy-mm-dd`.
  final String day;
  final int nudgesShown;

  /// Times the phone was put down when asked.
  final int putDownAccepted;
  final int extensionsUsed;
  const UsageDayRow({
    required this.packageName,
    required this.day,
    required this.nudgesShown,
    required this.putDownAccepted,
    required this.extensionsUsed,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['package_name'] = Variable<String>(packageName);
    map['day'] = Variable<String>(day);
    map['nudges_shown'] = Variable<int>(nudgesShown);
    map['put_down_accepted'] = Variable<int>(putDownAccepted);
    map['extensions_used'] = Variable<int>(extensionsUsed);
    return map;
  }

  UsageDaysCompanion toCompanion(bool nullToAbsent) {
    return UsageDaysCompanion(
      packageName: Value(packageName),
      day: Value(day),
      nudgesShown: Value(nudgesShown),
      putDownAccepted: Value(putDownAccepted),
      extensionsUsed: Value(extensionsUsed),
    );
  }

  factory UsageDayRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UsageDayRow(
      packageName: serializer.fromJson<String>(json['packageName']),
      day: serializer.fromJson<String>(json['day']),
      nudgesShown: serializer.fromJson<int>(json['nudgesShown']),
      putDownAccepted: serializer.fromJson<int>(json['putDownAccepted']),
      extensionsUsed: serializer.fromJson<int>(json['extensionsUsed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'packageName': serializer.toJson<String>(packageName),
      'day': serializer.toJson<String>(day),
      'nudgesShown': serializer.toJson<int>(nudgesShown),
      'putDownAccepted': serializer.toJson<int>(putDownAccepted),
      'extensionsUsed': serializer.toJson<int>(extensionsUsed),
    };
  }

  UsageDayRow copyWith({
    String? packageName,
    String? day,
    int? nudgesShown,
    int? putDownAccepted,
    int? extensionsUsed,
  }) => UsageDayRow(
    packageName: packageName ?? this.packageName,
    day: day ?? this.day,
    nudgesShown: nudgesShown ?? this.nudgesShown,
    putDownAccepted: putDownAccepted ?? this.putDownAccepted,
    extensionsUsed: extensionsUsed ?? this.extensionsUsed,
  );
  UsageDayRow copyWithCompanion(UsageDaysCompanion data) {
    return UsageDayRow(
      packageName: data.packageName.present
          ? data.packageName.value
          : this.packageName,
      day: data.day.present ? data.day.value : this.day,
      nudgesShown: data.nudgesShown.present
          ? data.nudgesShown.value
          : this.nudgesShown,
      putDownAccepted: data.putDownAccepted.present
          ? data.putDownAccepted.value
          : this.putDownAccepted,
      extensionsUsed: data.extensionsUsed.present
          ? data.extensionsUsed.value
          : this.extensionsUsed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UsageDayRow(')
          ..write('packageName: $packageName, ')
          ..write('day: $day, ')
          ..write('nudgesShown: $nudgesShown, ')
          ..write('putDownAccepted: $putDownAccepted, ')
          ..write('extensionsUsed: $extensionsUsed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    packageName,
    day,
    nudgesShown,
    putDownAccepted,
    extensionsUsed,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UsageDayRow &&
          other.packageName == this.packageName &&
          other.day == this.day &&
          other.nudgesShown == this.nudgesShown &&
          other.putDownAccepted == this.putDownAccepted &&
          other.extensionsUsed == this.extensionsUsed);
}

class UsageDaysCompanion extends UpdateCompanion<UsageDayRow> {
  final Value<String> packageName;
  final Value<String> day;
  final Value<int> nudgesShown;
  final Value<int> putDownAccepted;
  final Value<int> extensionsUsed;
  final Value<int> rowid;
  const UsageDaysCompanion({
    this.packageName = const Value.absent(),
    this.day = const Value.absent(),
    this.nudgesShown = const Value.absent(),
    this.putDownAccepted = const Value.absent(),
    this.extensionsUsed = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsageDaysCompanion.insert({
    required String packageName,
    required String day,
    this.nudgesShown = const Value.absent(),
    this.putDownAccepted = const Value.absent(),
    this.extensionsUsed = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : packageName = Value(packageName),
       day = Value(day);
  static Insertable<UsageDayRow> custom({
    Expression<String>? packageName,
    Expression<String>? day,
    Expression<int>? nudgesShown,
    Expression<int>? putDownAccepted,
    Expression<int>? extensionsUsed,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (packageName != null) 'package_name': packageName,
      if (day != null) 'day': day,
      if (nudgesShown != null) 'nudges_shown': nudgesShown,
      if (putDownAccepted != null) 'put_down_accepted': putDownAccepted,
      if (extensionsUsed != null) 'extensions_used': extensionsUsed,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsageDaysCompanion copyWith({
    Value<String>? packageName,
    Value<String>? day,
    Value<int>? nudgesShown,
    Value<int>? putDownAccepted,
    Value<int>? extensionsUsed,
    Value<int>? rowid,
  }) {
    return UsageDaysCompanion(
      packageName: packageName ?? this.packageName,
      day: day ?? this.day,
      nudgesShown: nudgesShown ?? this.nudgesShown,
      putDownAccepted: putDownAccepted ?? this.putDownAccepted,
      extensionsUsed: extensionsUsed ?? this.extensionsUsed,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (packageName.present) {
      map['package_name'] = Variable<String>(packageName.value);
    }
    if (day.present) {
      map['day'] = Variable<String>(day.value);
    }
    if (nudgesShown.present) {
      map['nudges_shown'] = Variable<int>(nudgesShown.value);
    }
    if (putDownAccepted.present) {
      map['put_down_accepted'] = Variable<int>(putDownAccepted.value);
    }
    if (extensionsUsed.present) {
      map['extensions_used'] = Variable<int>(extensionsUsed.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsageDaysCompanion(')
          ..write('packageName: $packageName, ')
          ..write('day: $day, ')
          ..write('nudgesShown: $nudgesShown, ')
          ..write('putDownAccepted: $putDownAccepted, ')
          ..write('extensionsUsed: $extensionsUsed, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OverrideLogsTable extends OverrideLogs
    with TableInfo<$OverrideLogsTable, OverrideRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OverrideLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _packageNameMeta = const VerificationMeta(
    'packageName',
  );
  @override
  late final GeneratedColumn<String> packageName = GeneratedColumn<String>(
    'package_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _atMeta = const VerificationMeta('at');
  @override
  late final GeneratedColumn<int> at = GeneratedColumn<int>(
    'at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, packageName, at];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'override_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<OverrideRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('package_name')) {
      context.handle(
        _packageNameMeta,
        packageName.isAcceptableOrUnknown(
          data['package_name']!,
          _packageNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_packageNameMeta);
    }
    if (data.containsKey('at')) {
      context.handle(_atMeta, at.isAcceptableOrUnknown(data['at']!, _atMeta));
    } else if (isInserting) {
      context.missing(_atMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OverrideRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OverrideRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      packageName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}package_name'],
      )!,
      at: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}at'],
      )!,
    );
  }

  @override
  $OverrideLogsTable createAlias(String alias) {
    return $OverrideLogsTable(attachedDatabase, alias);
  }
}

class OverrideRow extends DataClass implements Insertable<OverrideRow> {
  final int id;
  final String packageName;

  /// Epoch milliseconds.
  final int at;
  const OverrideRow({
    required this.id,
    required this.packageName,
    required this.at,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['package_name'] = Variable<String>(packageName);
    map['at'] = Variable<int>(at);
    return map;
  }

  OverrideLogsCompanion toCompanion(bool nullToAbsent) {
    return OverrideLogsCompanion(
      id: Value(id),
      packageName: Value(packageName),
      at: Value(at),
    );
  }

  factory OverrideRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OverrideRow(
      id: serializer.fromJson<int>(json['id']),
      packageName: serializer.fromJson<String>(json['packageName']),
      at: serializer.fromJson<int>(json['at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'packageName': serializer.toJson<String>(packageName),
      'at': serializer.toJson<int>(at),
    };
  }

  OverrideRow copyWith({int? id, String? packageName, int? at}) => OverrideRow(
    id: id ?? this.id,
    packageName: packageName ?? this.packageName,
    at: at ?? this.at,
  );
  OverrideRow copyWithCompanion(OverrideLogsCompanion data) {
    return OverrideRow(
      id: data.id.present ? data.id.value : this.id,
      packageName: data.packageName.present
          ? data.packageName.value
          : this.packageName,
      at: data.at.present ? data.at.value : this.at,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OverrideRow(')
          ..write('id: $id, ')
          ..write('packageName: $packageName, ')
          ..write('at: $at')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, packageName, at);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OverrideRow &&
          other.id == this.id &&
          other.packageName == this.packageName &&
          other.at == this.at);
}

class OverrideLogsCompanion extends UpdateCompanion<OverrideRow> {
  final Value<int> id;
  final Value<String> packageName;
  final Value<int> at;
  const OverrideLogsCompanion({
    this.id = const Value.absent(),
    this.packageName = const Value.absent(),
    this.at = const Value.absent(),
  });
  OverrideLogsCompanion.insert({
    this.id = const Value.absent(),
    required String packageName,
    required int at,
  }) : packageName = Value(packageName),
       at = Value(at);
  static Insertable<OverrideRow> custom({
    Expression<int>? id,
    Expression<String>? packageName,
    Expression<int>? at,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (packageName != null) 'package_name': packageName,
      if (at != null) 'at': at,
    });
  }

  OverrideLogsCompanion copyWith({
    Value<int>? id,
    Value<String>? packageName,
    Value<int>? at,
  }) {
    return OverrideLogsCompanion(
      id: id ?? this.id,
      packageName: packageName ?? this.packageName,
      at: at ?? this.at,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (packageName.present) {
      map['package_name'] = Variable<String>(packageName.value);
    }
    if (at.present) {
      map['at'] = Variable<int>(at.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OverrideLogsCompanion(')
          ..write('id: $id, ')
          ..write('packageName: $packageName, ')
          ..write('at: $at')
          ..write(')'))
        .toString();
  }
}

class $PrefsTable extends Prefs with TableInfo<$PrefsTable, PrefRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PrefsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'prefs';
  @override
  VerificationContext validateIntegrity(
    Insertable<PrefRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  PrefRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PrefRow(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $PrefsTable createAlias(String alias) {
    return $PrefsTable(attachedDatabase, alias);
  }
}

class PrefRow extends DataClass implements Insertable<PrefRow> {
  final String key;
  final String value;
  const PrefRow({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  PrefsCompanion toCompanion(bool nullToAbsent) {
    return PrefsCompanion(key: Value(key), value: Value(value));
  }

  factory PrefRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PrefRow(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  PrefRow copyWith({String? key, String? value}) =>
      PrefRow(key: key ?? this.key, value: value ?? this.value);
  PrefRow copyWithCompanion(PrefsCompanion data) {
    return PrefRow(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PrefRow(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PrefRow && other.key == this.key && other.value == this.value);
}

class PrefsCompanion extends UpdateCompanion<PrefRow> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const PrefsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PrefsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<PrefRow> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PrefsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return PrefsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PrefsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TasksTable extends Tasks with TableInfo<$TasksTable, TaskRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueAtMeta = const VerificationMeta('dueAt');
  @override
  late final GeneratedColumn<int> dueAt = GeneratedColumn<int>(
    'due_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<int> completedAt = GeneratedColumn<int>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    notes,
    createdAt,
    dueAt,
    completedAt,
    priority,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('due_at')) {
      context.handle(
        _dueAtMeta,
        dueAt.isAcceptableOrUnknown(data['due_at']!, _dueAtMeta),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      dueAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}due_at'],
      ),
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}completed_at'],
      ),
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}priority'],
      )!,
    );
  }

  @override
  $TasksTable createAlias(String alias) {
    return $TasksTable(attachedDatabase, alias);
  }
}

class TaskRow extends DataClass implements Insertable<TaskRow> {
  final String id;
  final String title;
  final String notes;
  final int createdAt;
  final int? dueAt;
  final int? completedAt;

  /// TaskPriority index.
  final int priority;
  const TaskRow({
    required this.id,
    required this.title,
    required this.notes,
    required this.createdAt,
    this.dueAt,
    this.completedAt,
    required this.priority,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['notes'] = Variable<String>(notes);
    map['created_at'] = Variable<int>(createdAt);
    if (!nullToAbsent || dueAt != null) {
      map['due_at'] = Variable<int>(dueAt);
    }
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<int>(completedAt);
    }
    map['priority'] = Variable<int>(priority);
    return map;
  }

  TasksCompanion toCompanion(bool nullToAbsent) {
    return TasksCompanion(
      id: Value(id),
      title: Value(title),
      notes: Value(notes),
      createdAt: Value(createdAt),
      dueAt: dueAt == null && nullToAbsent
          ? const Value.absent()
          : Value(dueAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      priority: Value(priority),
    );
  }

  factory TaskRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskRow(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      notes: serializer.fromJson<String>(json['notes']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      dueAt: serializer.fromJson<int?>(json['dueAt']),
      completedAt: serializer.fromJson<int?>(json['completedAt']),
      priority: serializer.fromJson<int>(json['priority']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'notes': serializer.toJson<String>(notes),
      'createdAt': serializer.toJson<int>(createdAt),
      'dueAt': serializer.toJson<int?>(dueAt),
      'completedAt': serializer.toJson<int?>(completedAt),
      'priority': serializer.toJson<int>(priority),
    };
  }

  TaskRow copyWith({
    String? id,
    String? title,
    String? notes,
    int? createdAt,
    Value<int?> dueAt = const Value.absent(),
    Value<int?> completedAt = const Value.absent(),
    int? priority,
  }) => TaskRow(
    id: id ?? this.id,
    title: title ?? this.title,
    notes: notes ?? this.notes,
    createdAt: createdAt ?? this.createdAt,
    dueAt: dueAt.present ? dueAt.value : this.dueAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    priority: priority ?? this.priority,
  );
  TaskRow copyWithCompanion(TasksCompanion data) {
    return TaskRow(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      dueAt: data.dueAt.present ? data.dueAt.value : this.dueAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      priority: data.priority.present ? data.priority.value : this.priority,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskRow(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('dueAt: $dueAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('priority: $priority')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, notes, createdAt, dueAt, completedAt, priority);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskRow &&
          other.id == this.id &&
          other.title == this.title &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.dueAt == this.dueAt &&
          other.completedAt == this.completedAt &&
          other.priority == this.priority);
}

class TasksCompanion extends UpdateCompanion<TaskRow> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> notes;
  final Value<int> createdAt;
  final Value<int?> dueAt;
  final Value<int?> completedAt;
  final Value<int> priority;
  final Value<int> rowid;
  const TasksCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.dueAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.priority = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TasksCompanion.insert({
    required String id,
    required String title,
    this.notes = const Value.absent(),
    required int createdAt,
    this.dueAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.priority = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       createdAt = Value(createdAt);
  static Insertable<TaskRow> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? notes,
    Expression<int>? createdAt,
    Expression<int>? dueAt,
    Expression<int>? completedAt,
    Expression<int>? priority,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (dueAt != null) 'due_at': dueAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (priority != null) 'priority': priority,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TasksCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? notes,
    Value<int>? createdAt,
    Value<int?>? dueAt,
    Value<int?>? completedAt,
    Value<int>? priority,
    Value<int>? rowid,
  }) {
    return TasksCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      dueAt: dueAt ?? this.dueAt,
      completedAt: completedAt ?? this.completedAt,
      priority: priority ?? this.priority,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (dueAt.present) {
      map['due_at'] = Variable<int>(dueAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<int>(completedAt.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('dueAt: $dueAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('priority: $priority, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WaterLogsTable extends WaterLogs
    with TableInfo<$WaterLogsTable, WaterLogRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WaterLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _atMeta = const VerificationMeta('at');
  @override
  late final GeneratedColumn<int> at = GeneratedColumn<int>(
    'at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mlMeta = const VerificationMeta('ml');
  @override
  late final GeneratedColumn<int> ml = GeneratedColumn<int>(
    'ml',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, at, ml];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'water_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<WaterLogRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('at')) {
      context.handle(_atMeta, at.isAcceptableOrUnknown(data['at']!, _atMeta));
    } else if (isInserting) {
      context.missing(_atMeta);
    }
    if (data.containsKey('ml')) {
      context.handle(_mlMeta, ml.isAcceptableOrUnknown(data['ml']!, _mlMeta));
    } else if (isInserting) {
      context.missing(_mlMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WaterLogRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WaterLogRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      at: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}at'],
      )!,
      ml: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ml'],
      )!,
    );
  }

  @override
  $WaterLogsTable createAlias(String alias) {
    return $WaterLogsTable(attachedDatabase, alias);
  }
}

class WaterLogRow extends DataClass implements Insertable<WaterLogRow> {
  final String id;
  final int at;
  final int ml;
  const WaterLogRow({required this.id, required this.at, required this.ml});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['at'] = Variable<int>(at);
    map['ml'] = Variable<int>(ml);
    return map;
  }

  WaterLogsCompanion toCompanion(bool nullToAbsent) {
    return WaterLogsCompanion(id: Value(id), at: Value(at), ml: Value(ml));
  }

  factory WaterLogRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WaterLogRow(
      id: serializer.fromJson<String>(json['id']),
      at: serializer.fromJson<int>(json['at']),
      ml: serializer.fromJson<int>(json['ml']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'at': serializer.toJson<int>(at),
      'ml': serializer.toJson<int>(ml),
    };
  }

  WaterLogRow copyWith({String? id, int? at, int? ml}) =>
      WaterLogRow(id: id ?? this.id, at: at ?? this.at, ml: ml ?? this.ml);
  WaterLogRow copyWithCompanion(WaterLogsCompanion data) {
    return WaterLogRow(
      id: data.id.present ? data.id.value : this.id,
      at: data.at.present ? data.at.value : this.at,
      ml: data.ml.present ? data.ml.value : this.ml,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WaterLogRow(')
          ..write('id: $id, ')
          ..write('at: $at, ')
          ..write('ml: $ml')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, at, ml);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WaterLogRow &&
          other.id == this.id &&
          other.at == this.at &&
          other.ml == this.ml);
}

class WaterLogsCompanion extends UpdateCompanion<WaterLogRow> {
  final Value<String> id;
  final Value<int> at;
  final Value<int> ml;
  final Value<int> rowid;
  const WaterLogsCompanion({
    this.id = const Value.absent(),
    this.at = const Value.absent(),
    this.ml = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WaterLogsCompanion.insert({
    required String id,
    required int at,
    required int ml,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       at = Value(at),
       ml = Value(ml);
  static Insertable<WaterLogRow> custom({
    Expression<String>? id,
    Expression<int>? at,
    Expression<int>? ml,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (at != null) 'at': at,
      if (ml != null) 'ml': ml,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WaterLogsCompanion copyWith({
    Value<String>? id,
    Value<int>? at,
    Value<int>? ml,
    Value<int>? rowid,
  }) {
    return WaterLogsCompanion(
      id: id ?? this.id,
      at: at ?? this.at,
      ml: ml ?? this.ml,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (at.present) {
      map['at'] = Variable<int>(at.value);
    }
    if (ml.present) {
      map['ml'] = Variable<int>(ml.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WaterLogsCompanion(')
          ..write('id: $id, ')
          ..write('at: $at, ')
          ..write('ml: $ml, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MedicinesTable extends Medicines
    with TableInfo<$MedicinesTable, MedicineRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _doseMeta = const VerificationMeta('dose');
  @override
  late final GeneratedColumn<String> dose = GeneratedColumn<String>(
    'dose',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timesMeta = const VerificationMeta('times');
  @override
  late final GeneratedColumn<String> times = GeneratedColumn<String>(
    'times',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _daysMeta = const VerificationMeta('days');
  @override
  late final GeneratedColumn<String> days = GeneratedColumn<String>(
    'days',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _refillCountMeta = const VerificationMeta(
    'refillCount',
  );
  @override
  late final GeneratedColumn<int> refillCount = GeneratedColumn<int>(
    'refill_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _remindRefillMeta = const VerificationMeta(
    'remindRefill',
  );
  @override
  late final GeneratedColumn<bool> remindRefill = GeneratedColumn<bool>(
    'remind_refill',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("remind_refill" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _refillRemindAtMeta = const VerificationMeta(
    'refillRemindAt',
  );
  @override
  late final GeneratedColumn<int> refillRemindAt = GeneratedColumn<int>(
    'refill_remind_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(5),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    dose,
    times,
    days,
    refillCount,
    remindRefill,
    refillRemindAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medicines';
  @override
  VerificationContext validateIntegrity(
    Insertable<MedicineRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('dose')) {
      context.handle(
        _doseMeta,
        dose.isAcceptableOrUnknown(data['dose']!, _doseMeta),
      );
    } else if (isInserting) {
      context.missing(_doseMeta);
    }
    if (data.containsKey('times')) {
      context.handle(
        _timesMeta,
        times.isAcceptableOrUnknown(data['times']!, _timesMeta),
      );
    } else if (isInserting) {
      context.missing(_timesMeta);
    }
    if (data.containsKey('days')) {
      context.handle(
        _daysMeta,
        days.isAcceptableOrUnknown(data['days']!, _daysMeta),
      );
    } else if (isInserting) {
      context.missing(_daysMeta);
    }
    if (data.containsKey('refill_count')) {
      context.handle(
        _refillCountMeta,
        refillCount.isAcceptableOrUnknown(
          data['refill_count']!,
          _refillCountMeta,
        ),
      );
    }
    if (data.containsKey('remind_refill')) {
      context.handle(
        _remindRefillMeta,
        remindRefill.isAcceptableOrUnknown(
          data['remind_refill']!,
          _remindRefillMeta,
        ),
      );
    }
    if (data.containsKey('refill_remind_at')) {
      context.handle(
        _refillRemindAtMeta,
        refillRemindAt.isAcceptableOrUnknown(
          data['refill_remind_at']!,
          _refillRemindAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MedicineRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MedicineRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      dose: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dose'],
      )!,
      times: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}times'],
      )!,
      days: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}days'],
      )!,
      refillCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}refill_count'],
      )!,
      remindRefill: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}remind_refill'],
      )!,
      refillRemindAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}refill_remind_at'],
      )!,
    );
  }

  @override
  $MedicinesTable createAlias(String alias) {
    return $MedicinesTable(attachedDatabase, alias);
  }
}

class MedicineRow extends DataClass implements Insertable<MedicineRow> {
  final String id;
  final String name;
  final String dose;

  /// `HH:MM,HH:MM`.
  final String times;

  /// `1,2,3` (Monday = 1).
  final String days;
  final int refillCount;
  final bool remindRefill;
  final int refillRemindAt;
  const MedicineRow({
    required this.id,
    required this.name,
    required this.dose,
    required this.times,
    required this.days,
    required this.refillCount,
    required this.remindRefill,
    required this.refillRemindAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['dose'] = Variable<String>(dose);
    map['times'] = Variable<String>(times);
    map['days'] = Variable<String>(days);
    map['refill_count'] = Variable<int>(refillCount);
    map['remind_refill'] = Variable<bool>(remindRefill);
    map['refill_remind_at'] = Variable<int>(refillRemindAt);
    return map;
  }

  MedicinesCompanion toCompanion(bool nullToAbsent) {
    return MedicinesCompanion(
      id: Value(id),
      name: Value(name),
      dose: Value(dose),
      times: Value(times),
      days: Value(days),
      refillCount: Value(refillCount),
      remindRefill: Value(remindRefill),
      refillRemindAt: Value(refillRemindAt),
    );
  }

  factory MedicineRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MedicineRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      dose: serializer.fromJson<String>(json['dose']),
      times: serializer.fromJson<String>(json['times']),
      days: serializer.fromJson<String>(json['days']),
      refillCount: serializer.fromJson<int>(json['refillCount']),
      remindRefill: serializer.fromJson<bool>(json['remindRefill']),
      refillRemindAt: serializer.fromJson<int>(json['refillRemindAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'dose': serializer.toJson<String>(dose),
      'times': serializer.toJson<String>(times),
      'days': serializer.toJson<String>(days),
      'refillCount': serializer.toJson<int>(refillCount),
      'remindRefill': serializer.toJson<bool>(remindRefill),
      'refillRemindAt': serializer.toJson<int>(refillRemindAt),
    };
  }

  MedicineRow copyWith({
    String? id,
    String? name,
    String? dose,
    String? times,
    String? days,
    int? refillCount,
    bool? remindRefill,
    int? refillRemindAt,
  }) => MedicineRow(
    id: id ?? this.id,
    name: name ?? this.name,
    dose: dose ?? this.dose,
    times: times ?? this.times,
    days: days ?? this.days,
    refillCount: refillCount ?? this.refillCount,
    remindRefill: remindRefill ?? this.remindRefill,
    refillRemindAt: refillRemindAt ?? this.refillRemindAt,
  );
  MedicineRow copyWithCompanion(MedicinesCompanion data) {
    return MedicineRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      dose: data.dose.present ? data.dose.value : this.dose,
      times: data.times.present ? data.times.value : this.times,
      days: data.days.present ? data.days.value : this.days,
      refillCount: data.refillCount.present
          ? data.refillCount.value
          : this.refillCount,
      remindRefill: data.remindRefill.present
          ? data.remindRefill.value
          : this.remindRefill,
      refillRemindAt: data.refillRemindAt.present
          ? data.refillRemindAt.value
          : this.refillRemindAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MedicineRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('dose: $dose, ')
          ..write('times: $times, ')
          ..write('days: $days, ')
          ..write('refillCount: $refillCount, ')
          ..write('remindRefill: $remindRefill, ')
          ..write('refillRemindAt: $refillRemindAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    dose,
    times,
    days,
    refillCount,
    remindRefill,
    refillRemindAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MedicineRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.dose == this.dose &&
          other.times == this.times &&
          other.days == this.days &&
          other.refillCount == this.refillCount &&
          other.remindRefill == this.remindRefill &&
          other.refillRemindAt == this.refillRemindAt);
}

class MedicinesCompanion extends UpdateCompanion<MedicineRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> dose;
  final Value<String> times;
  final Value<String> days;
  final Value<int> refillCount;
  final Value<bool> remindRefill;
  final Value<int> refillRemindAt;
  final Value<int> rowid;
  const MedicinesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.dose = const Value.absent(),
    this.times = const Value.absent(),
    this.days = const Value.absent(),
    this.refillCount = const Value.absent(),
    this.remindRefill = const Value.absent(),
    this.refillRemindAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MedicinesCompanion.insert({
    required String id,
    required String name,
    required String dose,
    required String times,
    required String days,
    this.refillCount = const Value.absent(),
    this.remindRefill = const Value.absent(),
    this.refillRemindAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       dose = Value(dose),
       times = Value(times),
       days = Value(days);
  static Insertable<MedicineRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? dose,
    Expression<String>? times,
    Expression<String>? days,
    Expression<int>? refillCount,
    Expression<bool>? remindRefill,
    Expression<int>? refillRemindAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (dose != null) 'dose': dose,
      if (times != null) 'times': times,
      if (days != null) 'days': days,
      if (refillCount != null) 'refill_count': refillCount,
      if (remindRefill != null) 'remind_refill': remindRefill,
      if (refillRemindAt != null) 'refill_remind_at': refillRemindAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MedicinesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? dose,
    Value<String>? times,
    Value<String>? days,
    Value<int>? refillCount,
    Value<bool>? remindRefill,
    Value<int>? refillRemindAt,
    Value<int>? rowid,
  }) {
    return MedicinesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      dose: dose ?? this.dose,
      times: times ?? this.times,
      days: days ?? this.days,
      refillCount: refillCount ?? this.refillCount,
      remindRefill: remindRefill ?? this.remindRefill,
      refillRemindAt: refillRemindAt ?? this.refillRemindAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (dose.present) {
      map['dose'] = Variable<String>(dose.value);
    }
    if (times.present) {
      map['times'] = Variable<String>(times.value);
    }
    if (days.present) {
      map['days'] = Variable<String>(days.value);
    }
    if (refillCount.present) {
      map['refill_count'] = Variable<int>(refillCount.value);
    }
    if (remindRefill.present) {
      map['remind_refill'] = Variable<bool>(remindRefill.value);
    }
    if (refillRemindAt.present) {
      map['refill_remind_at'] = Variable<int>(refillRemindAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicinesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('dose: $dose, ')
          ..write('times: $times, ')
          ..write('days: $days, ')
          ..write('refillCount: $refillCount, ')
          ..write('remindRefill: $remindRefill, ')
          ..write('refillRemindAt: $refillRemindAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DosesTable extends Doses with TableInfo<$DosesTable, DoseRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DosesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _medicineIdMeta = const VerificationMeta(
    'medicineId',
  );
  @override
  late final GeneratedColumn<String> medicineId = GeneratedColumn<String>(
    'medicine_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scheduledAtMeta = const VerificationMeta(
    'scheduledAt',
  );
  @override
  late final GeneratedColumn<int> scheduledAt = GeneratedColumn<int>(
    'scheduled_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<int> status = GeneratedColumn<int>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [medicineId, scheduledAt, status];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'doses';
  @override
  VerificationContext validateIntegrity(
    Insertable<DoseRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('medicine_id')) {
      context.handle(
        _medicineIdMeta,
        medicineId.isAcceptableOrUnknown(data['medicine_id']!, _medicineIdMeta),
      );
    } else if (isInserting) {
      context.missing(_medicineIdMeta);
    }
    if (data.containsKey('scheduled_at')) {
      context.handle(
        _scheduledAtMeta,
        scheduledAt.isAcceptableOrUnknown(
          data['scheduled_at']!,
          _scheduledAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduledAtMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {medicineId, scheduledAt};
  @override
  DoseRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DoseRow(
      medicineId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}medicine_id'],
      )!,
      scheduledAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}scheduled_at'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $DosesTable createAlias(String alias) {
    return $DosesTable(attachedDatabase, alias);
  }
}

class DoseRow extends DataClass implements Insertable<DoseRow> {
  final String medicineId;
  final int scheduledAt;

  /// DoseStatus index.
  final int status;
  const DoseRow({
    required this.medicineId,
    required this.scheduledAt,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['medicine_id'] = Variable<String>(medicineId);
    map['scheduled_at'] = Variable<int>(scheduledAt);
    map['status'] = Variable<int>(status);
    return map;
  }

  DosesCompanion toCompanion(bool nullToAbsent) {
    return DosesCompanion(
      medicineId: Value(medicineId),
      scheduledAt: Value(scheduledAt),
      status: Value(status),
    );
  }

  factory DoseRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DoseRow(
      medicineId: serializer.fromJson<String>(json['medicineId']),
      scheduledAt: serializer.fromJson<int>(json['scheduledAt']),
      status: serializer.fromJson<int>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'medicineId': serializer.toJson<String>(medicineId),
      'scheduledAt': serializer.toJson<int>(scheduledAt),
      'status': serializer.toJson<int>(status),
    };
  }

  DoseRow copyWith({String? medicineId, int? scheduledAt, int? status}) =>
      DoseRow(
        medicineId: medicineId ?? this.medicineId,
        scheduledAt: scheduledAt ?? this.scheduledAt,
        status: status ?? this.status,
      );
  DoseRow copyWithCompanion(DosesCompanion data) {
    return DoseRow(
      medicineId: data.medicineId.present
          ? data.medicineId.value
          : this.medicineId,
      scheduledAt: data.scheduledAt.present
          ? data.scheduledAt.value
          : this.scheduledAt,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DoseRow(')
          ..write('medicineId: $medicineId, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(medicineId, scheduledAt, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DoseRow &&
          other.medicineId == this.medicineId &&
          other.scheduledAt == this.scheduledAt &&
          other.status == this.status);
}

class DosesCompanion extends UpdateCompanion<DoseRow> {
  final Value<String> medicineId;
  final Value<int> scheduledAt;
  final Value<int> status;
  final Value<int> rowid;
  const DosesCompanion({
    this.medicineId = const Value.absent(),
    this.scheduledAt = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DosesCompanion.insert({
    required String medicineId,
    required int scheduledAt,
    required int status,
    this.rowid = const Value.absent(),
  }) : medicineId = Value(medicineId),
       scheduledAt = Value(scheduledAt),
       status = Value(status);
  static Insertable<DoseRow> custom({
    Expression<String>? medicineId,
    Expression<int>? scheduledAt,
    Expression<int>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (medicineId != null) 'medicine_id': medicineId,
      if (scheduledAt != null) 'scheduled_at': scheduledAt,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DosesCompanion copyWith({
    Value<String>? medicineId,
    Value<int>? scheduledAt,
    Value<int>? status,
    Value<int>? rowid,
  }) {
    return DosesCompanion(
      medicineId: medicineId ?? this.medicineId,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (medicineId.present) {
      map['medicine_id'] = Variable<String>(medicineId.value);
    }
    if (scheduledAt.present) {
      map['scheduled_at'] = Variable<int>(scheduledAt.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DosesCompanion(')
          ..write('medicineId: $medicineId, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ModesTable extends Modes with TableInfo<$ModesTable, ModeRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ModesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jsonMeta = const VerificationMeta('json');
  @override
  late final GeneratedColumn<String> json = GeneratedColumn<String>(
    'json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, position, json];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'modes';
  @override
  VerificationContext validateIntegrity(
    Insertable<ModeRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('json')) {
      context.handle(
        _jsonMeta,
        json.isAcceptableOrUnknown(data['json']!, _jsonMeta),
      );
    } else if (isInserting) {
      context.missing(_jsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ModeRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ModeRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      json: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}json'],
      )!,
    );
  }

  @override
  $ModesTable createAlias(String alias) {
    return $ModesTable(attachedDatabase, alias);
  }
}

class ModeRow extends DataClass implements Insertable<ModeRow> {
  final String id;
  final int position;
  final String json;
  const ModeRow({required this.id, required this.position, required this.json});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['position'] = Variable<int>(position);
    map['json'] = Variable<String>(json);
    return map;
  }

  ModesCompanion toCompanion(bool nullToAbsent) {
    return ModesCompanion(
      id: Value(id),
      position: Value(position),
      json: Value(json),
    );
  }

  factory ModeRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ModeRow(
      id: serializer.fromJson<String>(json['id']),
      position: serializer.fromJson<int>(json['position']),
      json: serializer.fromJson<String>(json['json']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'position': serializer.toJson<int>(position),
      'json': serializer.toJson<String>(json),
    };
  }

  ModeRow copyWith({String? id, int? position, String? json}) => ModeRow(
    id: id ?? this.id,
    position: position ?? this.position,
    json: json ?? this.json,
  );
  ModeRow copyWithCompanion(ModesCompanion data) {
    return ModeRow(
      id: data.id.present ? data.id.value : this.id,
      position: data.position.present ? data.position.value : this.position,
      json: data.json.present ? data.json.value : this.json,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ModeRow(')
          ..write('id: $id, ')
          ..write('position: $position, ')
          ..write('json: $json')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, position, json);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ModeRow &&
          other.id == this.id &&
          other.position == this.position &&
          other.json == this.json);
}

class ModesCompanion extends UpdateCompanion<ModeRow> {
  final Value<String> id;
  final Value<int> position;
  final Value<String> json;
  final Value<int> rowid;
  const ModesCompanion({
    this.id = const Value.absent(),
    this.position = const Value.absent(),
    this.json = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ModesCompanion.insert({
    required String id,
    required int position,
    required String json,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       position = Value(position),
       json = Value(json);
  static Insertable<ModeRow> custom({
    Expression<String>? id,
    Expression<int>? position,
    Expression<String>? json,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (position != null) 'position': position,
      if (json != null) 'json': json,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ModesCompanion copyWith({
    Value<String>? id,
    Value<int>? position,
    Value<String>? json,
    Value<int>? rowid,
  }) {
    return ModesCompanion(
      id: id ?? this.id,
      position: position ?? this.position,
      json: json ?? this.json,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (json.present) {
      map['json'] = Variable<String>(json.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ModesCompanion(')
          ..write('id: $id, ')
          ..write('position: $position, ')
          ..write('json: $json, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AlarmsTable extends Alarms with TableInfo<$AlarmsTable, AlarmRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AlarmsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jsonMeta = const VerificationMeta('json');
  @override
  late final GeneratedColumn<String> json = GeneratedColumn<String>(
    'json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, json];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'alarms';
  @override
  VerificationContext validateIntegrity(
    Insertable<AlarmRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('json')) {
      context.handle(
        _jsonMeta,
        json.isAcceptableOrUnknown(data['json']!, _jsonMeta),
      );
    } else if (isInserting) {
      context.missing(_jsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AlarmRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AlarmRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      json: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}json'],
      )!,
    );
  }

  @override
  $AlarmsTable createAlias(String alias) {
    return $AlarmsTable(attachedDatabase, alias);
  }
}

class AlarmRow extends DataClass implements Insertable<AlarmRow> {
  final String id;
  final String json;
  const AlarmRow({required this.id, required this.json});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['json'] = Variable<String>(json);
    return map;
  }

  AlarmsCompanion toCompanion(bool nullToAbsent) {
    return AlarmsCompanion(id: Value(id), json: Value(json));
  }

  factory AlarmRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AlarmRow(
      id: serializer.fromJson<String>(json['id']),
      json: serializer.fromJson<String>(json['json']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'json': serializer.toJson<String>(json),
    };
  }

  AlarmRow copyWith({String? id, String? json}) =>
      AlarmRow(id: id ?? this.id, json: json ?? this.json);
  AlarmRow copyWithCompanion(AlarmsCompanion data) {
    return AlarmRow(
      id: data.id.present ? data.id.value : this.id,
      json: data.json.present ? data.json.value : this.json,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AlarmRow(')
          ..write('id: $id, ')
          ..write('json: $json')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, json);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AlarmRow && other.id == this.id && other.json == this.json);
}

class AlarmsCompanion extends UpdateCompanion<AlarmRow> {
  final Value<String> id;
  final Value<String> json;
  final Value<int> rowid;
  const AlarmsCompanion({
    this.id = const Value.absent(),
    this.json = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AlarmsCompanion.insert({
    required String id,
    required String json,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       json = Value(json);
  static Insertable<AlarmRow> custom({
    Expression<String>? id,
    Expression<String>? json,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (json != null) 'json': json,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AlarmsCompanion copyWith({
    Value<String>? id,
    Value<String>? json,
    Value<int>? rowid,
  }) {
    return AlarmsCompanion(
      id: id ?? this.id,
      json: json ?? this.json,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (json.present) {
      map['json'] = Variable<String>(json.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AlarmsCompanion(')
          ..write('id: $id, ')
          ..write('json: $json, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SoundsTable extends Sounds with TableInfo<$SoundsTable, SoundRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SoundsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lengthMsMeta = const VerificationMeta(
    'lengthMs',
  );
  @override
  late final GeneratedColumn<int> lengthMs = GeneratedColumn<int>(
    'length_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _importedAtMeta = const VerificationMeta(
    'importedAt',
  );
  @override
  late final GeneratedColumn<int> importedAt = GeneratedColumn<int>(
    'imported_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
    'path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, lengthMs, importedAt, path];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sounds';
  @override
  VerificationContext validateIntegrity(
    Insertable<SoundRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('length_ms')) {
      context.handle(
        _lengthMsMeta,
        lengthMs.isAcceptableOrUnknown(data['length_ms']!, _lengthMsMeta),
      );
    } else if (isInserting) {
      context.missing(_lengthMsMeta);
    }
    if (data.containsKey('imported_at')) {
      context.handle(
        _importedAtMeta,
        importedAt.isAcceptableOrUnknown(data['imported_at']!, _importedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_importedAtMeta);
    }
    if (data.containsKey('path')) {
      context.handle(
        _pathMeta,
        path.isAcceptableOrUnknown(data['path']!, _pathMeta),
      );
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SoundRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SoundRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      lengthMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}length_ms'],
      )!,
      importedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}imported_at'],
      )!,
      path: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}path'],
      )!,
    );
  }

  @override
  $SoundsTable createAlias(String alias) {
    return $SoundsTable(attachedDatabase, alias);
  }
}

class SoundRow extends DataClass implements Insertable<SoundRow> {
  final String id;
  final String name;
  final int lengthMs;
  final int importedAt;

  /// Copy of the audio inside the app's storage.
  final String path;
  const SoundRow({
    required this.id,
    required this.name,
    required this.lengthMs,
    required this.importedAt,
    required this.path,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['length_ms'] = Variable<int>(lengthMs);
    map['imported_at'] = Variable<int>(importedAt);
    map['path'] = Variable<String>(path);
    return map;
  }

  SoundsCompanion toCompanion(bool nullToAbsent) {
    return SoundsCompanion(
      id: Value(id),
      name: Value(name),
      lengthMs: Value(lengthMs),
      importedAt: Value(importedAt),
      path: Value(path),
    );
  }

  factory SoundRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SoundRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      lengthMs: serializer.fromJson<int>(json['lengthMs']),
      importedAt: serializer.fromJson<int>(json['importedAt']),
      path: serializer.fromJson<String>(json['path']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'lengthMs': serializer.toJson<int>(lengthMs),
      'importedAt': serializer.toJson<int>(importedAt),
      'path': serializer.toJson<String>(path),
    };
  }

  SoundRow copyWith({
    String? id,
    String? name,
    int? lengthMs,
    int? importedAt,
    String? path,
  }) => SoundRow(
    id: id ?? this.id,
    name: name ?? this.name,
    lengthMs: lengthMs ?? this.lengthMs,
    importedAt: importedAt ?? this.importedAt,
    path: path ?? this.path,
  );
  SoundRow copyWithCompanion(SoundsCompanion data) {
    return SoundRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      lengthMs: data.lengthMs.present ? data.lengthMs.value : this.lengthMs,
      importedAt: data.importedAt.present
          ? data.importedAt.value
          : this.importedAt,
      path: data.path.present ? data.path.value : this.path,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SoundRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('lengthMs: $lengthMs, ')
          ..write('importedAt: $importedAt, ')
          ..write('path: $path')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, lengthMs, importedAt, path);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SoundRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.lengthMs == this.lengthMs &&
          other.importedAt == this.importedAt &&
          other.path == this.path);
}

class SoundsCompanion extends UpdateCompanion<SoundRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> lengthMs;
  final Value<int> importedAt;
  final Value<String> path;
  final Value<int> rowid;
  const SoundsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.lengthMs = const Value.absent(),
    this.importedAt = const Value.absent(),
    this.path = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SoundsCompanion.insert({
    required String id,
    required String name,
    required int lengthMs,
    required int importedAt,
    required String path,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       lengthMs = Value(lengthMs),
       importedAt = Value(importedAt),
       path = Value(path);
  static Insertable<SoundRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? lengthMs,
    Expression<int>? importedAt,
    Expression<String>? path,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (lengthMs != null) 'length_ms': lengthMs,
      if (importedAt != null) 'imported_at': importedAt,
      if (path != null) 'path': path,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SoundsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? lengthMs,
    Value<int>? importedAt,
    Value<String>? path,
    Value<int>? rowid,
  }) {
    return SoundsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      lengthMs: lengthMs ?? this.lengthMs,
      importedAt: importedAt ?? this.importedAt,
      path: path ?? this.path,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (lengthMs.present) {
      map['length_ms'] = Variable<int>(lengthMs.value);
    }
    if (importedAt.present) {
      map['imported_at'] = Variable<int>(importedAt.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SoundsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('lengthMs: $lengthMs, ')
          ..write('importedAt: $importedAt, ')
          ..write('path: $path, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MantrasTable extends Mantras with TableInfo<$MantrasTable, MantraRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MantrasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isStarterMeta = const VerificationMeta(
    'isStarter',
  );
  @override
  late final GeneratedColumn<bool> isStarter = GeneratedColumn<bool>(
    'is_starter',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_starter" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _lastShownAtMeta = const VerificationMeta(
    'lastShownAt',
  );
  @override
  late final GeneratedColumn<int> lastShownAt = GeneratedColumn<int>(
    'last_shown_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addedAtMeta = const VerificationMeta(
    'addedAt',
  );
  @override
  late final GeneratedColumn<int> addedAt = GeneratedColumn<int>(
    'added_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    body,
    isStarter,
    lastShownAt,
    addedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mantras';
  @override
  VerificationContext validateIntegrity(
    Insertable<MantraRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('is_starter')) {
      context.handle(
        _isStarterMeta,
        isStarter.isAcceptableOrUnknown(data['is_starter']!, _isStarterMeta),
      );
    }
    if (data.containsKey('last_shown_at')) {
      context.handle(
        _lastShownAtMeta,
        lastShownAt.isAcceptableOrUnknown(
          data['last_shown_at']!,
          _lastShownAtMeta,
        ),
      );
    }
    if (data.containsKey('added_at')) {
      context.handle(
        _addedAtMeta,
        addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_addedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MantraRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MantraRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      isStarter: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_starter'],
      )!,
      lastShownAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_shown_at'],
      ),
      addedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}added_at'],
      )!,
    );
  }

  @override
  $MantrasTable createAlias(String alias) {
    return $MantrasTable(attachedDatabase, alias);
  }
}

class MantraRow extends DataClass implements Insertable<MantraRow> {
  final String id;
  final String body;
  final bool isStarter;
  final int? lastShownAt;
  final int addedAt;
  const MantraRow({
    required this.id,
    required this.body,
    required this.isStarter,
    this.lastShownAt,
    required this.addedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['body'] = Variable<String>(body);
    map['is_starter'] = Variable<bool>(isStarter);
    if (!nullToAbsent || lastShownAt != null) {
      map['last_shown_at'] = Variable<int>(lastShownAt);
    }
    map['added_at'] = Variable<int>(addedAt);
    return map;
  }

  MantrasCompanion toCompanion(bool nullToAbsent) {
    return MantrasCompanion(
      id: Value(id),
      body: Value(body),
      isStarter: Value(isStarter),
      lastShownAt: lastShownAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastShownAt),
      addedAt: Value(addedAt),
    );
  }

  factory MantraRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MantraRow(
      id: serializer.fromJson<String>(json['id']),
      body: serializer.fromJson<String>(json['body']),
      isStarter: serializer.fromJson<bool>(json['isStarter']),
      lastShownAt: serializer.fromJson<int?>(json['lastShownAt']),
      addedAt: serializer.fromJson<int>(json['addedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'body': serializer.toJson<String>(body),
      'isStarter': serializer.toJson<bool>(isStarter),
      'lastShownAt': serializer.toJson<int?>(lastShownAt),
      'addedAt': serializer.toJson<int>(addedAt),
    };
  }

  MantraRow copyWith({
    String? id,
    String? body,
    bool? isStarter,
    Value<int?> lastShownAt = const Value.absent(),
    int? addedAt,
  }) => MantraRow(
    id: id ?? this.id,
    body: body ?? this.body,
    isStarter: isStarter ?? this.isStarter,
    lastShownAt: lastShownAt.present ? lastShownAt.value : this.lastShownAt,
    addedAt: addedAt ?? this.addedAt,
  );
  MantraRow copyWithCompanion(MantrasCompanion data) {
    return MantraRow(
      id: data.id.present ? data.id.value : this.id,
      body: data.body.present ? data.body.value : this.body,
      isStarter: data.isStarter.present ? data.isStarter.value : this.isStarter,
      lastShownAt: data.lastShownAt.present
          ? data.lastShownAt.value
          : this.lastShownAt,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MantraRow(')
          ..write('id: $id, ')
          ..write('body: $body, ')
          ..write('isStarter: $isStarter, ')
          ..write('lastShownAt: $lastShownAt, ')
          ..write('addedAt: $addedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, body, isStarter, lastShownAt, addedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MantraRow &&
          other.id == this.id &&
          other.body == this.body &&
          other.isStarter == this.isStarter &&
          other.lastShownAt == this.lastShownAt &&
          other.addedAt == this.addedAt);
}

class MantrasCompanion extends UpdateCompanion<MantraRow> {
  final Value<String> id;
  final Value<String> body;
  final Value<bool> isStarter;
  final Value<int?> lastShownAt;
  final Value<int> addedAt;
  final Value<int> rowid;
  const MantrasCompanion({
    this.id = const Value.absent(),
    this.body = const Value.absent(),
    this.isStarter = const Value.absent(),
    this.lastShownAt = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MantrasCompanion.insert({
    required String id,
    required String body,
    this.isStarter = const Value.absent(),
    this.lastShownAt = const Value.absent(),
    required int addedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       body = Value(body),
       addedAt = Value(addedAt);
  static Insertable<MantraRow> custom({
    Expression<String>? id,
    Expression<String>? body,
    Expression<bool>? isStarter,
    Expression<int>? lastShownAt,
    Expression<int>? addedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (body != null) 'body': body,
      if (isStarter != null) 'is_starter': isStarter,
      if (lastShownAt != null) 'last_shown_at': lastShownAt,
      if (addedAt != null) 'added_at': addedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MantrasCompanion copyWith({
    Value<String>? id,
    Value<String>? body,
    Value<bool>? isStarter,
    Value<int?>? lastShownAt,
    Value<int>? addedAt,
    Value<int>? rowid,
  }) {
    return MantrasCompanion(
      id: id ?? this.id,
      body: body ?? this.body,
      isStarter: isStarter ?? this.isStarter,
      lastShownAt: lastShownAt ?? this.lastShownAt,
      addedAt: addedAt ?? this.addedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (isStarter.present) {
      map['is_starter'] = Variable<bool>(isStarter.value);
    }
    if (lastShownAt.present) {
      map['last_shown_at'] = Variable<int>(lastShownAt.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<int>(addedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MantrasCompanion(')
          ..write('id: $id, ')
          ..write('body: $body, ')
          ..write('isStarter: $isStarter, ')
          ..write('lastShownAt: $lastShownAt, ')
          ..write('addedAt: $addedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AudioMantrasTable extends AudioMantras
    with TableInfo<$AudioMantrasTable, AudioMantraRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AudioMantrasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _youTubeMeta = const VerificationMeta(
    'youTube',
  );
  @override
  late final GeneratedColumn<bool> youTube = GeneratedColumn<bool>(
    'you_tube',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("you_tube" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _lengthMsMeta = const VerificationMeta(
    'lengthMs',
  );
  @override
  late final GeneratedColumn<int> lengthMs = GeneratedColumn<int>(
    'length_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _addedAtMeta = const VerificationMeta(
    'addedAt',
  );
  @override
  late final GeneratedColumn<int> addedAt = GeneratedColumn<int>(
    'added_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    source,
    youTube,
    lengthMs,
    addedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'audio_mantras';
  @override
  VerificationContext validateIntegrity(
    Insertable<AudioMantraRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('you_tube')) {
      context.handle(
        _youTubeMeta,
        youTube.isAcceptableOrUnknown(data['you_tube']!, _youTubeMeta),
      );
    }
    if (data.containsKey('length_ms')) {
      context.handle(
        _lengthMsMeta,
        lengthMs.isAcceptableOrUnknown(data['length_ms']!, _lengthMsMeta),
      );
    }
    if (data.containsKey('added_at')) {
      context.handle(
        _addedAtMeta,
        addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_addedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AudioMantraRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AudioMantraRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      youTube: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}you_tube'],
      )!,
      lengthMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}length_ms'],
      )!,
      addedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}added_at'],
      )!,
    );
  }

  @override
  $AudioMantrasTable createAlias(String alias) {
    return $AudioMantrasTable(attachedDatabase, alias);
  }
}

class AudioMantraRow extends DataClass implements Insertable<AudioMantraRow> {
  final String id;
  final String title;

  /// The file's path in the app, or the YouTube link.
  final String source;
  final bool youTube;
  final int lengthMs;
  final int addedAt;
  const AudioMantraRow({
    required this.id,
    required this.title,
    required this.source,
    required this.youTube,
    required this.lengthMs,
    required this.addedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['source'] = Variable<String>(source);
    map['you_tube'] = Variable<bool>(youTube);
    map['length_ms'] = Variable<int>(lengthMs);
    map['added_at'] = Variable<int>(addedAt);
    return map;
  }

  AudioMantrasCompanion toCompanion(bool nullToAbsent) {
    return AudioMantrasCompanion(
      id: Value(id),
      title: Value(title),
      source: Value(source),
      youTube: Value(youTube),
      lengthMs: Value(lengthMs),
      addedAt: Value(addedAt),
    );
  }

  factory AudioMantraRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AudioMantraRow(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      source: serializer.fromJson<String>(json['source']),
      youTube: serializer.fromJson<bool>(json['youTube']),
      lengthMs: serializer.fromJson<int>(json['lengthMs']),
      addedAt: serializer.fromJson<int>(json['addedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'source': serializer.toJson<String>(source),
      'youTube': serializer.toJson<bool>(youTube),
      'lengthMs': serializer.toJson<int>(lengthMs),
      'addedAt': serializer.toJson<int>(addedAt),
    };
  }

  AudioMantraRow copyWith({
    String? id,
    String? title,
    String? source,
    bool? youTube,
    int? lengthMs,
    int? addedAt,
  }) => AudioMantraRow(
    id: id ?? this.id,
    title: title ?? this.title,
    source: source ?? this.source,
    youTube: youTube ?? this.youTube,
    lengthMs: lengthMs ?? this.lengthMs,
    addedAt: addedAt ?? this.addedAt,
  );
  AudioMantraRow copyWithCompanion(AudioMantrasCompanion data) {
    return AudioMantraRow(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      source: data.source.present ? data.source.value : this.source,
      youTube: data.youTube.present ? data.youTube.value : this.youTube,
      lengthMs: data.lengthMs.present ? data.lengthMs.value : this.lengthMs,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AudioMantraRow(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('source: $source, ')
          ..write('youTube: $youTube, ')
          ..write('lengthMs: $lengthMs, ')
          ..write('addedAt: $addedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, source, youTube, lengthMs, addedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AudioMantraRow &&
          other.id == this.id &&
          other.title == this.title &&
          other.source == this.source &&
          other.youTube == this.youTube &&
          other.lengthMs == this.lengthMs &&
          other.addedAt == this.addedAt);
}

class AudioMantrasCompanion extends UpdateCompanion<AudioMantraRow> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> source;
  final Value<bool> youTube;
  final Value<int> lengthMs;
  final Value<int> addedAt;
  final Value<int> rowid;
  const AudioMantrasCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.source = const Value.absent(),
    this.youTube = const Value.absent(),
    this.lengthMs = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AudioMantrasCompanion.insert({
    required String id,
    required String title,
    required String source,
    this.youTube = const Value.absent(),
    this.lengthMs = const Value.absent(),
    required int addedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       source = Value(source),
       addedAt = Value(addedAt);
  static Insertable<AudioMantraRow> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? source,
    Expression<bool>? youTube,
    Expression<int>? lengthMs,
    Expression<int>? addedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (source != null) 'source': source,
      if (youTube != null) 'you_tube': youTube,
      if (lengthMs != null) 'length_ms': lengthMs,
      if (addedAt != null) 'added_at': addedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AudioMantrasCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? source,
    Value<bool>? youTube,
    Value<int>? lengthMs,
    Value<int>? addedAt,
    Value<int>? rowid,
  }) {
    return AudioMantrasCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      source: source ?? this.source,
      youTube: youTube ?? this.youTube,
      lengthMs: lengthMs ?? this.lengthMs,
      addedAt: addedAt ?? this.addedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (youTube.present) {
      map['you_tube'] = Variable<bool>(youTube.value);
    }
    if (lengthMs.present) {
      map['length_ms'] = Variable<int>(lengthMs.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<int>(addedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AudioMantrasCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('source: $source, ')
          ..write('youTube: $youTube, ')
          ..write('lengthMs: $lengthMs, ')
          ..write('addedAt: $addedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$VeronicaDatabase extends GeneratedDatabase {
  _$VeronicaDatabase(QueryExecutor e) : super(e);
  $VeronicaDatabaseManager get managers => $VeronicaDatabaseManager(this);
  late final $WatchedAppsTable watchedApps = $WatchedAppsTable(this);
  late final $UsageDaysTable usageDays = $UsageDaysTable(this);
  late final $OverrideLogsTable overrideLogs = $OverrideLogsTable(this);
  late final $PrefsTable prefs = $PrefsTable(this);
  late final $TasksTable tasks = $TasksTable(this);
  late final $WaterLogsTable waterLogs = $WaterLogsTable(this);
  late final $MedicinesTable medicines = $MedicinesTable(this);
  late final $DosesTable doses = $DosesTable(this);
  late final $ModesTable modes = $ModesTable(this);
  late final $AlarmsTable alarms = $AlarmsTable(this);
  late final $SoundsTable sounds = $SoundsTable(this);
  late final $MantrasTable mantras = $MantrasTable(this);
  late final $AudioMantrasTable audioMantras = $AudioMantrasTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    watchedApps,
    usageDays,
    overrideLogs,
    prefs,
    tasks,
    waterLogs,
    medicines,
    doses,
    modes,
    alarms,
    sounds,
    mantras,
    audioMantras,
  ];
}

typedef $$WatchedAppsTableCreateCompanionBuilder =
    WatchedAppsCompanion Function({
      required String packageName,
      required String name,
      required int dailyLimitMin,
      Value<int> nudgeAtPercent,
      Value<bool> hardBlock,
      Value<int> extensionsPerDay,
      required int addedAt,
      Value<int> rowid,
    });
typedef $$WatchedAppsTableUpdateCompanionBuilder =
    WatchedAppsCompanion Function({
      Value<String> packageName,
      Value<String> name,
      Value<int> dailyLimitMin,
      Value<int> nudgeAtPercent,
      Value<bool> hardBlock,
      Value<int> extensionsPerDay,
      Value<int> addedAt,
      Value<int> rowid,
    });

class $$WatchedAppsTableFilterComposer
    extends Composer<_$VeronicaDatabase, $WatchedAppsTable> {
  $$WatchedAppsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get packageName => $composableBuilder(
    column: $table.packageName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dailyLimitMin => $composableBuilder(
    column: $table.dailyLimitMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get nudgeAtPercent => $composableBuilder(
    column: $table.nudgeAtPercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hardBlock => $composableBuilder(
    column: $table.hardBlock,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get extensionsPerDay => $composableBuilder(
    column: $table.extensionsPerDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WatchedAppsTableOrderingComposer
    extends Composer<_$VeronicaDatabase, $WatchedAppsTable> {
  $$WatchedAppsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get packageName => $composableBuilder(
    column: $table.packageName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dailyLimitMin => $composableBuilder(
    column: $table.dailyLimitMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get nudgeAtPercent => $composableBuilder(
    column: $table.nudgeAtPercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hardBlock => $composableBuilder(
    column: $table.hardBlock,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get extensionsPerDay => $composableBuilder(
    column: $table.extensionsPerDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WatchedAppsTableAnnotationComposer
    extends Composer<_$VeronicaDatabase, $WatchedAppsTable> {
  $$WatchedAppsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get packageName => $composableBuilder(
    column: $table.packageName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get dailyLimitMin => $composableBuilder(
    column: $table.dailyLimitMin,
    builder: (column) => column,
  );

  GeneratedColumn<int> get nudgeAtPercent => $composableBuilder(
    column: $table.nudgeAtPercent,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hardBlock =>
      $composableBuilder(column: $table.hardBlock, builder: (column) => column);

  GeneratedColumn<int> get extensionsPerDay => $composableBuilder(
    column: $table.extensionsPerDay,
    builder: (column) => column,
  );

  GeneratedColumn<int> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);
}

class $$WatchedAppsTableTableManager
    extends
        RootTableManager<
          _$VeronicaDatabase,
          $WatchedAppsTable,
          WatchedAppRow,
          $$WatchedAppsTableFilterComposer,
          $$WatchedAppsTableOrderingComposer,
          $$WatchedAppsTableAnnotationComposer,
          $$WatchedAppsTableCreateCompanionBuilder,
          $$WatchedAppsTableUpdateCompanionBuilder,
          (
            WatchedAppRow,
            BaseReferences<
              _$VeronicaDatabase,
              $WatchedAppsTable,
              WatchedAppRow
            >,
          ),
          WatchedAppRow,
          PrefetchHooks Function()
        > {
  $$WatchedAppsTableTableManager(_$VeronicaDatabase db, $WatchedAppsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WatchedAppsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WatchedAppsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WatchedAppsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> packageName = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> dailyLimitMin = const Value.absent(),
                Value<int> nudgeAtPercent = const Value.absent(),
                Value<bool> hardBlock = const Value.absent(),
                Value<int> extensionsPerDay = const Value.absent(),
                Value<int> addedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WatchedAppsCompanion(
                packageName: packageName,
                name: name,
                dailyLimitMin: dailyLimitMin,
                nudgeAtPercent: nudgeAtPercent,
                hardBlock: hardBlock,
                extensionsPerDay: extensionsPerDay,
                addedAt: addedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String packageName,
                required String name,
                required int dailyLimitMin,
                Value<int> nudgeAtPercent = const Value.absent(),
                Value<bool> hardBlock = const Value.absent(),
                Value<int> extensionsPerDay = const Value.absent(),
                required int addedAt,
                Value<int> rowid = const Value.absent(),
              }) => WatchedAppsCompanion.insert(
                packageName: packageName,
                name: name,
                dailyLimitMin: dailyLimitMin,
                nudgeAtPercent: nudgeAtPercent,
                hardBlock: hardBlock,
                extensionsPerDay: extensionsPerDay,
                addedAt: addedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WatchedAppsTable, WatchedAppRow>(table),
                  BaseReferences<
                    _$VeronicaDatabase,
                    $WatchedAppsTable,
                    WatchedAppRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WatchedAppsTableProcessedTableManager =
    ProcessedTableManager<
      _$VeronicaDatabase,
      $WatchedAppsTable,
      WatchedAppRow,
      $$WatchedAppsTableFilterComposer,
      $$WatchedAppsTableOrderingComposer,
      $$WatchedAppsTableAnnotationComposer,
      $$WatchedAppsTableCreateCompanionBuilder,
      $$WatchedAppsTableUpdateCompanionBuilder,
      (
        WatchedAppRow,
        BaseReferences<_$VeronicaDatabase, $WatchedAppsTable, WatchedAppRow>,
      ),
      WatchedAppRow,
      PrefetchHooks Function()
    >;
typedef $$UsageDaysTableCreateCompanionBuilder = UsageDaysCompanion Function({
  required String packageName,
  required String day,
  Value<int> nudgesShown,
  Value<int> putDownAccepted,
  Value<int> extensionsUsed,
  Value<int> rowid,
});
typedef $$UsageDaysTableUpdateCompanionBuilder = UsageDaysCompanion Function({
  Value<String> packageName,
  Value<String> day,
  Value<int> nudgesShown,
  Value<int> putDownAccepted,
  Value<int> extensionsUsed,
  Value<int> rowid,
});

class $$UsageDaysTableFilterComposer
    extends Composer<_$VeronicaDatabase, $UsageDaysTable> {
  $$UsageDaysTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get packageName => $composableBuilder(
    column: $table.packageName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get nudgesShown => $composableBuilder(
    column: $table.nudgesShown,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get putDownAccepted => $composableBuilder(
    column: $table.putDownAccepted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get extensionsUsed => $composableBuilder(
    column: $table.extensionsUsed,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UsageDaysTableOrderingComposer
    extends Composer<_$VeronicaDatabase, $UsageDaysTable> {
  $$UsageDaysTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get packageName => $composableBuilder(
    column: $table.packageName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get nudgesShown => $composableBuilder(
    column: $table.nudgesShown,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get putDownAccepted => $composableBuilder(
    column: $table.putDownAccepted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get extensionsUsed => $composableBuilder(
    column: $table.extensionsUsed,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsageDaysTableAnnotationComposer
    extends Composer<_$VeronicaDatabase, $UsageDaysTable> {
  $$UsageDaysTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get packageName => $composableBuilder(
    column: $table.packageName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  GeneratedColumn<int> get nudgesShown => $composableBuilder(
    column: $table.nudgesShown,
    builder: (column) => column,
  );

  GeneratedColumn<int> get putDownAccepted => $composableBuilder(
    column: $table.putDownAccepted,
    builder: (column) => column,
  );

  GeneratedColumn<int> get extensionsUsed => $composableBuilder(
    column: $table.extensionsUsed,
    builder: (column) => column,
  );
}

class $$UsageDaysTableTableManager
    extends
        RootTableManager<
          _$VeronicaDatabase,
          $UsageDaysTable,
          UsageDayRow,
          $$UsageDaysTableFilterComposer,
          $$UsageDaysTableOrderingComposer,
          $$UsageDaysTableAnnotationComposer,
          $$UsageDaysTableCreateCompanionBuilder,
          $$UsageDaysTableUpdateCompanionBuilder,
          (
            UsageDayRow,
            BaseReferences<_$VeronicaDatabase, $UsageDaysTable, UsageDayRow>,
          ),
          UsageDayRow,
          PrefetchHooks Function()
        > {
  $$UsageDaysTableTableManager(_$VeronicaDatabase db, $UsageDaysTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsageDaysTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsageDaysTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsageDaysTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> packageName = const Value.absent(),
                Value<String> day = const Value.absent(),
                Value<int> nudgesShown = const Value.absent(),
                Value<int> putDownAccepted = const Value.absent(),
                Value<int> extensionsUsed = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsageDaysCompanion(
                packageName: packageName,
                day: day,
                nudgesShown: nudgesShown,
                putDownAccepted: putDownAccepted,
                extensionsUsed: extensionsUsed,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String packageName,
                required String day,
                Value<int> nudgesShown = const Value.absent(),
                Value<int> putDownAccepted = const Value.absent(),
                Value<int> extensionsUsed = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsageDaysCompanion.insert(
                packageName: packageName,
                day: day,
                nudgesShown: nudgesShown,
                putDownAccepted: putDownAccepted,
                extensionsUsed: extensionsUsed,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$UsageDaysTable, UsageDayRow>(table),
                  BaseReferences<
                    _$VeronicaDatabase,
                    $UsageDaysTable,
                    UsageDayRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsageDaysTableProcessedTableManager =
    ProcessedTableManager<
      _$VeronicaDatabase,
      $UsageDaysTable,
      UsageDayRow,
      $$UsageDaysTableFilterComposer,
      $$UsageDaysTableOrderingComposer,
      $$UsageDaysTableAnnotationComposer,
      $$UsageDaysTableCreateCompanionBuilder,
      $$UsageDaysTableUpdateCompanionBuilder,
      (
        UsageDayRow,
        BaseReferences<_$VeronicaDatabase, $UsageDaysTable, UsageDayRow>,
      ),
      UsageDayRow,
      PrefetchHooks Function()
    >;
typedef $$OverrideLogsTableCreateCompanionBuilder =
    OverrideLogsCompanion Function({
      Value<int> id,
      required String packageName,
      required int at,
    });
typedef $$OverrideLogsTableUpdateCompanionBuilder =
    OverrideLogsCompanion Function({
      Value<int> id,
      Value<String> packageName,
      Value<int> at,
    });

class $$OverrideLogsTableFilterComposer
    extends Composer<_$VeronicaDatabase, $OverrideLogsTable> {
  $$OverrideLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get packageName => $composableBuilder(
    column: $table.packageName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OverrideLogsTableOrderingComposer
    extends Composer<_$VeronicaDatabase, $OverrideLogsTable> {
  $$OverrideLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get packageName => $composableBuilder(
    column: $table.packageName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OverrideLogsTableAnnotationComposer
    extends Composer<_$VeronicaDatabase, $OverrideLogsTable> {
  $$OverrideLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get packageName => $composableBuilder(
    column: $table.packageName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get at =>
      $composableBuilder(column: $table.at, builder: (column) => column);
}

class $$OverrideLogsTableTableManager
    extends
        RootTableManager<
          _$VeronicaDatabase,
          $OverrideLogsTable,
          OverrideRow,
          $$OverrideLogsTableFilterComposer,
          $$OverrideLogsTableOrderingComposer,
          $$OverrideLogsTableAnnotationComposer,
          $$OverrideLogsTableCreateCompanionBuilder,
          $$OverrideLogsTableUpdateCompanionBuilder,
          (
            OverrideRow,
            BaseReferences<_$VeronicaDatabase, $OverrideLogsTable, OverrideRow>,
          ),
          OverrideRow,
          PrefetchHooks Function()
        > {
  $$OverrideLogsTableTableManager(
    _$VeronicaDatabase db,
    $OverrideLogsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OverrideLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OverrideLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OverrideLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> packageName = const Value.absent(),
            Value<int> at = const Value.absent(),
          }) => OverrideLogsCompanion(id: id, packageName: packageName, at: at),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String packageName,
                required int at,
              }) => OverrideLogsCompanion.insert(
                id: id,
                packageName: packageName,
                at: at,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$OverrideLogsTable, OverrideRow>(table),
                  BaseReferences<
                    _$VeronicaDatabase,
                    $OverrideLogsTable,
                    OverrideRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OverrideLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$VeronicaDatabase,
      $OverrideLogsTable,
      OverrideRow,
      $$OverrideLogsTableFilterComposer,
      $$OverrideLogsTableOrderingComposer,
      $$OverrideLogsTableAnnotationComposer,
      $$OverrideLogsTableCreateCompanionBuilder,
      $$OverrideLogsTableUpdateCompanionBuilder,
      (
        OverrideRow,
        BaseReferences<_$VeronicaDatabase, $OverrideLogsTable, OverrideRow>,
      ),
      OverrideRow,
      PrefetchHooks Function()
    >;
typedef $$PrefsTableCreateCompanionBuilder = PrefsCompanion Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$PrefsTableUpdateCompanionBuilder = PrefsCompanion Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$PrefsTableFilterComposer
    extends Composer<_$VeronicaDatabase, $PrefsTable> {
  $$PrefsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PrefsTableOrderingComposer
    extends Composer<_$VeronicaDatabase, $PrefsTable> {
  $$PrefsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PrefsTableAnnotationComposer
    extends Composer<_$VeronicaDatabase, $PrefsTable> {
  $$PrefsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$PrefsTableTableManager
    extends
        RootTableManager<
          _$VeronicaDatabase,
          $PrefsTable,
          PrefRow,
          $$PrefsTableFilterComposer,
          $$PrefsTableOrderingComposer,
          $$PrefsTableAnnotationComposer,
          $$PrefsTableCreateCompanionBuilder,
          $$PrefsTableUpdateCompanionBuilder,
          (PrefRow, BaseReferences<_$VeronicaDatabase, $PrefsTable, PrefRow>),
          PrefRow,
          PrefetchHooks Function()
        > {
  $$PrefsTableTableManager(_$VeronicaDatabase db, $PrefsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PrefsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PrefsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PrefsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => PrefsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) => PrefsCompanion.insert(key: key, value: value, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PrefsTable, PrefRow>(table),
                  BaseReferences<_$VeronicaDatabase, $PrefsTable, PrefRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PrefsTableProcessedTableManager =
    ProcessedTableManager<
      _$VeronicaDatabase,
      $PrefsTable,
      PrefRow,
      $$PrefsTableFilterComposer,
      $$PrefsTableOrderingComposer,
      $$PrefsTableAnnotationComposer,
      $$PrefsTableCreateCompanionBuilder,
      $$PrefsTableUpdateCompanionBuilder,
      (PrefRow, BaseReferences<_$VeronicaDatabase, $PrefsTable, PrefRow>),
      PrefRow,
      PrefetchHooks Function()
    >;
typedef $$TasksTableCreateCompanionBuilder = TasksCompanion Function({
  required String id,
  required String title,
  Value<String> notes,
  required int createdAt,
  Value<int?> dueAt,
  Value<int?> completedAt,
  Value<int> priority,
  Value<int> rowid,
});
typedef $$TasksTableUpdateCompanionBuilder = TasksCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<String> notes,
  Value<int> createdAt,
  Value<int?> dueAt,
  Value<int?> completedAt,
  Value<int> priority,
  Value<int> rowid,
});

class $$TasksTableFilterComposer
    extends Composer<_$VeronicaDatabase, $TasksTable> {
  $$TasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dueAt => $composableBuilder(
    column: $table.dueAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TasksTableOrderingComposer
    extends Composer<_$VeronicaDatabase, $TasksTable> {
  $$TasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dueAt => $composableBuilder(
    column: $table.dueAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TasksTableAnnotationComposer
    extends Composer<_$VeronicaDatabase, $TasksTable> {
  $$TasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get dueAt =>
      $composableBuilder(column: $table.dueAt, builder: (column) => column);

  GeneratedColumn<int> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);
}

class $$TasksTableTableManager
    extends
        RootTableManager<
          _$VeronicaDatabase,
          $TasksTable,
          TaskRow,
          $$TasksTableFilterComposer,
          $$TasksTableOrderingComposer,
          $$TasksTableAnnotationComposer,
          $$TasksTableCreateCompanionBuilder,
          $$TasksTableUpdateCompanionBuilder,
          (TaskRow, BaseReferences<_$VeronicaDatabase, $TasksTable, TaskRow>),
          TaskRow,
          PrefetchHooks Function()
        > {
  $$TasksTableTableManager(_$VeronicaDatabase db, $TasksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int?> dueAt = const Value.absent(),
                Value<int?> completedAt = const Value.absent(),
                Value<int> priority = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TasksCompanion(
                id: id,
                title: title,
                notes: notes,
                createdAt: createdAt,
                dueAt: dueAt,
                completedAt: completedAt,
                priority: priority,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                Value<String> notes = const Value.absent(),
                required int createdAt,
                Value<int?> dueAt = const Value.absent(),
                Value<int?> completedAt = const Value.absent(),
                Value<int> priority = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TasksCompanion.insert(
                id: id,
                title: title,
                notes: notes,
                createdAt: createdAt,
                dueAt: dueAt,
                completedAt: completedAt,
                priority: priority,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TasksTable, TaskRow>(table),
                  BaseReferences<_$VeronicaDatabase, $TasksTable, TaskRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TasksTableProcessedTableManager =
    ProcessedTableManager<
      _$VeronicaDatabase,
      $TasksTable,
      TaskRow,
      $$TasksTableFilterComposer,
      $$TasksTableOrderingComposer,
      $$TasksTableAnnotationComposer,
      $$TasksTableCreateCompanionBuilder,
      $$TasksTableUpdateCompanionBuilder,
      (TaskRow, BaseReferences<_$VeronicaDatabase, $TasksTable, TaskRow>),
      TaskRow,
      PrefetchHooks Function()
    >;
typedef $$WaterLogsTableCreateCompanionBuilder = WaterLogsCompanion Function({
  required String id,
  required int at,
  required int ml,
  Value<int> rowid,
});
typedef $$WaterLogsTableUpdateCompanionBuilder = WaterLogsCompanion Function({
  Value<String> id,
  Value<int> at,
  Value<int> ml,
  Value<int> rowid,
});

class $$WaterLogsTableFilterComposer
    extends Composer<_$VeronicaDatabase, $WaterLogsTable> {
  $$WaterLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ml => $composableBuilder(
    column: $table.ml,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WaterLogsTableOrderingComposer
    extends Composer<_$VeronicaDatabase, $WaterLogsTable> {
  $$WaterLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ml => $composableBuilder(
    column: $table.ml,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WaterLogsTableAnnotationComposer
    extends Composer<_$VeronicaDatabase, $WaterLogsTable> {
  $$WaterLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get at =>
      $composableBuilder(column: $table.at, builder: (column) => column);

  GeneratedColumn<int> get ml =>
      $composableBuilder(column: $table.ml, builder: (column) => column);
}

class $$WaterLogsTableTableManager
    extends
        RootTableManager<
          _$VeronicaDatabase,
          $WaterLogsTable,
          WaterLogRow,
          $$WaterLogsTableFilterComposer,
          $$WaterLogsTableOrderingComposer,
          $$WaterLogsTableAnnotationComposer,
          $$WaterLogsTableCreateCompanionBuilder,
          $$WaterLogsTableUpdateCompanionBuilder,
          (
            WaterLogRow,
            BaseReferences<_$VeronicaDatabase, $WaterLogsTable, WaterLogRow>,
          ),
          WaterLogRow,
          PrefetchHooks Function()
        > {
  $$WaterLogsTableTableManager(_$VeronicaDatabase db, $WaterLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WaterLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WaterLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WaterLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<int> at = const Value.absent(),
            Value<int> ml = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => WaterLogsCompanion(id: id, at: at, ml: ml, rowid: rowid),
          createCompanionCallback: ({
            required String id,
            required int at,
            required int ml,
            Value<int> rowid = const Value.absent(),
          }) => WaterLogsCompanion.insert(id: id, at: at, ml: ml, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WaterLogsTable, WaterLogRow>(table),
                  BaseReferences<
                    _$VeronicaDatabase,
                    $WaterLogsTable,
                    WaterLogRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WaterLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$VeronicaDatabase,
      $WaterLogsTable,
      WaterLogRow,
      $$WaterLogsTableFilterComposer,
      $$WaterLogsTableOrderingComposer,
      $$WaterLogsTableAnnotationComposer,
      $$WaterLogsTableCreateCompanionBuilder,
      $$WaterLogsTableUpdateCompanionBuilder,
      (
        WaterLogRow,
        BaseReferences<_$VeronicaDatabase, $WaterLogsTable, WaterLogRow>,
      ),
      WaterLogRow,
      PrefetchHooks Function()
    >;
typedef $$MedicinesTableCreateCompanionBuilder = MedicinesCompanion Function({
  required String id,
  required String name,
  required String dose,
  required String times,
  required String days,
  Value<int> refillCount,
  Value<bool> remindRefill,
  Value<int> refillRemindAt,
  Value<int> rowid,
});
typedef $$MedicinesTableUpdateCompanionBuilder = MedicinesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> dose,
  Value<String> times,
  Value<String> days,
  Value<int> refillCount,
  Value<bool> remindRefill,
  Value<int> refillRemindAt,
  Value<int> rowid,
});

class $$MedicinesTableFilterComposer
    extends Composer<_$VeronicaDatabase, $MedicinesTable> {
  $$MedicinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dose => $composableBuilder(
    column: $table.dose,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get times => $composableBuilder(
    column: $table.times,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get days => $composableBuilder(
    column: $table.days,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get refillCount => $composableBuilder(
    column: $table.refillCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get remindRefill => $composableBuilder(
    column: $table.remindRefill,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get refillRemindAt => $composableBuilder(
    column: $table.refillRemindAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MedicinesTableOrderingComposer
    extends Composer<_$VeronicaDatabase, $MedicinesTable> {
  $$MedicinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dose => $composableBuilder(
    column: $table.dose,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get times => $composableBuilder(
    column: $table.times,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get days => $composableBuilder(
    column: $table.days,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get refillCount => $composableBuilder(
    column: $table.refillCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get remindRefill => $composableBuilder(
    column: $table.remindRefill,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get refillRemindAt => $composableBuilder(
    column: $table.refillRemindAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MedicinesTableAnnotationComposer
    extends Composer<_$VeronicaDatabase, $MedicinesTable> {
  $$MedicinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get dose =>
      $composableBuilder(column: $table.dose, builder: (column) => column);

  GeneratedColumn<String> get times =>
      $composableBuilder(column: $table.times, builder: (column) => column);

  GeneratedColumn<String> get days =>
      $composableBuilder(column: $table.days, builder: (column) => column);

  GeneratedColumn<int> get refillCount => $composableBuilder(
    column: $table.refillCount,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get remindRefill => $composableBuilder(
    column: $table.remindRefill,
    builder: (column) => column,
  );

  GeneratedColumn<int> get refillRemindAt => $composableBuilder(
    column: $table.refillRemindAt,
    builder: (column) => column,
  );
}

class $$MedicinesTableTableManager
    extends
        RootTableManager<
          _$VeronicaDatabase,
          $MedicinesTable,
          MedicineRow,
          $$MedicinesTableFilterComposer,
          $$MedicinesTableOrderingComposer,
          $$MedicinesTableAnnotationComposer,
          $$MedicinesTableCreateCompanionBuilder,
          $$MedicinesTableUpdateCompanionBuilder,
          (
            MedicineRow,
            BaseReferences<_$VeronicaDatabase, $MedicinesTable, MedicineRow>,
          ),
          MedicineRow,
          PrefetchHooks Function()
        > {
  $$MedicinesTableTableManager(_$VeronicaDatabase db, $MedicinesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedicinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> dose = const Value.absent(),
                Value<String> times = const Value.absent(),
                Value<String> days = const Value.absent(),
                Value<int> refillCount = const Value.absent(),
                Value<bool> remindRefill = const Value.absent(),
                Value<int> refillRemindAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MedicinesCompanion(
                id: id,
                name: name,
                dose: dose,
                times: times,
                days: days,
                refillCount: refillCount,
                remindRefill: remindRefill,
                refillRemindAt: refillRemindAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String dose,
                required String times,
                required String days,
                Value<int> refillCount = const Value.absent(),
                Value<bool> remindRefill = const Value.absent(),
                Value<int> refillRemindAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MedicinesCompanion.insert(
                id: id,
                name: name,
                dose: dose,
                times: times,
                days: days,
                refillCount: refillCount,
                remindRefill: remindRefill,
                refillRemindAt: refillRemindAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MedicinesTable, MedicineRow>(table),
                  BaseReferences<
                    _$VeronicaDatabase,
                    $MedicinesTable,
                    MedicineRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MedicinesTableProcessedTableManager =
    ProcessedTableManager<
      _$VeronicaDatabase,
      $MedicinesTable,
      MedicineRow,
      $$MedicinesTableFilterComposer,
      $$MedicinesTableOrderingComposer,
      $$MedicinesTableAnnotationComposer,
      $$MedicinesTableCreateCompanionBuilder,
      $$MedicinesTableUpdateCompanionBuilder,
      (
        MedicineRow,
        BaseReferences<_$VeronicaDatabase, $MedicinesTable, MedicineRow>,
      ),
      MedicineRow,
      PrefetchHooks Function()
    >;
typedef $$DosesTableCreateCompanionBuilder = DosesCompanion Function({
  required String medicineId,
  required int scheduledAt,
  required int status,
  Value<int> rowid,
});
typedef $$DosesTableUpdateCompanionBuilder = DosesCompanion Function({
  Value<String> medicineId,
  Value<int> scheduledAt,
  Value<int> status,
  Value<int> rowid,
});

class $$DosesTableFilterComposer
    extends Composer<_$VeronicaDatabase, $DosesTable> {
  $$DosesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get medicineId => $composableBuilder(
    column: $table.medicineId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DosesTableOrderingComposer
    extends Composer<_$VeronicaDatabase, $DosesTable> {
  $$DosesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get medicineId => $composableBuilder(
    column: $table.medicineId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DosesTableAnnotationComposer
    extends Composer<_$VeronicaDatabase, $DosesTable> {
  $$DosesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get medicineId => $composableBuilder(
    column: $table.medicineId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$DosesTableTableManager
    extends
        RootTableManager<
          _$VeronicaDatabase,
          $DosesTable,
          DoseRow,
          $$DosesTableFilterComposer,
          $$DosesTableOrderingComposer,
          $$DosesTableAnnotationComposer,
          $$DosesTableCreateCompanionBuilder,
          $$DosesTableUpdateCompanionBuilder,
          (DoseRow, BaseReferences<_$VeronicaDatabase, $DosesTable, DoseRow>),
          DoseRow,
          PrefetchHooks Function()
        > {
  $$DosesTableTableManager(_$VeronicaDatabase db, $DosesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DosesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DosesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DosesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> medicineId = const Value.absent(),
                Value<int> scheduledAt = const Value.absent(),
                Value<int> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DosesCompanion(
                medicineId: medicineId,
                scheduledAt: scheduledAt,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String medicineId,
                required int scheduledAt,
                required int status,
                Value<int> rowid = const Value.absent(),
              }) => DosesCompanion.insert(
                medicineId: medicineId,
                scheduledAt: scheduledAt,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DosesTable, DoseRow>(table),
                  BaseReferences<_$VeronicaDatabase, $DosesTable, DoseRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DosesTableProcessedTableManager =
    ProcessedTableManager<
      _$VeronicaDatabase,
      $DosesTable,
      DoseRow,
      $$DosesTableFilterComposer,
      $$DosesTableOrderingComposer,
      $$DosesTableAnnotationComposer,
      $$DosesTableCreateCompanionBuilder,
      $$DosesTableUpdateCompanionBuilder,
      (DoseRow, BaseReferences<_$VeronicaDatabase, $DosesTable, DoseRow>),
      DoseRow,
      PrefetchHooks Function()
    >;
typedef $$ModesTableCreateCompanionBuilder = ModesCompanion Function({
  required String id,
  required int position,
  required String json,
  Value<int> rowid,
});
typedef $$ModesTableUpdateCompanionBuilder = ModesCompanion Function({
  Value<String> id,
  Value<int> position,
  Value<String> json,
  Value<int> rowid,
});

class $$ModesTableFilterComposer
    extends Composer<_$VeronicaDatabase, $ModesTable> {
  $$ModesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get json => $composableBuilder(
    column: $table.json,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ModesTableOrderingComposer
    extends Composer<_$VeronicaDatabase, $ModesTable> {
  $$ModesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get json => $composableBuilder(
    column: $table.json,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ModesTableAnnotationComposer
    extends Composer<_$VeronicaDatabase, $ModesTable> {
  $$ModesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get json =>
      $composableBuilder(column: $table.json, builder: (column) => column);
}

class $$ModesTableTableManager
    extends
        RootTableManager<
          _$VeronicaDatabase,
          $ModesTable,
          ModeRow,
          $$ModesTableFilterComposer,
          $$ModesTableOrderingComposer,
          $$ModesTableAnnotationComposer,
          $$ModesTableCreateCompanionBuilder,
          $$ModesTableUpdateCompanionBuilder,
          (ModeRow, BaseReferences<_$VeronicaDatabase, $ModesTable, ModeRow>),
          ModeRow,
          PrefetchHooks Function()
        > {
  $$ModesTableTableManager(_$VeronicaDatabase db, $ModesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ModesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ModesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ModesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> json = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ModesCompanion(
                id: id,
                position: position,
                json: json,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int position,
                required String json,
                Value<int> rowid = const Value.absent(),
              }) => ModesCompanion.insert(
                id: id,
                position: position,
                json: json,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ModesTable, ModeRow>(table),
                  BaseReferences<_$VeronicaDatabase, $ModesTable, ModeRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ModesTableProcessedTableManager =
    ProcessedTableManager<
      _$VeronicaDatabase,
      $ModesTable,
      ModeRow,
      $$ModesTableFilterComposer,
      $$ModesTableOrderingComposer,
      $$ModesTableAnnotationComposer,
      $$ModesTableCreateCompanionBuilder,
      $$ModesTableUpdateCompanionBuilder,
      (ModeRow, BaseReferences<_$VeronicaDatabase, $ModesTable, ModeRow>),
      ModeRow,
      PrefetchHooks Function()
    >;
typedef $$AlarmsTableCreateCompanionBuilder = AlarmsCompanion Function({
  required String id,
  required String json,
  Value<int> rowid,
});
typedef $$AlarmsTableUpdateCompanionBuilder = AlarmsCompanion Function({
  Value<String> id,
  Value<String> json,
  Value<int> rowid,
});

class $$AlarmsTableFilterComposer
    extends Composer<_$VeronicaDatabase, $AlarmsTable> {
  $$AlarmsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get json => $composableBuilder(
    column: $table.json,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AlarmsTableOrderingComposer
    extends Composer<_$VeronicaDatabase, $AlarmsTable> {
  $$AlarmsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get json => $composableBuilder(
    column: $table.json,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AlarmsTableAnnotationComposer
    extends Composer<_$VeronicaDatabase, $AlarmsTable> {
  $$AlarmsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get json =>
      $composableBuilder(column: $table.json, builder: (column) => column);
}

class $$AlarmsTableTableManager
    extends
        RootTableManager<
          _$VeronicaDatabase,
          $AlarmsTable,
          AlarmRow,
          $$AlarmsTableFilterComposer,
          $$AlarmsTableOrderingComposer,
          $$AlarmsTableAnnotationComposer,
          $$AlarmsTableCreateCompanionBuilder,
          $$AlarmsTableUpdateCompanionBuilder,
          (
            AlarmRow,
            BaseReferences<_$VeronicaDatabase, $AlarmsTable, AlarmRow>,
          ),
          AlarmRow,
          PrefetchHooks Function()
        > {
  $$AlarmsTableTableManager(_$VeronicaDatabase db, $AlarmsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AlarmsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AlarmsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AlarmsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> json = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => AlarmsCompanion(id: id, json: json, rowid: rowid),
          createCompanionCallback: ({
            required String id,
            required String json,
            Value<int> rowid = const Value.absent(),
          }) => AlarmsCompanion.insert(id: id, json: json, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AlarmsTable, AlarmRow>(table),
                  BaseReferences<_$VeronicaDatabase, $AlarmsTable, AlarmRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AlarmsTableProcessedTableManager =
    ProcessedTableManager<
      _$VeronicaDatabase,
      $AlarmsTable,
      AlarmRow,
      $$AlarmsTableFilterComposer,
      $$AlarmsTableOrderingComposer,
      $$AlarmsTableAnnotationComposer,
      $$AlarmsTableCreateCompanionBuilder,
      $$AlarmsTableUpdateCompanionBuilder,
      (AlarmRow, BaseReferences<_$VeronicaDatabase, $AlarmsTable, AlarmRow>),
      AlarmRow,
      PrefetchHooks Function()
    >;
typedef $$SoundsTableCreateCompanionBuilder = SoundsCompanion Function({
  required String id,
  required String name,
  required int lengthMs,
  required int importedAt,
  required String path,
  Value<int> rowid,
});
typedef $$SoundsTableUpdateCompanionBuilder = SoundsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<int> lengthMs,
  Value<int> importedAt,
  Value<String> path,
  Value<int> rowid,
});

class $$SoundsTableFilterComposer
    extends Composer<_$VeronicaDatabase, $SoundsTable> {
  $$SoundsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lengthMs => $composableBuilder(
    column: $table.lengthMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get importedAt => $composableBuilder(
    column: $table.importedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SoundsTableOrderingComposer
    extends Composer<_$VeronicaDatabase, $SoundsTable> {
  $$SoundsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lengthMs => $composableBuilder(
    column: $table.lengthMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get importedAt => $composableBuilder(
    column: $table.importedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SoundsTableAnnotationComposer
    extends Composer<_$VeronicaDatabase, $SoundsTable> {
  $$SoundsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get lengthMs =>
      $composableBuilder(column: $table.lengthMs, builder: (column) => column);

  GeneratedColumn<int> get importedAt => $composableBuilder(
    column: $table.importedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);
}

class $$SoundsTableTableManager
    extends
        RootTableManager<
          _$VeronicaDatabase,
          $SoundsTable,
          SoundRow,
          $$SoundsTableFilterComposer,
          $$SoundsTableOrderingComposer,
          $$SoundsTableAnnotationComposer,
          $$SoundsTableCreateCompanionBuilder,
          $$SoundsTableUpdateCompanionBuilder,
          (
            SoundRow,
            BaseReferences<_$VeronicaDatabase, $SoundsTable, SoundRow>,
          ),
          SoundRow,
          PrefetchHooks Function()
        > {
  $$SoundsTableTableManager(_$VeronicaDatabase db, $SoundsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SoundsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SoundsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SoundsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> lengthMs = const Value.absent(),
                Value<int> importedAt = const Value.absent(),
                Value<String> path = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SoundsCompanion(
                id: id,
                name: name,
                lengthMs: lengthMs,
                importedAt: importedAt,
                path: path,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required int lengthMs,
                required int importedAt,
                required String path,
                Value<int> rowid = const Value.absent(),
              }) => SoundsCompanion.insert(
                id: id,
                name: name,
                lengthMs: lengthMs,
                importedAt: importedAt,
                path: path,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SoundsTable, SoundRow>(table),
                  BaseReferences<_$VeronicaDatabase, $SoundsTable, SoundRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SoundsTableProcessedTableManager =
    ProcessedTableManager<
      _$VeronicaDatabase,
      $SoundsTable,
      SoundRow,
      $$SoundsTableFilterComposer,
      $$SoundsTableOrderingComposer,
      $$SoundsTableAnnotationComposer,
      $$SoundsTableCreateCompanionBuilder,
      $$SoundsTableUpdateCompanionBuilder,
      (SoundRow, BaseReferences<_$VeronicaDatabase, $SoundsTable, SoundRow>),
      SoundRow,
      PrefetchHooks Function()
    >;
typedef $$MantrasTableCreateCompanionBuilder = MantrasCompanion Function({
  required String id,
  required String body,
  Value<bool> isStarter,
  Value<int?> lastShownAt,
  required int addedAt,
  Value<int> rowid,
});
typedef $$MantrasTableUpdateCompanionBuilder = MantrasCompanion Function({
  Value<String> id,
  Value<String> body,
  Value<bool> isStarter,
  Value<int?> lastShownAt,
  Value<int> addedAt,
  Value<int> rowid,
});

class $$MantrasTableFilterComposer
    extends Composer<_$VeronicaDatabase, $MantrasTable> {
  $$MantrasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isStarter => $composableBuilder(
    column: $table.isStarter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastShownAt => $composableBuilder(
    column: $table.lastShownAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MantrasTableOrderingComposer
    extends Composer<_$VeronicaDatabase, $MantrasTable> {
  $$MantrasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isStarter => $composableBuilder(
    column: $table.isStarter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastShownAt => $composableBuilder(
    column: $table.lastShownAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MantrasTableAnnotationComposer
    extends Composer<_$VeronicaDatabase, $MantrasTable> {
  $$MantrasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<bool> get isStarter =>
      $composableBuilder(column: $table.isStarter, builder: (column) => column);

  GeneratedColumn<int> get lastShownAt => $composableBuilder(
    column: $table.lastShownAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);
}

class $$MantrasTableTableManager
    extends
        RootTableManager<
          _$VeronicaDatabase,
          $MantrasTable,
          MantraRow,
          $$MantrasTableFilterComposer,
          $$MantrasTableOrderingComposer,
          $$MantrasTableAnnotationComposer,
          $$MantrasTableCreateCompanionBuilder,
          $$MantrasTableUpdateCompanionBuilder,
          (
            MantraRow,
            BaseReferences<_$VeronicaDatabase, $MantrasTable, MantraRow>,
          ),
          MantraRow,
          PrefetchHooks Function()
        > {
  $$MantrasTableTableManager(_$VeronicaDatabase db, $MantrasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MantrasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MantrasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MantrasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<bool> isStarter = const Value.absent(),
                Value<int?> lastShownAt = const Value.absent(),
                Value<int> addedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MantrasCompanion(
                id: id,
                body: body,
                isStarter: isStarter,
                lastShownAt: lastShownAt,
                addedAt: addedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String body,
                Value<bool> isStarter = const Value.absent(),
                Value<int?> lastShownAt = const Value.absent(),
                required int addedAt,
                Value<int> rowid = const Value.absent(),
              }) => MantrasCompanion.insert(
                id: id,
                body: body,
                isStarter: isStarter,
                lastShownAt: lastShownAt,
                addedAt: addedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MantrasTable, MantraRow>(table),
                  BaseReferences<_$VeronicaDatabase, $MantrasTable, MantraRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MantrasTableProcessedTableManager =
    ProcessedTableManager<
      _$VeronicaDatabase,
      $MantrasTable,
      MantraRow,
      $$MantrasTableFilterComposer,
      $$MantrasTableOrderingComposer,
      $$MantrasTableAnnotationComposer,
      $$MantrasTableCreateCompanionBuilder,
      $$MantrasTableUpdateCompanionBuilder,
      (MantraRow, BaseReferences<_$VeronicaDatabase, $MantrasTable, MantraRow>),
      MantraRow,
      PrefetchHooks Function()
    >;
typedef $$AudioMantrasTableCreateCompanionBuilder =
    AudioMantrasCompanion Function({
      required String id,
      required String title,
      required String source,
      Value<bool> youTube,
      Value<int> lengthMs,
      required int addedAt,
      Value<int> rowid,
    });
typedef $$AudioMantrasTableUpdateCompanionBuilder =
    AudioMantrasCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> source,
      Value<bool> youTube,
      Value<int> lengthMs,
      Value<int> addedAt,
      Value<int> rowid,
    });

class $$AudioMantrasTableFilterComposer
    extends Composer<_$VeronicaDatabase, $AudioMantrasTable> {
  $$AudioMantrasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get youTube => $composableBuilder(
    column: $table.youTube,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lengthMs => $composableBuilder(
    column: $table.lengthMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AudioMantrasTableOrderingComposer
    extends Composer<_$VeronicaDatabase, $AudioMantrasTable> {
  $$AudioMantrasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get youTube => $composableBuilder(
    column: $table.youTube,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lengthMs => $composableBuilder(
    column: $table.lengthMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AudioMantrasTableAnnotationComposer
    extends Composer<_$VeronicaDatabase, $AudioMantrasTable> {
  $$AudioMantrasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<bool> get youTube =>
      $composableBuilder(column: $table.youTube, builder: (column) => column);

  GeneratedColumn<int> get lengthMs =>
      $composableBuilder(column: $table.lengthMs, builder: (column) => column);

  GeneratedColumn<int> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);
}

class $$AudioMantrasTableTableManager
    extends
        RootTableManager<
          _$VeronicaDatabase,
          $AudioMantrasTable,
          AudioMantraRow,
          $$AudioMantrasTableFilterComposer,
          $$AudioMantrasTableOrderingComposer,
          $$AudioMantrasTableAnnotationComposer,
          $$AudioMantrasTableCreateCompanionBuilder,
          $$AudioMantrasTableUpdateCompanionBuilder,
          (
            AudioMantraRow,
            BaseReferences<
              _$VeronicaDatabase,
              $AudioMantrasTable,
              AudioMantraRow
            >,
          ),
          AudioMantraRow,
          PrefetchHooks Function()
        > {
  $$AudioMantrasTableTableManager(
    _$VeronicaDatabase db,
    $AudioMantrasTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AudioMantrasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AudioMantrasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AudioMantrasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<bool> youTube = const Value.absent(),
                Value<int> lengthMs = const Value.absent(),
                Value<int> addedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AudioMantrasCompanion(
                id: id,
                title: title,
                source: source,
                youTube: youTube,
                lengthMs: lengthMs,
                addedAt: addedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String source,
                Value<bool> youTube = const Value.absent(),
                Value<int> lengthMs = const Value.absent(),
                required int addedAt,
                Value<int> rowid = const Value.absent(),
              }) => AudioMantrasCompanion.insert(
                id: id,
                title: title,
                source: source,
                youTube: youTube,
                lengthMs: lengthMs,
                addedAt: addedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AudioMantrasTable, AudioMantraRow>(table),
                  BaseReferences<
                    _$VeronicaDatabase,
                    $AudioMantrasTable,
                    AudioMantraRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AudioMantrasTableProcessedTableManager =
    ProcessedTableManager<
      _$VeronicaDatabase,
      $AudioMantrasTable,
      AudioMantraRow,
      $$AudioMantrasTableFilterComposer,
      $$AudioMantrasTableOrderingComposer,
      $$AudioMantrasTableAnnotationComposer,
      $$AudioMantrasTableCreateCompanionBuilder,
      $$AudioMantrasTableUpdateCompanionBuilder,
      (
        AudioMantraRow,
        BaseReferences<_$VeronicaDatabase, $AudioMantrasTable, AudioMantraRow>,
      ),
      AudioMantraRow,
      PrefetchHooks Function()
    >;

class $VeronicaDatabaseManager {
  final _$VeronicaDatabase _db;
  $VeronicaDatabaseManager(this._db);
  $$WatchedAppsTableTableManager get watchedApps =>
      $$WatchedAppsTableTableManager(_db, _db.watchedApps);
  $$UsageDaysTableTableManager get usageDays =>
      $$UsageDaysTableTableManager(_db, _db.usageDays);
  $$OverrideLogsTableTableManager get overrideLogs =>
      $$OverrideLogsTableTableManager(_db, _db.overrideLogs);
  $$PrefsTableTableManager get prefs =>
      $$PrefsTableTableManager(_db, _db.prefs);
  $$TasksTableTableManager get tasks =>
      $$TasksTableTableManager(_db, _db.tasks);
  $$WaterLogsTableTableManager get waterLogs =>
      $$WaterLogsTableTableManager(_db, _db.waterLogs);
  $$MedicinesTableTableManager get medicines =>
      $$MedicinesTableTableManager(_db, _db.medicines);
  $$DosesTableTableManager get doses =>
      $$DosesTableTableManager(_db, _db.doses);
  $$ModesTableTableManager get modes =>
      $$ModesTableTableManager(_db, _db.modes);
  $$AlarmsTableTableManager get alarms =>
      $$AlarmsTableTableManager(_db, _db.alarms);
  $$SoundsTableTableManager get sounds =>
      $$SoundsTableTableManager(_db, _db.sounds);
  $$MantrasTableTableManager get mantras =>
      $$MantrasTableTableManager(_db, _db.mantras);
  $$AudioMantrasTableTableManager get audioMantras =>
      $$AudioMantrasTableTableManager(_db, _db.audioMantras);
}
