import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'database_provider.dart';
import '../database/database.dart';

final statsProvider = FutureProvider<Map<String, int>>((ref) async {
  final db = ref.watch(databaseProvider);
  final sessions = await db.getTotalSessions();
  final minutes = await db.getTotalMinutes();
  final streak = await db.getCurrentStreak();
  return {'sessions': sessions, 'minutes': minutes, 'streak': streak};
});

final weekProgressProvider = FutureProvider<List<bool>>((ref) async {
  final db = ref.watch(databaseProvider);
  final now = DateTime.now();
  final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
  final endOfWeek = startOfWeek.add(const Duration(days: 6));

  final weekData = await db.getWeekProgress(
    DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day),
    DateTime(endOfWeek.year, endOfWeek.month, endOfWeek.day),
  );

  final result = List<bool>.filled(7, false);
  for (final day in weekData) {
    final index = day.date.difference(DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day)).inDays;
    if (index >= 0 && index < 7) {
      result[index] = day.completed;
    }
  }
  return result;
});

final recentSessionsProvider = FutureProvider<List<Session>>((ref) async {
  final db = ref.watch(databaseProvider);
  final sessions = await db.getAllSessions();
  return sessions.reversed.take(5).toList();
});
