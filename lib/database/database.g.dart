// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $SessionsTable extends Sessions with TableInfo<$SessionsTable, Session> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _blocksCompletedMeta = const VerificationMeta(
    'blocksCompleted',
  );
  @override
  late final GeneratedColumn<int> blocksCompleted = GeneratedColumn<int>(
    'blocks_completed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalMinutesMeta = const VerificationMeta(
    'totalMinutes',
  );
  @override
  late final GeneratedColumn<int> totalMinutes = GeneratedColumn<int>(
    'total_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isCompleteMeta = const VerificationMeta(
    'isComplete',
  );
  @override
  late final GeneratedColumn<bool> isComplete = GeneratedColumn<bool>(
    'is_complete',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_complete" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    blocksCompleted,
    totalMinutes,
    isComplete,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Session> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('blocks_completed')) {
      context.handle(
        _blocksCompletedMeta,
        blocksCompleted.isAcceptableOrUnknown(
          data['blocks_completed']!,
          _blocksCompletedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_blocksCompletedMeta);
    }
    if (data.containsKey('total_minutes')) {
      context.handle(
        _totalMinutesMeta,
        totalMinutes.isAcceptableOrUnknown(
          data['total_minutes']!,
          _totalMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalMinutesMeta);
    }
    if (data.containsKey('is_complete')) {
      context.handle(
        _isCompleteMeta,
        isComplete.isAcceptableOrUnknown(data['is_complete']!, _isCompleteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Session map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Session(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      blocksCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}blocks_completed'],
      )!,
      totalMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_minutes'],
      )!,
      isComplete: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_complete'],
      )!,
    );
  }

  @override
  $SessionsTable createAlias(String alias) {
    return $SessionsTable(attachedDatabase, alias);
  }
}

class Session extends DataClass implements Insertable<Session> {
  final int id;
  final DateTime date;
  final int blocksCompleted;
  final int totalMinutes;
  final bool isComplete;
  const Session({
    required this.id,
    required this.date,
    required this.blocksCompleted,
    required this.totalMinutes,
    required this.isComplete,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['blocks_completed'] = Variable<int>(blocksCompleted);
    map['total_minutes'] = Variable<int>(totalMinutes);
    map['is_complete'] = Variable<bool>(isComplete);
    return map;
  }

  SessionsCompanion toCompanion(bool nullToAbsent) {
    return SessionsCompanion(
      id: Value(id),
      date: Value(date),
      blocksCompleted: Value(blocksCompleted),
      totalMinutes: Value(totalMinutes),
      isComplete: Value(isComplete),
    );
  }

  factory Session.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Session(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      blocksCompleted: serializer.fromJson<int>(json['blocksCompleted']),
      totalMinutes: serializer.fromJson<int>(json['totalMinutes']),
      isComplete: serializer.fromJson<bool>(json['isComplete']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'blocksCompleted': serializer.toJson<int>(blocksCompleted),
      'totalMinutes': serializer.toJson<int>(totalMinutes),
      'isComplete': serializer.toJson<bool>(isComplete),
    };
  }

  Session copyWith({
    int? id,
    DateTime? date,
    int? blocksCompleted,
    int? totalMinutes,
    bool? isComplete,
  }) => Session(
    id: id ?? this.id,
    date: date ?? this.date,
    blocksCompleted: blocksCompleted ?? this.blocksCompleted,
    totalMinutes: totalMinutes ?? this.totalMinutes,
    isComplete: isComplete ?? this.isComplete,
  );
  Session copyWithCompanion(SessionsCompanion data) {
    return Session(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      blocksCompleted: data.blocksCompleted.present
          ? data.blocksCompleted.value
          : this.blocksCompleted,
      totalMinutes: data.totalMinutes.present
          ? data.totalMinutes.value
          : this.totalMinutes,
      isComplete: data.isComplete.present
          ? data.isComplete.value
          : this.isComplete,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Session(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('blocksCompleted: $blocksCompleted, ')
          ..write('totalMinutes: $totalMinutes, ')
          ..write('isComplete: $isComplete')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, date, blocksCompleted, totalMinutes, isComplete);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Session &&
          other.id == this.id &&
          other.date == this.date &&
          other.blocksCompleted == this.blocksCompleted &&
          other.totalMinutes == this.totalMinutes &&
          other.isComplete == this.isComplete);
}

class SessionsCompanion extends UpdateCompanion<Session> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<int> blocksCompleted;
  final Value<int> totalMinutes;
  final Value<bool> isComplete;
  const SessionsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.blocksCompleted = const Value.absent(),
    this.totalMinutes = const Value.absent(),
    this.isComplete = const Value.absent(),
  });
  SessionsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required int blocksCompleted,
    required int totalMinutes,
    this.isComplete = const Value.absent(),
  }) : date = Value(date),
       blocksCompleted = Value(blocksCompleted),
       totalMinutes = Value(totalMinutes);
  static Insertable<Session> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<int>? blocksCompleted,
    Expression<int>? totalMinutes,
    Expression<bool>? isComplete,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (blocksCompleted != null) 'blocks_completed': blocksCompleted,
      if (totalMinutes != null) 'total_minutes': totalMinutes,
      if (isComplete != null) 'is_complete': isComplete,
    });
  }

  SessionsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<int>? blocksCompleted,
    Value<int>? totalMinutes,
    Value<bool>? isComplete,
  }) {
    return SessionsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      blocksCompleted: blocksCompleted ?? this.blocksCompleted,
      totalMinutes: totalMinutes ?? this.totalMinutes,
      isComplete: isComplete ?? this.isComplete,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (blocksCompleted.present) {
      map['blocks_completed'] = Variable<int>(blocksCompleted.value);
    }
    if (totalMinutes.present) {
      map['total_minutes'] = Variable<int>(totalMinutes.value);
    }
    if (isComplete.present) {
      map['is_complete'] = Variable<bool>(isComplete.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('blocksCompleted: $blocksCompleted, ')
          ..write('totalMinutes: $totalMinutes, ')
          ..write('isComplete: $isComplete')
          ..write(')'))
        .toString();
  }
}

class $DailyProgressTable extends DailyProgress
    with TableInfo<$DailyProgressTable, DailyProgressData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedMeta = const VerificationMeta(
    'completed',
  );
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
    'completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _minutesLoggedMeta = const VerificationMeta(
    'minutesLogged',
  );
  @override
  late final GeneratedColumn<int> minutesLogged = GeneratedColumn<int>(
    'minutes_logged',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [date, completed, minutesLogged];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_progress';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyProgressData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('completed')) {
      context.handle(
        _completedMeta,
        completed.isAcceptableOrUnknown(data['completed']!, _completedMeta),
      );
    }
    if (data.containsKey('minutes_logged')) {
      context.handle(
        _minutesLoggedMeta,
        minutesLogged.isAcceptableOrUnknown(
          data['minutes_logged']!,
          _minutesLoggedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {date};
  @override
  DailyProgressData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyProgressData(
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      completed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}completed'],
      )!,
      minutesLogged: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}minutes_logged'],
      )!,
    );
  }

  @override
  $DailyProgressTable createAlias(String alias) {
    return $DailyProgressTable(attachedDatabase, alias);
  }
}

class DailyProgressData extends DataClass
    implements Insertable<DailyProgressData> {
  final DateTime date;
  final bool completed;
  final int minutesLogged;
  const DailyProgressData({
    required this.date,
    required this.completed,
    required this.minutesLogged,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date'] = Variable<DateTime>(date);
    map['completed'] = Variable<bool>(completed);
    map['minutes_logged'] = Variable<int>(minutesLogged);
    return map;
  }

  DailyProgressCompanion toCompanion(bool nullToAbsent) {
    return DailyProgressCompanion(
      date: Value(date),
      completed: Value(completed),
      minutesLogged: Value(minutesLogged),
    );
  }

  factory DailyProgressData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyProgressData(
      date: serializer.fromJson<DateTime>(json['date']),
      completed: serializer.fromJson<bool>(json['completed']),
      minutesLogged: serializer.fromJson<int>(json['minutesLogged']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'date': serializer.toJson<DateTime>(date),
      'completed': serializer.toJson<bool>(completed),
      'minutesLogged': serializer.toJson<int>(minutesLogged),
    };
  }

  DailyProgressData copyWith({
    DateTime? date,
    bool? completed,
    int? minutesLogged,
  }) => DailyProgressData(
    date: date ?? this.date,
    completed: completed ?? this.completed,
    minutesLogged: minutesLogged ?? this.minutesLogged,
  );
  DailyProgressData copyWithCompanion(DailyProgressCompanion data) {
    return DailyProgressData(
      date: data.date.present ? data.date.value : this.date,
      completed: data.completed.present ? data.completed.value : this.completed,
      minutesLogged: data.minutesLogged.present
          ? data.minutesLogged.value
          : this.minutesLogged,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyProgressData(')
          ..write('date: $date, ')
          ..write('completed: $completed, ')
          ..write('minutesLogged: $minutesLogged')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(date, completed, minutesLogged);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyProgressData &&
          other.date == this.date &&
          other.completed == this.completed &&
          other.minutesLogged == this.minutesLogged);
}

class DailyProgressCompanion extends UpdateCompanion<DailyProgressData> {
  final Value<DateTime> date;
  final Value<bool> completed;
  final Value<int> minutesLogged;
  final Value<int> rowid;
  const DailyProgressCompanion({
    this.date = const Value.absent(),
    this.completed = const Value.absent(),
    this.minutesLogged = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailyProgressCompanion.insert({
    required DateTime date,
    this.completed = const Value.absent(),
    this.minutesLogged = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : date = Value(date);
  static Insertable<DailyProgressData> custom({
    Expression<DateTime>? date,
    Expression<bool>? completed,
    Expression<int>? minutesLogged,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (date != null) 'date': date,
      if (completed != null) 'completed': completed,
      if (minutesLogged != null) 'minutes_logged': minutesLogged,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailyProgressCompanion copyWith({
    Value<DateTime>? date,
    Value<bool>? completed,
    Value<int>? minutesLogged,
    Value<int>? rowid,
  }) {
    return DailyProgressCompanion(
      date: date ?? this.date,
      completed: completed ?? this.completed,
      minutesLogged: minutesLogged ?? this.minutesLogged,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (minutesLogged.present) {
      map['minutes_logged'] = Variable<int>(minutesLogged.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyProgressCompanion(')
          ..write('date: $date, ')
          ..write('completed: $completed, ')
          ..write('minutesLogged: $minutesLogged, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EveningLoadsTable extends EveningLoads
    with TableInfo<$EveningLoadsTable, EveningLoad> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EveningLoadsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scriptTextMeta = const VerificationMeta(
    'scriptText',
  );
  @override
  late final GeneratedColumn<String> scriptText = GeneratedColumn<String>(
    'script_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [date, scriptText, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'evening_loads';
  @override
  VerificationContext validateIntegrity(
    Insertable<EveningLoad> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('script_text')) {
      context.handle(
        _scriptTextMeta,
        scriptText.isAcceptableOrUnknown(data['script_text']!, _scriptTextMeta),
      );
    } else if (isInserting) {
      context.missing(_scriptTextMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {date};
  @override
  EveningLoad map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EveningLoad(
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      scriptText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}script_text'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $EveningLoadsTable createAlias(String alias) {
    return $EveningLoadsTable(attachedDatabase, alias);
  }
}

class EveningLoad extends DataClass implements Insertable<EveningLoad> {
  final DateTime date;
  final String scriptText;
  final DateTime createdAt;
  const EveningLoad({
    required this.date,
    required this.scriptText,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date'] = Variable<DateTime>(date);
    map['script_text'] = Variable<String>(scriptText);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  EveningLoadsCompanion toCompanion(bool nullToAbsent) {
    return EveningLoadsCompanion(
      date: Value(date),
      scriptText: Value(scriptText),
      createdAt: Value(createdAt),
    );
  }

  factory EveningLoad.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EveningLoad(
      date: serializer.fromJson<DateTime>(json['date']),
      scriptText: serializer.fromJson<String>(json['scriptText']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'date': serializer.toJson<DateTime>(date),
      'scriptText': serializer.toJson<String>(scriptText),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  EveningLoad copyWith({
    DateTime? date,
    String? scriptText,
    DateTime? createdAt,
  }) => EveningLoad(
    date: date ?? this.date,
    scriptText: scriptText ?? this.scriptText,
    createdAt: createdAt ?? this.createdAt,
  );
  EveningLoad copyWithCompanion(EveningLoadsCompanion data) {
    return EveningLoad(
      date: data.date.present ? data.date.value : this.date,
      scriptText: data.scriptText.present
          ? data.scriptText.value
          : this.scriptText,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EveningLoad(')
          ..write('date: $date, ')
          ..write('scriptText: $scriptText, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(date, scriptText, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EveningLoad &&
          other.date == this.date &&
          other.scriptText == this.scriptText &&
          other.createdAt == this.createdAt);
}

class EveningLoadsCompanion extends UpdateCompanion<EveningLoad> {
  final Value<DateTime> date;
  final Value<String> scriptText;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const EveningLoadsCompanion({
    this.date = const Value.absent(),
    this.scriptText = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EveningLoadsCompanion.insert({
    required DateTime date,
    required String scriptText,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : date = Value(date),
       scriptText = Value(scriptText);
  static Insertable<EveningLoad> custom({
    Expression<DateTime>? date,
    Expression<String>? scriptText,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (date != null) 'date': date,
      if (scriptText != null) 'script_text': scriptText,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EveningLoadsCompanion copyWith({
    Value<DateTime>? date,
    Value<String>? scriptText,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return EveningLoadsCompanion(
      date: date ?? this.date,
      scriptText: scriptText ?? this.scriptText,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (scriptText.present) {
      map['script_text'] = Variable<String>(scriptText.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EveningLoadsCompanion(')
          ..write('date: $date, ')
          ..write('scriptText: $scriptText, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SessionsTable sessions = $SessionsTable(this);
  late final $DailyProgressTable dailyProgress = $DailyProgressTable(this);
  late final $EveningLoadsTable eveningLoads = $EveningLoadsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    sessions,
    dailyProgress,
    eveningLoads,
  ];
}

typedef $$SessionsTableCreateCompanionBuilder =
    SessionsCompanion Function({
      Value<int> id,
      required DateTime date,
      required int blocksCompleted,
      required int totalMinutes,
      Value<bool> isComplete,
    });
typedef $$SessionsTableUpdateCompanionBuilder =
    SessionsCompanion Function({
      Value<int> id,
      Value<DateTime> date,
      Value<int> blocksCompleted,
      Value<int> totalMinutes,
      Value<bool> isComplete,
    });

class $$SessionsTableFilterComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableFilterComposer({
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

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get blocksCompleted => $composableBuilder(
    column: $table.blocksCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalMinutes => $composableBuilder(
    column: $table.totalMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isComplete => $composableBuilder(
    column: $table.isComplete,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get blocksCompleted => $composableBuilder(
    column: $table.blocksCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalMinutes => $composableBuilder(
    column: $table.totalMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isComplete => $composableBuilder(
    column: $table.isComplete,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get blocksCompleted => $composableBuilder(
    column: $table.blocksCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalMinutes => $composableBuilder(
    column: $table.totalMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isComplete => $composableBuilder(
    column: $table.isComplete,
    builder: (column) => column,
  );
}

class $$SessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SessionsTable,
          Session,
          $$SessionsTableFilterComposer,
          $$SessionsTableOrderingComposer,
          $$SessionsTableAnnotationComposer,
          $$SessionsTableCreateCompanionBuilder,
          $$SessionsTableUpdateCompanionBuilder,
          (Session, BaseReferences<_$AppDatabase, $SessionsTable, Session>),
          Session,
          PrefetchHooks Function()
        > {
  $$SessionsTableTableManager(_$AppDatabase db, $SessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int> blocksCompleted = const Value.absent(),
                Value<int> totalMinutes = const Value.absent(),
                Value<bool> isComplete = const Value.absent(),
              }) => SessionsCompanion(
                id: id,
                date: date,
                blocksCompleted: blocksCompleted,
                totalMinutes: totalMinutes,
                isComplete: isComplete,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime date,
                required int blocksCompleted,
                required int totalMinutes,
                Value<bool> isComplete = const Value.absent(),
              }) => SessionsCompanion.insert(
                id: id,
                date: date,
                blocksCompleted: blocksCompleted,
                totalMinutes: totalMinutes,
                isComplete: isComplete,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SessionsTable,
      Session,
      $$SessionsTableFilterComposer,
      $$SessionsTableOrderingComposer,
      $$SessionsTableAnnotationComposer,
      $$SessionsTableCreateCompanionBuilder,
      $$SessionsTableUpdateCompanionBuilder,
      (Session, BaseReferences<_$AppDatabase, $SessionsTable, Session>),
      Session,
      PrefetchHooks Function()
    >;
typedef $$DailyProgressTableCreateCompanionBuilder =
    DailyProgressCompanion Function({
      required DateTime date,
      Value<bool> completed,
      Value<int> minutesLogged,
      Value<int> rowid,
    });
typedef $$DailyProgressTableUpdateCompanionBuilder =
    DailyProgressCompanion Function({
      Value<DateTime> date,
      Value<bool> completed,
      Value<int> minutesLogged,
      Value<int> rowid,
    });

class $$DailyProgressTableFilterComposer
    extends Composer<_$AppDatabase, $DailyProgressTable> {
  $$DailyProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minutesLogged => $composableBuilder(
    column: $table.minutesLogged,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DailyProgressTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyProgressTable> {
  $$DailyProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minutesLogged => $composableBuilder(
    column: $table.minutesLogged,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailyProgressTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyProgressTable> {
  $$DailyProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  GeneratedColumn<int> get minutesLogged => $composableBuilder(
    column: $table.minutesLogged,
    builder: (column) => column,
  );
}

class $$DailyProgressTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyProgressTable,
          DailyProgressData,
          $$DailyProgressTableFilterComposer,
          $$DailyProgressTableOrderingComposer,
          $$DailyProgressTableAnnotationComposer,
          $$DailyProgressTableCreateCompanionBuilder,
          $$DailyProgressTableUpdateCompanionBuilder,
          (
            DailyProgressData,
            BaseReferences<
              _$AppDatabase,
              $DailyProgressTable,
              DailyProgressData
            >,
          ),
          DailyProgressData,
          PrefetchHooks Function()
        > {
  $$DailyProgressTableTableManager(_$AppDatabase db, $DailyProgressTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyProgressTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<DateTime> date = const Value.absent(),
                Value<bool> completed = const Value.absent(),
                Value<int> minutesLogged = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyProgressCompanion(
                date: date,
                completed: completed,
                minutesLogged: minutesLogged,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required DateTime date,
                Value<bool> completed = const Value.absent(),
                Value<int> minutesLogged = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyProgressCompanion.insert(
                date: date,
                completed: completed,
                minutesLogged: minutesLogged,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DailyProgressTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyProgressTable,
      DailyProgressData,
      $$DailyProgressTableFilterComposer,
      $$DailyProgressTableOrderingComposer,
      $$DailyProgressTableAnnotationComposer,
      $$DailyProgressTableCreateCompanionBuilder,
      $$DailyProgressTableUpdateCompanionBuilder,
      (
        DailyProgressData,
        BaseReferences<_$AppDatabase, $DailyProgressTable, DailyProgressData>,
      ),
      DailyProgressData,
      PrefetchHooks Function()
    >;
typedef $$EveningLoadsTableCreateCompanionBuilder =
    EveningLoadsCompanion Function({
      required DateTime date,
      required String scriptText,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$EveningLoadsTableUpdateCompanionBuilder =
    EveningLoadsCompanion Function({
      Value<DateTime> date,
      Value<String> scriptText,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$EveningLoadsTableFilterComposer
    extends Composer<_$AppDatabase, $EveningLoadsTable> {
  $$EveningLoadsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scriptText => $composableBuilder(
    column: $table.scriptText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EveningLoadsTableOrderingComposer
    extends Composer<_$AppDatabase, $EveningLoadsTable> {
  $$EveningLoadsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scriptText => $composableBuilder(
    column: $table.scriptText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EveningLoadsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EveningLoadsTable> {
  $$EveningLoadsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get scriptText => $composableBuilder(
    column: $table.scriptText,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$EveningLoadsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EveningLoadsTable,
          EveningLoad,
          $$EveningLoadsTableFilterComposer,
          $$EveningLoadsTableOrderingComposer,
          $$EveningLoadsTableAnnotationComposer,
          $$EveningLoadsTableCreateCompanionBuilder,
          $$EveningLoadsTableUpdateCompanionBuilder,
          (
            EveningLoad,
            BaseReferences<_$AppDatabase, $EveningLoadsTable, EveningLoad>,
          ),
          EveningLoad,
          PrefetchHooks Function()
        > {
  $$EveningLoadsTableTableManager(_$AppDatabase db, $EveningLoadsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EveningLoadsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EveningLoadsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EveningLoadsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<DateTime> date = const Value.absent(),
                Value<String> scriptText = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EveningLoadsCompanion(
                date: date,
                scriptText: scriptText,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required DateTime date,
                required String scriptText,
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EveningLoadsCompanion.insert(
                date: date,
                scriptText: scriptText,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EveningLoadsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EveningLoadsTable,
      EveningLoad,
      $$EveningLoadsTableFilterComposer,
      $$EveningLoadsTableOrderingComposer,
      $$EveningLoadsTableAnnotationComposer,
      $$EveningLoadsTableCreateCompanionBuilder,
      $$EveningLoadsTableUpdateCompanionBuilder,
      (
        EveningLoad,
        BaseReferences<_$AppDatabase, $EveningLoadsTable, EveningLoad>,
      ),
      EveningLoad,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SessionsTableTableManager get sessions =>
      $$SessionsTableTableManager(_db, _db.sessions);
  $$DailyProgressTableTableManager get dailyProgress =>
      $$DailyProgressTableTableManager(_db, _db.dailyProgress);
  $$EveningLoadsTableTableManager get eveningLoads =>
      $$EveningLoadsTableTableManager(_db, _db.eveningLoads);
}
