import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants.dart';
import 'database_provider.dart';

class DashboardStats {
  final bool isCompleted;
  final int streak;
  final int thisWeekCount;

  const DashboardStats({
    required this.isCompleted,
    required this.streak,
    required this.thisWeekCount,
  });
}

final todayStatusProvider = FutureProvider<bool>((ref) async {
  final db = ref.watch(databaseProvider);
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final progress = await db.getDayProgress(today);
  return progress?.completed ?? false;
});

final dashboardStatsProvider = FutureProvider<DashboardStats>((ref) async {
  final db = ref.watch(databaseProvider);
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final progress = await db.getDayProgress(today);
  final isCompleted = progress?.completed ?? false;
  final streak = await db.getCurrentStreak();
  final thisWeekCount = await db.getSessionsCountLast7Days();

  return DashboardStats(
    isCompleted: isCompleted,
    streak: streak,
    thisWeekCount: thisWeekCount,
  );
});

final mostSkippedBlockProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final db = ref.watch(databaseProvider);
  final sessions = await db.getAllSessionRecords();

  final now = DateTime.now();
  final thirtyDaysAgo = now.subtract(const Duration(days: 30));

  final recentSessions = sessions.where((s) => s.completedAt.isAfter(thirtyDaysAgo)).toList();
  if (recentSessions.isEmpty) return null;

  final Map<int, int> skipCounts = {};

  for (final s in recentSessions) {
    try {
      final outcomes = jsonDecode(s.blocksJson) as List<dynamic>;
      for (int i = 0; i < outcomes.length; i++) {
        if (outcomes[i] == 'skipped') {
          skipCounts[i] = (skipCounts[i] ?? 0) + 1;
        }
      }
    } catch (_) {}
  }

  if (skipCounts.isEmpty) return null;

  int maxBlockIndex = -1;
  int maxCount = 0;
  for (final entry in skipCounts.entries) {
    if (entry.value > maxCount) {
      maxCount = entry.value;
      maxBlockIndex = entry.key;
    }
  }

  if (maxBlockIndex >= 0 && maxBlockIndex < kRoutineBlocks.length && maxCount > 0) {
    return {
      'name': kRoutineBlocks[maxBlockIndex].name,
      'count': maxCount,
    };
  }

  return null;
});
