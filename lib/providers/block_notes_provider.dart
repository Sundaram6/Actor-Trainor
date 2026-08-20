import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database.dart';
import 'database_provider.dart';

final blockNotesForSessionProvider = FutureProvider.family<Map<int, String>, int>((ref, sessionId) async {
  final db = ref.watch(databaseProvider);
  final rows = await (db.select(db.blockNotes)
        ..where((n) => n.sessionId.equals(sessionId)))
      .get();
  return {for (final r in rows) r.blockIndex: r.note};
});

final saveBlockNoteProvider = Provider<Future<void> Function(int, int, String)>((ref) {
  return (int sessionId, int blockIndex, String text) async {
    final db = ref.read(databaseProvider);
    await db.into(db.blockNotes).insert(
          BlockNotesCompanion(
            sessionId: Value(sessionId),
            blockIndex: Value(blockIndex),
            note: Value(text),
          ),
          mode: InsertMode.replace,
        );
  };
});
