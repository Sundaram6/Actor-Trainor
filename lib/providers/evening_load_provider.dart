import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'database_provider.dart';
import '../database/database.dart';

final activeEveningLoadProvider = StreamProvider<EveningLoad?>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.eveningLoads)
        ..where((e) => e.isActive.equals(true))
        ..orderBy([(e) => OrderingTerm.desc(e.createdAt)])
        ..limit(1))
      .watchSingleOrNull();
});

final eveningLoadProvider = activeEveningLoadProvider;
