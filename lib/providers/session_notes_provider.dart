import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database.dart';
import 'database_provider.dart';

final sessionNoteProvider = FutureProvider.family<String?, int>((ref, sessionId) async {
  final db = ref.watch(databaseProvider);
  final row = await (db.select(db.sessionNotes)
        ..where((n) => n.sessionId.equals(sessionId)))
      .getSingleOrNull();
  return row?.note;
});

final saveSessionNoteProvider = Provider<Future<void> Function(int, String)>((ref) {
  return (int sessionId, String text) async {
    final db = ref.read(databaseProvider);
    await db.into(db.sessionNotes).insert(
          SessionNotesCompanion(
            sessionId: Value(sessionId),
            note: Value(text),
          ),
          mode: InsertMode.replace,
        );
    ref.invalidate(sessionNoteProvider(sessionId));
  };
});
