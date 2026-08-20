import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

class Sessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  IntColumn get blocksCompleted => integer()();
  IntColumn get totalMinutes => integer()();
  BoolColumn get isComplete => boolean().withDefault(const Constant(false))();
}

class SessionRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get completedAt => dateTime()();
  IntColumn get blocksCompleted => integer()();
  IntColumn get totalMinutes => integer()();
  TextColumn get notes => text().nullable()();
  TextColumn get blocksJson => text().withDefault(const Constant('[]'))();
  TextColumn get intention => text().nullable()();
  IntColumn get qualityRating => integer().nullable()();
}

class DailyProgress extends Table {
  DateTimeColumn get date => dateTime()();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
  IntColumn get minutesLogged => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {date};
}

class EveningLoads extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get title => text()();
  TextColumn get content => text()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

class SessionNotes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sessionId => integer().references(SessionRecords, #id)();
  TextColumn get note => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class SessionCheckIns extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sessionId => integer().references(SessionRecords, #id)();
  IntColumn get energyLevel => integer()(); // 1–5
  IntColumn get focusLevel => integer()(); // 1–5
  IntColumn get physicalReadiness => integer()(); // 1–5
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(tables: [Sessions, SessionRecords, DailyProgress, EveningLoads, SessionNotes, SessionCheckIns])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 8;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(eveningLoads);
          }
          if (from < 3) {
            await m.addColumn(sessionRecords, sessionRecords.blocksJson);
          }
          if (from < 4) {
            await m.addColumn(sessionRecords, sessionRecords.intention);
          }
          if (from < 5) {
            // Ensure notes column is migrated
            try {
              await m.addColumn(sessionRecords, sessionRecords.notes);
            } catch (_) {}
          }
          if (from < 6) {
            await m.createTable(sessionNotes);
          }
          if (from < 7) {
            await m.createTable(sessionCheckIns);
          }
          if (from < 8) {
            await m.addColumn(sessionRecords, sessionRecords.qualityRating);
          }
        },
      );

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'instrument_db');
  }

  // Session queries
  Future<List<Session>> getAllSessions() => select(sessions).get();
  Future<int> insertSession(SessionsCompanion session) => into(sessions).insert(session);
  Future<int> getTotalSessions() async {
    final result = await select(sessions).get();
    return result.length;
  }
  Future<int> getTotalMinutes() async {
    final result = await select(sessions).get();
    return result.fold<int>(0, (sum, s) => sum + s.totalMinutes);
  }

  // SessionRecord queries
  Future<List<SessionRecord>> get allSessionRecords => select(sessionRecords).get();
  Future<List<SessionRecord>> getAllSessionRecords() => select(sessionRecords).get();
  Future<int> insertSessionRecord(SessionRecordsCompanion record) => into(sessionRecords).insert(record);
  Future<int> updateSessionRecordNotes(int id, String notes) {
    return (update(sessionRecords)..where((s) => s.id.equals(id)))
        .write(SessionRecordsCompanion(notes: Value(notes)));
  }

  Future<int> getSessionsCountLast7Days() async {
    final now = DateTime.now();
    final sevenDaysAgo = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 6));
    final records = await (select(sessionRecords)
          ..where((s) => s.completedAt.isBiggerOrEqualValue(sevenDaysAgo)))
        .get();
    final sList = await (select(sessions)
          ..where((s) => s.date.isBiggerOrEqualValue(sevenDaysAgo)))
        .get();
    return records.length > sList.length ? records.length : sList.length;
  }

  // Daily progress queries
  Future<DailyProgressData?> getDayProgress(DateTime date) {
    final start = DateTime(date.year, date.month, date.day);
    return (select(dailyProgress)..where((d) => d.date.equals(start))).getSingleOrNull();
  }

  Future<List<DailyProgressData>> getWeekProgress(DateTime start, DateTime end) {
    final s = DateTime(start.year, start.month, start.day);
    final e = DateTime(end.year, end.month, end.day, 23, 59, 59);
    return (select(dailyProgress)
          ..where((d) => d.date.isBetweenValues(s, e)))
        .get();
  }

  Future<int> upsertDayProgress(DailyProgressCompanion entry) {
    return into(dailyProgress).insertOnConflictUpdate(entry);
  }

  Future<int> getCurrentStreak() async {
    final now = DateTime.now();
    int streak = 0;
    for (int i = 0; i < 365; i++) {
      final date = DateTime(now.year, now.month, now.day).subtract(Duration(days: i));
      final day = await getDayProgress(date);
      if (day != null && day.completed) {
        streak++;
      } else if (i > 0) {
        break;
      }
    }
    return streak;
  }

  // Evening load queries
  Future<EveningLoad?> getActiveEveningLoad() {
    return (select(eveningLoads)
          ..where((e) => e.isActive.equals(true))
          ..orderBy([(e) => OrderingTerm.desc(e.createdAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<int> insertEveningLoad(EveningLoadsCompanion entry) {
    return into(eveningLoads).insert(entry);
  }
}
