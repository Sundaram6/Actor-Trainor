import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'database_provider.dart';
import '../database/database.dart';

final eveningLoadProvider = FutureProvider.family<EveningLoad?, DateTime>((ref, date) async {
  final db = ref.watch(databaseProvider);
  final d = DateTime(date.year, date.month, date.day);
  return db.getEveningLoad(d);
});
