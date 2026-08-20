import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database.dart';
import 'database_provider.dart';

final sessionCheckInProvider = FutureProvider.family<SessionCheckIn?, int>((ref, sessionId) async {
  final db = ref.watch(databaseProvider);
  return (db.select(db.sessionCheckIns)
        ..where((c) => c.sessionId.equals(sessionId)))
      .getSingleOrNull();
});

final saveSessionCheckInProvider = Provider<Future<void> Function(int, int, int, int)>((ref) {
  return (int sessionId, int energy, int focus, int physical) async {
    final db = ref.read(databaseProvider);
    await db.into(db.sessionCheckIns).insert(
          SessionCheckInsCompanion(
            sessionId: Value(sessionId),
            energyLevel: Value(energy),
            focusLevel: Value(focus),
            physicalReadiness: Value(physical),
          ),
          mode: InsertMode.replace,
        );
    ref.invalidate(sessionCheckInProvider(sessionId));
  };
});
