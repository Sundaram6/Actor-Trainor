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

class $SessionRecordsTable extends SessionRecords
    with TableInfo<$SessionRecordsTable, SessionRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionRecordsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
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
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _blocksJsonMeta = const VerificationMeta(
    'blocksJson',
  );
  @override
  late final GeneratedColumn<String> blocksJson = GeneratedColumn<String>(
    'blocks_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _intentionMeta = const VerificationMeta(
    'intention',
  );
  @override
  late final GeneratedColumn<String> intention = GeneratedColumn<String>(
    'intention',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _qualityRatingMeta = const VerificationMeta(
    'qualityRating',
  );
  @override
  late final GeneratedColumn<int> qualityRating = GeneratedColumn<int>(
    'quality_rating',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    completedAt,
    blocksCompleted,
    totalMinutes,
    notes,
    blocksJson,
    intention,
    qualityRating,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'session_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<SessionRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_completedAtMeta);
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
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('blocks_json')) {
      context.handle(
        _blocksJsonMeta,
        blocksJson.isAcceptableOrUnknown(data['blocks_json']!, _blocksJsonMeta),
      );
    }
    if (data.containsKey('intention')) {
      context.handle(
        _intentionMeta,
        intention.isAcceptableOrUnknown(data['intention']!, _intentionMeta),
      );
    }
    if (data.containsKey('quality_rating')) {
      context.handle(
        _qualityRatingMeta,
        qualityRating.isAcceptableOrUnknown(
          data['quality_rating']!,
          _qualityRatingMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SessionRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SessionRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      )!,
      blocksCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}blocks_completed'],
      )!,
      totalMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_minutes'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      blocksJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}blocks_json'],
      )!,
      intention: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}intention'],
      ),
      qualityRating: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quality_rating'],
      ),
    );
  }

  @override
  $SessionRecordsTable createAlias(String alias) {
    return $SessionRecordsTable(attachedDatabase, alias);
  }
}

class SessionRecord extends DataClass implements Insertable<SessionRecord> {
  final int id;
  final DateTime completedAt;
  final int blocksCompleted;
  final int totalMinutes;
  final String? notes;
  final String blocksJson;
  final String? intention;
  final int? qualityRating;
  const SessionRecord({
    required this.id,
    required this.completedAt,
    required this.blocksCompleted,
    required this.totalMinutes,
    this.notes,
    required this.blocksJson,
    this.intention,
    this.qualityRating,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['completed_at'] = Variable<DateTime>(completedAt);
    map['blocks_completed'] = Variable<int>(blocksCompleted);
    map['total_minutes'] = Variable<int>(totalMinutes);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['blocks_json'] = Variable<String>(blocksJson);
    if (!nullToAbsent || intention != null) {
      map['intention'] = Variable<String>(intention);
    }
    if (!nullToAbsent || qualityRating != null) {
      map['quality_rating'] = Variable<int>(qualityRating);
    }
    return map;
  }

  SessionRecordsCompanion toCompanion(bool nullToAbsent) {
    return SessionRecordsCompanion(
      id: Value(id),
      completedAt: Value(completedAt),
      blocksCompleted: Value(blocksCompleted),
      totalMinutes: Value(totalMinutes),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      blocksJson: Value(blocksJson),
      intention: intention == null && nullToAbsent
          ? const Value.absent()
          : Value(intention),
      qualityRating: qualityRating == null && nullToAbsent
          ? const Value.absent()
          : Value(qualityRating),
    );
  }

  factory SessionRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SessionRecord(
      id: serializer.fromJson<int>(json['id']),
      completedAt: serializer.fromJson<DateTime>(json['completedAt']),
      blocksCompleted: serializer.fromJson<int>(json['blocksCompleted']),
      totalMinutes: serializer.fromJson<int>(json['totalMinutes']),
      notes: serializer.fromJson<String?>(json['notes']),
      blocksJson: serializer.fromJson<String>(json['blocksJson']),
      intention: serializer.fromJson<String?>(json['intention']),
      qualityRating: serializer.fromJson<int?>(json['qualityRating']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'completedAt': serializer.toJson<DateTime>(completedAt),
      'blocksCompleted': serializer.toJson<int>(blocksCompleted),
      'totalMinutes': serializer.toJson<int>(totalMinutes),
      'notes': serializer.toJson<String?>(notes),
      'blocksJson': serializer.toJson<String>(blocksJson),
      'intention': serializer.toJson<String?>(intention),
      'qualityRating': serializer.toJson<int?>(qualityRating),
    };
  }

  SessionRecord copyWith({
    int? id,
    DateTime? completedAt,
    int? blocksCompleted,
    int? totalMinutes,
    Value<String?> notes = const Value.absent(),
    String? blocksJson,
    Value<String?> intention = const Value.absent(),
    Value<int?> qualityRating = const Value.absent(),
  }) => SessionRecord(
    id: id ?? this.id,
    completedAt: completedAt ?? this.completedAt,
    blocksCompleted: blocksCompleted ?? this.blocksCompleted,
    totalMinutes: totalMinutes ?? this.totalMinutes,
    notes: notes.present ? notes.value : this.notes,
    blocksJson: blocksJson ?? this.blocksJson,
    intention: intention.present ? intention.value : this.intention,
    qualityRating: qualityRating.present
        ? qualityRating.value
        : this.qualityRating,
  );
  SessionRecord copyWithCompanion(SessionRecordsCompanion data) {
    return SessionRecord(
      id: data.id.present ? data.id.value : this.id,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      blocksCompleted: data.blocksCompleted.present
          ? data.blocksCompleted.value
          : this.blocksCompleted,
      totalMinutes: data.totalMinutes.present
          ? data.totalMinutes.value
          : this.totalMinutes,
      notes: data.notes.present ? data.notes.value : this.notes,
      blocksJson: data.blocksJson.present
          ? data.blocksJson.value
          : this.blocksJson,
      intention: data.intention.present ? data.intention.value : this.intention,
      qualityRating: data.qualityRating.present
          ? data.qualityRating.value
          : this.qualityRating,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SessionRecord(')
          ..write('id: $id, ')
          ..write('completedAt: $completedAt, ')
          ..write('blocksCompleted: $blocksCompleted, ')
          ..write('totalMinutes: $totalMinutes, ')
          ..write('notes: $notes, ')
          ..write('blocksJson: $blocksJson, ')
          ..write('intention: $intention, ')
          ..write('qualityRating: $qualityRating')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    completedAt,
    blocksCompleted,
    totalMinutes,
    notes,
    blocksJson,
    intention,
    qualityRating,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SessionRecord &&
          other.id == this.id &&
          other.completedAt == this.completedAt &&
          other.blocksCompleted == this.blocksCompleted &&
          other.totalMinutes == this.totalMinutes &&
          other.notes == this.notes &&
          other.blocksJson == this.blocksJson &&
          other.intention == this.intention &&
          other.qualityRating == this.qualityRating);
}

class SessionRecordsCompanion extends UpdateCompanion<SessionRecord> {
  final Value<int> id;
  final Value<DateTime> completedAt;
  final Value<int> blocksCompleted;
  final Value<int> totalMinutes;
  final Value<String?> notes;
  final Value<String> blocksJson;
  final Value<String?> intention;
  final Value<int?> qualityRating;
  const SessionRecordsCompanion({
    this.id = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.blocksCompleted = const Value.absent(),
    this.totalMinutes = const Value.absent(),
    this.notes = const Value.absent(),
    this.blocksJson = const Value.absent(),
    this.intention = const Value.absent(),
    this.qualityRating = const Value.absent(),
  });
  SessionRecordsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime completedAt,
    required int blocksCompleted,
    required int totalMinutes,
    this.notes = const Value.absent(),
    this.blocksJson = const Value.absent(),
    this.intention = const Value.absent(),
    this.qualityRating = const Value.absent(),
  }) : completedAt = Value(completedAt),
       blocksCompleted = Value(blocksCompleted),
       totalMinutes = Value(totalMinutes);
  static Insertable<SessionRecord> custom({
    Expression<int>? id,
    Expression<DateTime>? completedAt,
    Expression<int>? blocksCompleted,
    Expression<int>? totalMinutes,
    Expression<String>? notes,
    Expression<String>? blocksJson,
    Expression<String>? intention,
    Expression<int>? qualityRating,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (completedAt != null) 'completed_at': completedAt,
      if (blocksCompleted != null) 'blocks_completed': blocksCompleted,
      if (totalMinutes != null) 'total_minutes': totalMinutes,
      if (notes != null) 'notes': notes,
      if (blocksJson != null) 'blocks_json': blocksJson,
      if (intention != null) 'intention': intention,
      if (qualityRating != null) 'quality_rating': qualityRating,
    });
  }

  SessionRecordsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? completedAt,
    Value<int>? blocksCompleted,
    Value<int>? totalMinutes,
    Value<String?>? notes,
    Value<String>? blocksJson,
    Value<String?>? intention,
    Value<int?>? qualityRating,
  }) {
    return SessionRecordsCompanion(
      id: id ?? this.id,
      completedAt: completedAt ?? this.completedAt,
      blocksCompleted: blocksCompleted ?? this.blocksCompleted,
      totalMinutes: totalMinutes ?? this.totalMinutes,
      notes: notes ?? this.notes,
      blocksJson: blocksJson ?? this.blocksJson,
      intention: intention ?? this.intention,
      qualityRating: qualityRating ?? this.qualityRating,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (blocksCompleted.present) {
      map['blocks_completed'] = Variable<int>(blocksCompleted.value);
    }
    if (totalMinutes.present) {
      map['total_minutes'] = Variable<int>(totalMinutes.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (blocksJson.present) {
      map['blocks_json'] = Variable<String>(blocksJson.value);
    }
    if (intention.present) {
      map['intention'] = Variable<String>(intention.value);
    }
    if (qualityRating.present) {
      map['quality_rating'] = Variable<int>(qualityRating.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionRecordsCompanion(')
          ..write('id: $id, ')
          ..write('completedAt: $completedAt, ')
          ..write('blocksCompleted: $blocksCompleted, ')
          ..write('totalMinutes: $totalMinutes, ')
          ..write('notes: $notes, ')
          ..write('blocksJson: $blocksJson, ')
          ..write('intention: $intention, ')
          ..write('qualityRating: $qualityRating')
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
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
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
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    title,
    content,
    isActive,
  ];
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
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EveningLoad map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EveningLoad(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $EveningLoadsTable createAlias(String alias) {
    return $EveningLoadsTable(attachedDatabase, alias);
  }
}

class EveningLoad extends DataClass implements Insertable<EveningLoad> {
  final int id;
  final DateTime createdAt;
  final String title;
  final String content;
  final bool isActive;
  const EveningLoad({
    required this.id,
    required this.createdAt,
    required this.title,
    required this.content,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['title'] = Variable<String>(title);
    map['content'] = Variable<String>(content);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  EveningLoadsCompanion toCompanion(bool nullToAbsent) {
    return EveningLoadsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      title: Value(title),
      content: Value(content),
      isActive: Value(isActive),
    );
  }

  factory EveningLoad.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EveningLoad(
      id: serializer.fromJson<int>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      title: serializer.fromJson<String>(json['title']),
      content: serializer.fromJson<String>(json['content']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'title': serializer.toJson<String>(title),
      'content': serializer.toJson<String>(content),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  EveningLoad copyWith({
    int? id,
    DateTime? createdAt,
    String? title,
    String? content,
    bool? isActive,
  }) => EveningLoad(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    title: title ?? this.title,
    content: content ?? this.content,
    isActive: isActive ?? this.isActive,
  );
  EveningLoad copyWithCompanion(EveningLoadsCompanion data) {
    return EveningLoad(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      title: data.title.present ? data.title.value : this.title,
      content: data.content.present ? data.content.value : this.content,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EveningLoad(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, createdAt, title, content, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EveningLoad &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.title == this.title &&
          other.content == this.content &&
          other.isActive == this.isActive);
}

class EveningLoadsCompanion extends UpdateCompanion<EveningLoad> {
  final Value<int> id;
  final Value<DateTime> createdAt;
  final Value<String> title;
  final Value<String> content;
  final Value<bool> isActive;
  const EveningLoadsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  EveningLoadsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime createdAt,
    required String title,
    required String content,
    this.isActive = const Value.absent(),
  }) : createdAt = Value(createdAt),
       title = Value(title),
       content = Value(content);
  static Insertable<EveningLoad> custom({
    Expression<int>? id,
    Expression<DateTime>? createdAt,
    Expression<String>? title,
    Expression<String>? content,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (isActive != null) 'is_active': isActive,
    });
  }

  EveningLoadsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? createdAt,
    Value<String>? title,
    Value<String>? content,
    Value<bool>? isActive,
  }) {
    return EveningLoadsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      title: title ?? this.title,
      content: content ?? this.content,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EveningLoadsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $SessionNotesTable extends SessionNotes
    with TableInfo<$SessionNotesTable, SessionNote> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionNotesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<int> sessionId = GeneratedColumn<int>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
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
  List<GeneratedColumn> get $columns => [id, sessionId, note, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'session_notes';
  @override
  VerificationContext validateIntegrity(
    Insertable<SessionNote> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    } else if (isInserting) {
      context.missing(_noteMeta);
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
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SessionNote map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SessionNote(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}session_id'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SessionNotesTable createAlias(String alias) {
    return $SessionNotesTable(attachedDatabase, alias);
  }
}

class SessionNote extends DataClass implements Insertable<SessionNote> {
  final int id;
  final int sessionId;
  final String note;
  final DateTime createdAt;
  const SessionNote({
    required this.id,
    required this.sessionId,
    required this.note,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_id'] = Variable<int>(sessionId);
    map['note'] = Variable<String>(note);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SessionNotesCompanion toCompanion(bool nullToAbsent) {
    return SessionNotesCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      note: Value(note),
      createdAt: Value(createdAt),
    );
  }

  factory SessionNote.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SessionNote(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<int>(json['sessionId']),
      note: serializer.fromJson<String>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<int>(sessionId),
      'note': serializer.toJson<String>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SessionNote copyWith({
    int? id,
    int? sessionId,
    String? note,
    DateTime? createdAt,
  }) => SessionNote(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    note: note ?? this.note,
    createdAt: createdAt ?? this.createdAt,
  );
  SessionNote copyWithCompanion(SessionNotesCompanion data) {
    return SessionNote(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SessionNote(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, sessionId, note, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SessionNote &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.note == this.note &&
          other.createdAt == this.createdAt);
}

class SessionNotesCompanion extends UpdateCompanion<SessionNote> {
  final Value<int> id;
  final Value<int> sessionId;
  final Value<String> note;
  final Value<DateTime> createdAt;
  const SessionNotesCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SessionNotesCompanion.insert({
    this.id = const Value.absent(),
    required int sessionId,
    required String note,
    this.createdAt = const Value.absent(),
  }) : sessionId = Value(sessionId),
       note = Value(note);
  static Insertable<SessionNote> custom({
    Expression<int>? id,
    Expression<int>? sessionId,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SessionNotesCompanion copyWith({
    Value<int>? id,
    Value<int>? sessionId,
    Value<String>? note,
    Value<DateTime>? createdAt,
  }) {
    return SessionNotesCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<int>(sessionId.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionNotesCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SessionCheckInsTable extends SessionCheckIns
    with TableInfo<$SessionCheckInsTable, SessionCheckIn> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionCheckInsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<int> sessionId = GeneratedColumn<int>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _energyLevelMeta = const VerificationMeta(
    'energyLevel',
  );
  @override
  late final GeneratedColumn<int> energyLevel = GeneratedColumn<int>(
    'energy_level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _focusLevelMeta = const VerificationMeta(
    'focusLevel',
  );
  @override
  late final GeneratedColumn<int> focusLevel = GeneratedColumn<int>(
    'focus_level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _physicalReadinessMeta = const VerificationMeta(
    'physicalReadiness',
  );
  @override
  late final GeneratedColumn<int> physicalReadiness = GeneratedColumn<int>(
    'physical_readiness',
    aliasedName,
    false,
    type: DriftSqlType.int,
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
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    energyLevel,
    focusLevel,
    physicalReadiness,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'session_check_ins';
  @override
  VerificationContext validateIntegrity(
    Insertable<SessionCheckIn> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('energy_level')) {
      context.handle(
        _energyLevelMeta,
        energyLevel.isAcceptableOrUnknown(
          data['energy_level']!,
          _energyLevelMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_energyLevelMeta);
    }
    if (data.containsKey('focus_level')) {
      context.handle(
        _focusLevelMeta,
        focusLevel.isAcceptableOrUnknown(data['focus_level']!, _focusLevelMeta),
      );
    } else if (isInserting) {
      context.missing(_focusLevelMeta);
    }
    if (data.containsKey('physical_readiness')) {
      context.handle(
        _physicalReadinessMeta,
        physicalReadiness.isAcceptableOrUnknown(
          data['physical_readiness']!,
          _physicalReadinessMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_physicalReadinessMeta);
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
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SessionCheckIn map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SessionCheckIn(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}session_id'],
      )!,
      energyLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}energy_level'],
      )!,
      focusLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}focus_level'],
      )!,
      physicalReadiness: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}physical_readiness'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SessionCheckInsTable createAlias(String alias) {
    return $SessionCheckInsTable(attachedDatabase, alias);
  }
}

class SessionCheckIn extends DataClass implements Insertable<SessionCheckIn> {
  final int id;
  final int sessionId;
  final int energyLevel;
  final int focusLevel;
  final int physicalReadiness;
  final DateTime createdAt;
  const SessionCheckIn({
    required this.id,
    required this.sessionId,
    required this.energyLevel,
    required this.focusLevel,
    required this.physicalReadiness,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_id'] = Variable<int>(sessionId);
    map['energy_level'] = Variable<int>(energyLevel);
    map['focus_level'] = Variable<int>(focusLevel);
    map['physical_readiness'] = Variable<int>(physicalReadiness);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SessionCheckInsCompanion toCompanion(bool nullToAbsent) {
    return SessionCheckInsCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      energyLevel: Value(energyLevel),
      focusLevel: Value(focusLevel),
      physicalReadiness: Value(physicalReadiness),
      createdAt: Value(createdAt),
    );
  }

  factory SessionCheckIn.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SessionCheckIn(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<int>(json['sessionId']),
      energyLevel: serializer.fromJson<int>(json['energyLevel']),
      focusLevel: serializer.fromJson<int>(json['focusLevel']),
      physicalReadiness: serializer.fromJson<int>(json['physicalReadiness']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<int>(sessionId),
      'energyLevel': serializer.toJson<int>(energyLevel),
      'focusLevel': serializer.toJson<int>(focusLevel),
      'physicalReadiness': serializer.toJson<int>(physicalReadiness),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SessionCheckIn copyWith({
    int? id,
    int? sessionId,
    int? energyLevel,
    int? focusLevel,
    int? physicalReadiness,
    DateTime? createdAt,
  }) => SessionCheckIn(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    energyLevel: energyLevel ?? this.energyLevel,
    focusLevel: focusLevel ?? this.focusLevel,
    physicalReadiness: physicalReadiness ?? this.physicalReadiness,
    createdAt: createdAt ?? this.createdAt,
  );
  SessionCheckIn copyWithCompanion(SessionCheckInsCompanion data) {
    return SessionCheckIn(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      energyLevel: data.energyLevel.present
          ? data.energyLevel.value
          : this.energyLevel,
      focusLevel: data.focusLevel.present
          ? data.focusLevel.value
          : this.focusLevel,
      physicalReadiness: data.physicalReadiness.present
          ? data.physicalReadiness.value
          : this.physicalReadiness,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SessionCheckIn(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('energyLevel: $energyLevel, ')
          ..write('focusLevel: $focusLevel, ')
          ..write('physicalReadiness: $physicalReadiness, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sessionId,
    energyLevel,
    focusLevel,
    physicalReadiness,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SessionCheckIn &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.energyLevel == this.energyLevel &&
          other.focusLevel == this.focusLevel &&
          other.physicalReadiness == this.physicalReadiness &&
          other.createdAt == this.createdAt);
}

class SessionCheckInsCompanion extends UpdateCompanion<SessionCheckIn> {
  final Value<int> id;
  final Value<int> sessionId;
  final Value<int> energyLevel;
  final Value<int> focusLevel;
  final Value<int> physicalReadiness;
  final Value<DateTime> createdAt;
  const SessionCheckInsCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.energyLevel = const Value.absent(),
    this.focusLevel = const Value.absent(),
    this.physicalReadiness = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SessionCheckInsCompanion.insert({
    this.id = const Value.absent(),
    required int sessionId,
    required int energyLevel,
    required int focusLevel,
    required int physicalReadiness,
    this.createdAt = const Value.absent(),
  }) : sessionId = Value(sessionId),
       energyLevel = Value(energyLevel),
       focusLevel = Value(focusLevel),
       physicalReadiness = Value(physicalReadiness);
  static Insertable<SessionCheckIn> custom({
    Expression<int>? id,
    Expression<int>? sessionId,
    Expression<int>? energyLevel,
    Expression<int>? focusLevel,
    Expression<int>? physicalReadiness,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (energyLevel != null) 'energy_level': energyLevel,
      if (focusLevel != null) 'focus_level': focusLevel,
      if (physicalReadiness != null) 'physical_readiness': physicalReadiness,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SessionCheckInsCompanion copyWith({
    Value<int>? id,
    Value<int>? sessionId,
    Value<int>? energyLevel,
    Value<int>? focusLevel,
    Value<int>? physicalReadiness,
    Value<DateTime>? createdAt,
  }) {
    return SessionCheckInsCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      energyLevel: energyLevel ?? this.energyLevel,
      focusLevel: focusLevel ?? this.focusLevel,
      physicalReadiness: physicalReadiness ?? this.physicalReadiness,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<int>(sessionId.value);
    }
    if (energyLevel.present) {
      map['energy_level'] = Variable<int>(energyLevel.value);
    }
    if (focusLevel.present) {
      map['focus_level'] = Variable<int>(focusLevel.value);
    }
    if (physicalReadiness.present) {
      map['physical_readiness'] = Variable<int>(physicalReadiness.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionCheckInsCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('energyLevel: $energyLevel, ')
          ..write('focusLevel: $focusLevel, ')
          ..write('physicalReadiness: $physicalReadiness, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $BlockNotesTable extends BlockNotes
    with TableInfo<$BlockNotesTable, BlockNote> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BlockNotesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<int> sessionId = GeneratedColumn<int>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _blockIndexMeta = const VerificationMeta(
    'blockIndex',
  );
  @override
  late final GeneratedColumn<int> blockIndex = GeneratedColumn<int>(
    'block_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
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
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    blockIndex,
    note,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'block_notes';
  @override
  VerificationContext validateIntegrity(
    Insertable<BlockNote> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('block_index')) {
      context.handle(
        _blockIndexMeta,
        blockIndex.isAcceptableOrUnknown(data['block_index']!, _blockIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_blockIndexMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    } else if (isInserting) {
      context.missing(_noteMeta);
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
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BlockNote map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BlockNote(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}session_id'],
      )!,
      blockIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}block_index'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $BlockNotesTable createAlias(String alias) {
    return $BlockNotesTable(attachedDatabase, alias);
  }
}

class BlockNote extends DataClass implements Insertable<BlockNote> {
  final int id;
  final int sessionId;
  final int blockIndex;
  final String note;
  final DateTime createdAt;
  const BlockNote({
    required this.id,
    required this.sessionId,
    required this.blockIndex,
    required this.note,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_id'] = Variable<int>(sessionId);
    map['block_index'] = Variable<int>(blockIndex);
    map['note'] = Variable<String>(note);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BlockNotesCompanion toCompanion(bool nullToAbsent) {
    return BlockNotesCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      blockIndex: Value(blockIndex),
      note: Value(note),
      createdAt: Value(createdAt),
    );
  }

  factory BlockNote.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BlockNote(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<int>(json['sessionId']),
      blockIndex: serializer.fromJson<int>(json['blockIndex']),
      note: serializer.fromJson<String>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<int>(sessionId),
      'blockIndex': serializer.toJson<int>(blockIndex),
      'note': serializer.toJson<String>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  BlockNote copyWith({
    int? id,
    int? sessionId,
    int? blockIndex,
    String? note,
    DateTime? createdAt,
  }) => BlockNote(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    blockIndex: blockIndex ?? this.blockIndex,
    note: note ?? this.note,
    createdAt: createdAt ?? this.createdAt,
  );
  BlockNote copyWithCompanion(BlockNotesCompanion data) {
    return BlockNote(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      blockIndex: data.blockIndex.present
          ? data.blockIndex.value
          : this.blockIndex,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BlockNote(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('blockIndex: $blockIndex, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, sessionId, blockIndex, note, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BlockNote &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.blockIndex == this.blockIndex &&
          other.note == this.note &&
          other.createdAt == this.createdAt);
}

class BlockNotesCompanion extends UpdateCompanion<BlockNote> {
  final Value<int> id;
  final Value<int> sessionId;
  final Value<int> blockIndex;
  final Value<String> note;
  final Value<DateTime> createdAt;
  const BlockNotesCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.blockIndex = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  BlockNotesCompanion.insert({
    this.id = const Value.absent(),
    required int sessionId,
    required int blockIndex,
    required String note,
    this.createdAt = const Value.absent(),
  }) : sessionId = Value(sessionId),
       blockIndex = Value(blockIndex),
       note = Value(note);
  static Insertable<BlockNote> custom({
    Expression<int>? id,
    Expression<int>? sessionId,
    Expression<int>? blockIndex,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (blockIndex != null) 'block_index': blockIndex,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  BlockNotesCompanion copyWith({
    Value<int>? id,
    Value<int>? sessionId,
    Value<int>? blockIndex,
    Value<String>? note,
    Value<DateTime>? createdAt,
  }) {
    return BlockNotesCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      blockIndex: blockIndex ?? this.blockIndex,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<int>(sessionId.value);
    }
    if (blockIndex.present) {
      map['block_index'] = Variable<int>(blockIndex.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BlockNotesCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('blockIndex: $blockIndex, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SessionsTable sessions = $SessionsTable(this);
  late final $SessionRecordsTable sessionRecords = $SessionRecordsTable(this);
  late final $DailyProgressTable dailyProgress = $DailyProgressTable(this);
  late final $EveningLoadsTable eveningLoads = $EveningLoadsTable(this);
  late final $SessionNotesTable sessionNotes = $SessionNotesTable(this);
  late final $SessionCheckInsTable sessionCheckIns = $SessionCheckInsTable(
    this,
  );
  late final $BlockNotesTable blockNotes = $BlockNotesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    sessions,
    sessionRecords,
    dailyProgress,
    eveningLoads,
    sessionNotes,
    sessionCheckIns,
    blockNotes,
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
typedef $$SessionRecordsTableCreateCompanionBuilder =
    SessionRecordsCompanion Function({
      Value<int> id,
      required DateTime completedAt,
      required int blocksCompleted,
      required int totalMinutes,
      Value<String?> notes,
      Value<String> blocksJson,
      Value<String?> intention,
      Value<int?> qualityRating,
    });
typedef $$SessionRecordsTableUpdateCompanionBuilder =
    SessionRecordsCompanion Function({
      Value<int> id,
      Value<DateTime> completedAt,
      Value<int> blocksCompleted,
      Value<int> totalMinutes,
      Value<String?> notes,
      Value<String> blocksJson,
      Value<String?> intention,
      Value<int?> qualityRating,
    });

class $$SessionRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $SessionRecordsTable> {
  $$SessionRecordsTableFilterComposer({
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

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
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

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get blocksJson => $composableBuilder(
    column: $table.blocksJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get intention => $composableBuilder(
    column: $table.intention,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get qualityRating => $composableBuilder(
    column: $table.qualityRating,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SessionRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionRecordsTable> {
  $$SessionRecordsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
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

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get blocksJson => $composableBuilder(
    column: $table.blocksJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get intention => $composableBuilder(
    column: $table.intention,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get qualityRating => $composableBuilder(
    column: $table.qualityRating,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SessionRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionRecordsTable> {
  $$SessionRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get blocksCompleted => $composableBuilder(
    column: $table.blocksCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalMinutes => $composableBuilder(
    column: $table.totalMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get blocksJson => $composableBuilder(
    column: $table.blocksJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get intention =>
      $composableBuilder(column: $table.intention, builder: (column) => column);

  GeneratedColumn<int> get qualityRating => $composableBuilder(
    column: $table.qualityRating,
    builder: (column) => column,
  );
}

class $$SessionRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SessionRecordsTable,
          SessionRecord,
          $$SessionRecordsTableFilterComposer,
          $$SessionRecordsTableOrderingComposer,
          $$SessionRecordsTableAnnotationComposer,
          $$SessionRecordsTableCreateCompanionBuilder,
          $$SessionRecordsTableUpdateCompanionBuilder,
          (
            SessionRecord,
            BaseReferences<_$AppDatabase, $SessionRecordsTable, SessionRecord>,
          ),
          SessionRecord,
          PrefetchHooks Function()
        > {
  $$SessionRecordsTableTableManager(
    _$AppDatabase db,
    $SessionRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> completedAt = const Value.absent(),
                Value<int> blocksCompleted = const Value.absent(),
                Value<int> totalMinutes = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> blocksJson = const Value.absent(),
                Value<String?> intention = const Value.absent(),
                Value<int?> qualityRating = const Value.absent(),
              }) => SessionRecordsCompanion(
                id: id,
                completedAt: completedAt,
                blocksCompleted: blocksCompleted,
                totalMinutes: totalMinutes,
                notes: notes,
                blocksJson: blocksJson,
                intention: intention,
                qualityRating: qualityRating,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime completedAt,
                required int blocksCompleted,
                required int totalMinutes,
                Value<String?> notes = const Value.absent(),
                Value<String> blocksJson = const Value.absent(),
                Value<String?> intention = const Value.absent(),
                Value<int?> qualityRating = const Value.absent(),
              }) => SessionRecordsCompanion.insert(
                id: id,
                completedAt: completedAt,
                blocksCompleted: blocksCompleted,
                totalMinutes: totalMinutes,
                notes: notes,
                blocksJson: blocksJson,
                intention: intention,
                qualityRating: qualityRating,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SessionRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SessionRecordsTable,
      SessionRecord,
      $$SessionRecordsTableFilterComposer,
      $$SessionRecordsTableOrderingComposer,
      $$SessionRecordsTableAnnotationComposer,
      $$SessionRecordsTableCreateCompanionBuilder,
      $$SessionRecordsTableUpdateCompanionBuilder,
      (
        SessionRecord,
        BaseReferences<_$AppDatabase, $SessionRecordsTable, SessionRecord>,
      ),
      SessionRecord,
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
      Value<int> id,
      required DateTime createdAt,
      required String title,
      required String content,
      Value<bool> isActive,
    });
typedef $$EveningLoadsTableUpdateCompanionBuilder =
    EveningLoadsCompanion Function({
      Value<int> id,
      Value<DateTime> createdAt,
      Value<String> title,
      Value<String> content,
      Value<bool> isActive,
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
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
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
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
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
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);
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
                Value<int> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => EveningLoadsCompanion(
                id: id,
                createdAt: createdAt,
                title: title,
                content: content,
                isActive: isActive,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime createdAt,
                required String title,
                required String content,
                Value<bool> isActive = const Value.absent(),
              }) => EveningLoadsCompanion.insert(
                id: id,
                createdAt: createdAt,
                title: title,
                content: content,
                isActive: isActive,
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
typedef $$SessionNotesTableCreateCompanionBuilder =
    SessionNotesCompanion Function({
      Value<int> id,
      required int sessionId,
      required String note,
      Value<DateTime> createdAt,
    });
typedef $$SessionNotesTableUpdateCompanionBuilder =
    SessionNotesCompanion Function({
      Value<int> id,
      Value<int> sessionId,
      Value<String> note,
      Value<DateTime> createdAt,
    });

class $$SessionNotesTableFilterComposer
    extends Composer<_$AppDatabase, $SessionNotesTable> {
  $$SessionNotesTableFilterComposer({
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

  ColumnFilters<int> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SessionNotesTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionNotesTable> {
  $$SessionNotesTableOrderingComposer({
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

  ColumnOrderings<int> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SessionNotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionNotesTable> {
  $$SessionNotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SessionNotesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SessionNotesTable,
          SessionNote,
          $$SessionNotesTableFilterComposer,
          $$SessionNotesTableOrderingComposer,
          $$SessionNotesTableAnnotationComposer,
          $$SessionNotesTableCreateCompanionBuilder,
          $$SessionNotesTableUpdateCompanionBuilder,
          (
            SessionNote,
            BaseReferences<_$AppDatabase, $SessionNotesTable, SessionNote>,
          ),
          SessionNote,
          PrefetchHooks Function()
        > {
  $$SessionNotesTableTableManager(_$AppDatabase db, $SessionNotesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionNotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionNotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionNotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> sessionId = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SessionNotesCompanion(
                id: id,
                sessionId: sessionId,
                note: note,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int sessionId,
                required String note,
                Value<DateTime> createdAt = const Value.absent(),
              }) => SessionNotesCompanion.insert(
                id: id,
                sessionId: sessionId,
                note: note,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SessionNotesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SessionNotesTable,
      SessionNote,
      $$SessionNotesTableFilterComposer,
      $$SessionNotesTableOrderingComposer,
      $$SessionNotesTableAnnotationComposer,
      $$SessionNotesTableCreateCompanionBuilder,
      $$SessionNotesTableUpdateCompanionBuilder,
      (
        SessionNote,
        BaseReferences<_$AppDatabase, $SessionNotesTable, SessionNote>,
      ),
      SessionNote,
      PrefetchHooks Function()
    >;
typedef $$SessionCheckInsTableCreateCompanionBuilder =
    SessionCheckInsCompanion Function({
      Value<int> id,
      required int sessionId,
      required int energyLevel,
      required int focusLevel,
      required int physicalReadiness,
      Value<DateTime> createdAt,
    });
typedef $$SessionCheckInsTableUpdateCompanionBuilder =
    SessionCheckInsCompanion Function({
      Value<int> id,
      Value<int> sessionId,
      Value<int> energyLevel,
      Value<int> focusLevel,
      Value<int> physicalReadiness,
      Value<DateTime> createdAt,
    });

class $$SessionCheckInsTableFilterComposer
    extends Composer<_$AppDatabase, $SessionCheckInsTable> {
  $$SessionCheckInsTableFilterComposer({
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

  ColumnFilters<int> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get energyLevel => $composableBuilder(
    column: $table.energyLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get focusLevel => $composableBuilder(
    column: $table.focusLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get physicalReadiness => $composableBuilder(
    column: $table.physicalReadiness,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SessionCheckInsTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionCheckInsTable> {
  $$SessionCheckInsTableOrderingComposer({
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

  ColumnOrderings<int> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get energyLevel => $composableBuilder(
    column: $table.energyLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get focusLevel => $composableBuilder(
    column: $table.focusLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get physicalReadiness => $composableBuilder(
    column: $table.physicalReadiness,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SessionCheckInsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionCheckInsTable> {
  $$SessionCheckInsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<int> get energyLevel => $composableBuilder(
    column: $table.energyLevel,
    builder: (column) => column,
  );

  GeneratedColumn<int> get focusLevel => $composableBuilder(
    column: $table.focusLevel,
    builder: (column) => column,
  );

  GeneratedColumn<int> get physicalReadiness => $composableBuilder(
    column: $table.physicalReadiness,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SessionCheckInsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SessionCheckInsTable,
          SessionCheckIn,
          $$SessionCheckInsTableFilterComposer,
          $$SessionCheckInsTableOrderingComposer,
          $$SessionCheckInsTableAnnotationComposer,
          $$SessionCheckInsTableCreateCompanionBuilder,
          $$SessionCheckInsTableUpdateCompanionBuilder,
          (
            SessionCheckIn,
            BaseReferences<
              _$AppDatabase,
              $SessionCheckInsTable,
              SessionCheckIn
            >,
          ),
          SessionCheckIn,
          PrefetchHooks Function()
        > {
  $$SessionCheckInsTableTableManager(
    _$AppDatabase db,
    $SessionCheckInsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionCheckInsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionCheckInsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionCheckInsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> sessionId = const Value.absent(),
                Value<int> energyLevel = const Value.absent(),
                Value<int> focusLevel = const Value.absent(),
                Value<int> physicalReadiness = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SessionCheckInsCompanion(
                id: id,
                sessionId: sessionId,
                energyLevel: energyLevel,
                focusLevel: focusLevel,
                physicalReadiness: physicalReadiness,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int sessionId,
                required int energyLevel,
                required int focusLevel,
                required int physicalReadiness,
                Value<DateTime> createdAt = const Value.absent(),
              }) => SessionCheckInsCompanion.insert(
                id: id,
                sessionId: sessionId,
                energyLevel: energyLevel,
                focusLevel: focusLevel,
                physicalReadiness: physicalReadiness,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SessionCheckInsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SessionCheckInsTable,
      SessionCheckIn,
      $$SessionCheckInsTableFilterComposer,
      $$SessionCheckInsTableOrderingComposer,
      $$SessionCheckInsTableAnnotationComposer,
      $$SessionCheckInsTableCreateCompanionBuilder,
      $$SessionCheckInsTableUpdateCompanionBuilder,
      (
        SessionCheckIn,
        BaseReferences<_$AppDatabase, $SessionCheckInsTable, SessionCheckIn>,
      ),
      SessionCheckIn,
      PrefetchHooks Function()
    >;
typedef $$BlockNotesTableCreateCompanionBuilder =
    BlockNotesCompanion Function({
      Value<int> id,
      required int sessionId,
      required int blockIndex,
      required String note,
      Value<DateTime> createdAt,
    });
typedef $$BlockNotesTableUpdateCompanionBuilder =
    BlockNotesCompanion Function({
      Value<int> id,
      Value<int> sessionId,
      Value<int> blockIndex,
      Value<String> note,
      Value<DateTime> createdAt,
    });

class $$BlockNotesTableFilterComposer
    extends Composer<_$AppDatabase, $BlockNotesTable> {
  $$BlockNotesTableFilterComposer({
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

  ColumnFilters<int> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get blockIndex => $composableBuilder(
    column: $table.blockIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BlockNotesTableOrderingComposer
    extends Composer<_$AppDatabase, $BlockNotesTable> {
  $$BlockNotesTableOrderingComposer({
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

  ColumnOrderings<int> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get blockIndex => $composableBuilder(
    column: $table.blockIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BlockNotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BlockNotesTable> {
  $$BlockNotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<int> get blockIndex => $composableBuilder(
    column: $table.blockIndex,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$BlockNotesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BlockNotesTable,
          BlockNote,
          $$BlockNotesTableFilterComposer,
          $$BlockNotesTableOrderingComposer,
          $$BlockNotesTableAnnotationComposer,
          $$BlockNotesTableCreateCompanionBuilder,
          $$BlockNotesTableUpdateCompanionBuilder,
          (
            BlockNote,
            BaseReferences<_$AppDatabase, $BlockNotesTable, BlockNote>,
          ),
          BlockNote,
          PrefetchHooks Function()
        > {
  $$BlockNotesTableTableManager(_$AppDatabase db, $BlockNotesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BlockNotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BlockNotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BlockNotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> sessionId = const Value.absent(),
                Value<int> blockIndex = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => BlockNotesCompanion(
                id: id,
                sessionId: sessionId,
                blockIndex: blockIndex,
                note: note,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int sessionId,
                required int blockIndex,
                required String note,
                Value<DateTime> createdAt = const Value.absent(),
              }) => BlockNotesCompanion.insert(
                id: id,
                sessionId: sessionId,
                blockIndex: blockIndex,
                note: note,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BlockNotesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BlockNotesTable,
      BlockNote,
      $$BlockNotesTableFilterComposer,
      $$BlockNotesTableOrderingComposer,
      $$BlockNotesTableAnnotationComposer,
      $$BlockNotesTableCreateCompanionBuilder,
      $$BlockNotesTableUpdateCompanionBuilder,
      (BlockNote, BaseReferences<_$AppDatabase, $BlockNotesTable, BlockNote>),
      BlockNote,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SessionsTableTableManager get sessions =>
      $$SessionsTableTableManager(_db, _db.sessions);
  $$SessionRecordsTableTableManager get sessionRecords =>
      $$SessionRecordsTableTableManager(_db, _db.sessionRecords);
  $$DailyProgressTableTableManager get dailyProgress =>
      $$DailyProgressTableTableManager(_db, _db.dailyProgress);
  $$EveningLoadsTableTableManager get eveningLoads =>
      $$EveningLoadsTableTableManager(_db, _db.eveningLoads);
  $$SessionNotesTableTableManager get sessionNotes =>
      $$SessionNotesTableTableManager(_db, _db.sessionNotes);
  $$SessionCheckInsTableTableManager get sessionCheckIns =>
      $$SessionCheckInsTableTableManager(_db, _db.sessionCheckIns);
  $$BlockNotesTableTableManager get blockNotes =>
      $$BlockNotesTableTableManager(_db, _db.blockNotes);
}
