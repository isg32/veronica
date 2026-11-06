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

abstract class _$VeronicaDatabase extends GeneratedDatabase {
  _$VeronicaDatabase(QueryExecutor e) : super(e);
  $VeronicaDatabaseManager get managers => $VeronicaDatabaseManager(this);
  late final $WatchedAppsTable watchedApps = $WatchedAppsTable(this);
  late final $UsageDaysTable usageDays = $UsageDaysTable(this);
  late final $OverrideLogsTable overrideLogs = $OverrideLogsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    watchedApps,
    usageDays,
    overrideLogs,
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

class $VeronicaDatabaseManager {
  final _$VeronicaDatabase _db;
  $VeronicaDatabaseManager(this._db);
  $$WatchedAppsTableTableManager get watchedApps =>
      $$WatchedAppsTableTableManager(_db, _db.watchedApps);
  $$UsageDaysTableTableManager get usageDays =>
      $$UsageDaysTableTableManager(_db, _db.usageDays);
  $$OverrideLogsTableTableManager get overrideLogs =>
      $$OverrideLogsTableTableManager(_db, _db.overrideLogs);
}
