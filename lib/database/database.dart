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

class DailyProgress extends Table {
  DateTimeColumn get date => dateTime()();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
  IntColumn get minutesLogged => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {date};
}

class EveningLoads extends Table {
  DateTimeColumn get date => dateTime()();
  TextColumn get scriptText => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {date};
}

@DriftDatabase(tables: [Sessions, DailyProgress, EveningLoads])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

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
  Future<EveningLoad?> getEveningLoad(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    return (select(eveningLoads)..where((e) => e.date.equals(d))).getSingleOrNull();
  }

  Future<int> upsertEveningLoad(EveningLoadsCompanion entry) {
    return into(eveningLoads).insertOnConflictUpdate(entry);
  }
}
