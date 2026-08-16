import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../core/constants.dart';
import '../providers/database_provider.dart';
import '../providers/evening_load_provider.dart';
import '../database/database.dart';

class EveningLoadScreen extends ConsumerStatefulWidget {
  const EveningLoadScreen({super.key});

  @override
  ConsumerState<EveningLoadScreen> createState() => _EveningLoadScreenState();
}

class _EveningLoadScreenState extends ConsumerState<EveningLoadScreen> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadExisting();
  }

  Future<void> _loadExisting() async {
    final db = ref.read(databaseProvider);
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day).add(const Duration(days: 1));
    final existing = await db.getEveningLoad(tomorrow);
    if (existing != null) {
      _controller.text = existing.scriptText;
    }
  }

  Future<void> _save() async {
    final db = ref.read(databaseProvider);
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day).add(const Duration(days: 1));
    await db.upsertEveningLoad(EveningLoadsCompanion(
      date: drift.Value(tomorrow),
      scriptText: drift.Value(_controller.text.trim()),
    ));
    ref.invalidate(eveningLoadProvider);
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'EVENING LOAD',
          style: AppTextStyles.h1.copyWith(color: AppColors.goldAccent),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textSecondary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _save,
            child: Text(
              'SAVE',
              style: AppTextStyles.body.copyWith(
                color: AppColors.goldAccent,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tomorrow\'s Scene / Lines',
              style: AppTextStyles.caption,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardSurface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: TextField(
                  controller: _controller,
                  style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                    hintText: 'Paste your scene text, notes, or character prep here...',
                    hintStyle: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.goldAccent,
                  foregroundColor: AppColors.background,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'SAVE EVENING LOAD',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
