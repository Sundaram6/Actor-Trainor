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
    ref.invalidate(allSessionNotesProvider);
  };
});

final allSessionNotesProvider = StreamProvider<List<({SessionRecord session, String note})>>((ref) async* {
  final db = ref.watch(databaseProvider);
  final sessions = await db.select(db.sessionRecords).get();
  final notes = await db.select(db.sessionNotes).get();

  final result = <({SessionRecord session, String note})>[];
  for (final note in notes) {
    final session = sessions.where((s) => s.id == note.sessionId).firstOrNull;
    if (session != null) {
      result.add((session: session, note: note.note));
    }
  }
  result.sort((a, b) => b.session.completedAt.compareTo(a.session.completedAt));
  yield result;
});
