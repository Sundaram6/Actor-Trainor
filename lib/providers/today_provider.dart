import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'database_provider.dart';

final todayStatusProvider = FutureProvider<bool>((ref) async {
  final db = ref.watch(databaseProvider);
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final progress = await db.getDayProgress(today);
  return progress?.completed ?? false;
});
