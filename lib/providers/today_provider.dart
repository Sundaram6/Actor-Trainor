import 'package:flutter_riverpod/flutter_riverpod.dart';
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
