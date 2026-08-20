import 'dart:convert';
import 'dart:io';
import 'package:drift/drift.dart' as drift;
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database.dart';
import '../providers/database_provider.dart';

final importServiceProvider = Provider<ImportService>((ref) {
  final db = ref.watch(databaseProvider);
  return ImportService(db);
});

class ImportResult {
  final int imported;
  final int skipped;
  final bool canceled;
  final String? error;

  const ImportResult({
    required this.imported,
    required this.skipped,
    this.canceled = false,
    this.error,
  });

  factory ImportResult.canceled() => const ImportResult(imported: 0, skipped: 0, canceled: true);
  factory ImportResult.error(String message) => ImportResult(imported: 0, skipped: 0, error: message);

  String get message {
    if (canceled) return 'Import canceled';
    if (error != null) return error!;
    if (imported == 0 && skipped == 0) return 'No valid sessions found';
    if (skipped == 0) return 'Imported $imported session${imported == 1 ? '' : 's'}';
    return 'Imported $imported, skipped $skipped duplicate${skipped == 1 ? '' : 's'}';
  }

  bool get isSuccess => error == null && !canceled && imported > 0;
}

class ImportService {
  final AppDatabase _db;

  ImportService(this._db);

  Future<ImportResult> importSessionsFromJson() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        withData: true,
      );

      if (result == null || result.files.isEmpty) {
        return ImportResult.canceled();
      }

      final file = result.files.single;
      final bytes = file.bytes;
      String jsonString;

      if (bytes != null) {
        jsonString = utf8.decode(bytes);
      } else if (file.path != null) {
        jsonString = await File(file.path!).readAsString();
      } else {
        return ImportResult.canceled();
      }

      return importFromJsonString(jsonString);
    } catch (e) {
      return ImportResult.error('Import failed: $e');
    }
  }

  Future<ImportResult> importFromJsonString(String jsonString) async {
    try {
      final decoded = jsonDecode(jsonString);
      List<dynamic> jsonList;

      if (decoded is List) {
        jsonList = decoded;
      } else if (decoded is Map<String, dynamic>) {
        if (decoded.containsKey('sessions') && decoded['sessions'] is List) {
          jsonList = decoded['sessions'] as List<dynamic>;
        } else {
          jsonList = [decoded];
        }
      } else {
        return ImportResult.error('Invalid JSON format');
      }

      int imported = 0;
      int skipped = 0;

      for (final item in jsonList) {
        if (item is! Map<String, dynamic>) continue;

        final companion = _parseRecord(item);
        if (companion == null) continue;

        final completedAt = companion.completedAt.value;
        final duplicate = await _isDuplicate(completedAt);
        if (duplicate) {
          skipped++;
          continue;
        }

        await _db.into(_db.sessionRecords).insert(companion);
        imported++;
      }

      return ImportResult(imported: imported, skipped: skipped);
    } catch (e) {
      return ImportResult.error('Invalid JSON format');
    }
  }

  SessionRecordsCompanion? _parseRecord(Map<String, dynamic> json) {
    try {
      final dateStr = (json['date'] ?? json['completedAt'] ?? json['timestamp']) as String?;
      if (dateStr == null) return null;
      final completedAt = DateTime.tryParse(dateStr);
      if (completedAt == null) return null;

      final blocksCompleted = (json['blocksCompleted'] as num?)?.toInt() ?? 9;
      final totalMinutes = (json['durationMinutes'] ?? json['totalMinutes'] as num?)?.toInt() ?? 98;
      final intention = json['intention'] as String?;
      final notes = json['notes'] as String?;

      String blocksJson = '[]';
      if (json['blocksJson'] is String) {
        blocksJson = json['blocksJson'] as String;
      } else if (json['blocksJson'] is List) {
        blocksJson = jsonEncode(json['blocksJson']);
      } else {
        final list = List.generate(
          9,
          (i) => i < blocksCompleted ? 'completed' : 'skipped',
        );
        blocksJson = jsonEncode(list);
      }

      return SessionRecordsCompanion.insert(
        completedAt: completedAt,
        blocksCompleted: blocksCompleted,
        totalMinutes: totalMinutes,
        intention: drift.Value(intention),
        notes: drift.Value(notes),
        blocksJson: drift.Value(blocksJson),
      );
    } catch (_) {
      return null;
    }
  }

  Future<bool> _isDuplicate(DateTime completedAt) async {
    final existing = await (_db.select(_db.sessionRecords)
          ..where((t) => t.completedAt.equals(completedAt)))
        .get();
    return existing.isNotEmpty;
  }
}
