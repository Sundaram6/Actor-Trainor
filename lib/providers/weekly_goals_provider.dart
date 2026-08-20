import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants.dart';
import 'database_provider.dart';

class WeeklyGoalNotifier extends StateNotifier<int> {
  final String key;
  WeeklyGoalNotifier(this.key, int defaultValue) : super(defaultValue) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(key)) {
      state = prefs.getInt(key)!;
    }
  }

  Future<void> setGoal(int value) async {
    state = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }
}

final weeklySessionGoalProvider = StateNotifierProvider<WeeklyGoalNotifier, int>((ref) {
  return WeeklyGoalNotifier(kWeeklySessionGoal, kDefaultWeeklySessionGoal);
});

final weeklyMinuteGoalProvider = StateNotifierProvider<WeeklyGoalNotifier, int>((ref) {
  return WeeklyGoalNotifier(kWeeklyMinuteGoal, kDefaultWeeklyMinuteGoal);
});

final weeklyGoalsProgressProvider = FutureProvider<({int sessionsDone, int minutesDone})>((ref) async {
  final db = ref.watch(databaseProvider);
  final now = DateTime.now();
  final startOfWeek = DateTime(now.year, now.month, now.day).subtract(Duration(days: now.weekday - 1));
  final sessions = await (db.select(db.sessionRecords)
        ..where((r) => r.completedAt.isBiggerOrEqualValue(startOfWeek)))
      .get();
  return (
    sessionsDone: sessions.length,
    minutesDone: sessions.fold<int>(0, (sum, s) => sum + s.totalMinutes),
  );
});
