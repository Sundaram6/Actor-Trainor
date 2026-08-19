import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../database/database.dart';
import '../providers/database_provider.dart';

class ExportService {
  final AppDatabase _db;

  ExportService(this._db);

  Future<String?> exportAllData({Directory? targetDirectory}) async {
    try {
      // Request storage permission on Android if applicable
      if (Platform.isAndroid) {
        try {
          final status = await Permission.storage.request();
          if (!status.isGranted && !status.isLimited) {
            // Check manageExternalStorage or continue if app-specific directory is accessible
          }
        } catch (_) {}
      }

      final sessions = await _db.select(_db.sessionRecords).get();
      final loads = await _db.select(_db.eveningLoads).get();

      final export = {
        'exportedAt': DateTime.now().toIso8601String(),
        'app': 'The Instrument',
        'version': '1.0.0',
        'sessions': sessions.map((s) => {
          'id': s.id,
          'completedAt': s.completedAt.toIso8601String(),
          'blocksCompleted': s.blocksCompleted,
          'totalMinutes': s.totalMinutes,
          'intention': s.intention,
          'notes': s.notes,
          'blocksJson': s.blocksJson,
        }).toList(),
        'eveningLoads': loads.map((l) => {
          'id': l.id,
          'createdAt': l.createdAt.toIso8601String(),
          'title': l.title,
          'content': l.content,
          'isActive': l.isActive,
        }).toList(),
      };

      Directory? dir = targetDirectory;
      if (dir == null) {
        try {
          dir = await getDownloadsDirectory();
        } catch (_) {}
        dir ??= await getExternalStorageDirectory();
        dir ??= await getApplicationDocumentsDirectory();
      }

      final fileName = 'the_instrument_backup_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.json';
      final file = File('${dir.path}/$fileName');
      await file.writeAsString(const JsonEncoder.withIndent('  ').convert(export));

      return file.path;
    } catch (_) {
      return null;
    }
  }
}

final exportServiceProvider = Provider<ExportService>((ref) {
  final db = ref.watch(databaseProvider);
  return ExportService(db);
});
