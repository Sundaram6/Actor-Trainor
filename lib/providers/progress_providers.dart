import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'database_provider.dart';
import '../database/database.dart';
import '../core/constants.dart' show allBlocks;

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

final weeklyReportProvider = FutureProvider<WeeklyReport>((ref) async {
  final db = ref.watch(databaseProvider);
  final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));

  final records = await (db.select(db.sessionRecords)
        ..where((t) => t.completedAt.isBiggerOrEqualValue(sevenDaysAgo)))
      .get();

  if (records.isEmpty) return WeeklyReport.empty();

  final totalMinutes = records.fold<int>(0, (sum, r) => sum + r.totalMinutes);
  final totalBlocksPossible = records.length * 9;
  final totalBlocksCompleted = records.fold<int>(0, (sum, r) => sum + r.blocksCompleted);
  final completionRate = totalBlocksPossible > 0 ? totalBlocksCompleted / totalBlocksPossible : 0.0;

  final skipCounts = List<int>.filled(9, 0);
  for (final record in records) {
    if (record.blocksJson.isNotEmpty) {
      try {
        final List<dynamic> decoded = jsonDecode(record.blocksJson);
        for (int i = 0; i < decoded.length && i < 9; i++) {
          String status;
          if (decoded[i] is Map) {
            status = (decoded[i] as Map<String, dynamic>)['status'] as String? ?? 'skipped';
          } else {
            status = decoded[i] as String? ?? 'skipped';
          }
          if (status.toLowerCase() != 'completed') skipCounts[i]++;
        }
      } catch (_) {}
    }
  }

  int mostSkippedIndex = 0;
  int maxSkips = 0;
  for (int i = 0; i < 9; i++) {
    if (skipCounts[i] > maxSkips) {
      maxSkips = skipCounts[i];
      mostSkippedIndex = i;
    }
  }

  return WeeklyReport(
    sessionsCompleted: records.length,
    totalMinutes: totalMinutes,
    completionRate: completionRate,
    mostSkippedBlock: maxSkips > 0
        ? (mostSkippedIndex < allBlocks.length
            ? allBlocks[mostSkippedIndex].title
            : 'Block ${mostSkippedIndex + 1}')
        : null,
    mostSkippedCount: maxSkips,
  );
});

class WeeklyReport {
  final int sessionsCompleted;
  final int totalMinutes;
  final double completionRate;
  final String? mostSkippedBlock;
  final int mostSkippedCount;

  const WeeklyReport({
    required this.sessionsCompleted,
    required this.totalMinutes,
    required this.completionRate,
    this.mostSkippedBlock,
    this.mostSkippedCount = 0,
  });

  factory WeeklyReport.empty() => const WeeklyReport(
        sessionsCompleted: 0,
        totalMinutes: 0,
        completionRate: 0.0,
      );
}

final streakCalendarProvider = FutureProvider<Set<DateTime>>((ref) async {
  final db = ref.watch(databaseProvider);
  final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));

  final records = await (db.select(db.sessionRecords)
        ..where((t) => t.completedAt.isBiggerOrEqualValue(thirtyDaysAgo)))
      .get();

  return records
      .map((r) => DateTime(r.completedAt.year, r.completedAt.month, r.completedAt.day))
      .toSet();
});

