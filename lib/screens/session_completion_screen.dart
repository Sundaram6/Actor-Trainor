import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../app.dart';
import '../core/constants.dart';
import '../database/database.dart';
import '../providers/database_provider.dart';
import '../providers/progress_providers.dart';
import '../providers/session_notes_provider.dart';
import '../providers/today_provider.dart';
import 'progress_screen.dart';

class SessionCompletionScreen extends ConsumerStatefulWidget {
  final int? totalMinutes;
  final int? blocksCompleted;
  final List<String>? blockOutcomes;
  final String? intention;
  final String? notes;
  final int? sessionRecordId;
  final int? streak;
  final String? role;
  final String? scene;

  const SessionCompletionScreen({
    super.key,
    this.totalMinutes,
    this.blocksCompleted,
    this.blockOutcomes,
    this.intention,
    this.notes,
    this.sessionRecordId,
    this.streak,
    this.role,
    this.scene,
  });

  @override
  ConsumerState<SessionCompletionScreen> createState() => _SessionCompletionScreenState();
}

class _SessionCompletionScreenState extends ConsumerState<SessionCompletionScreen> {
  late final TextEditingController _notesController;
  int _rating = 0;
  final _ratingLabels = ['Struggled', 'Below average', 'Solid', 'Strong', 'Exceptional'];

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController(text: widget.notes ?? '');
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _navigateToDashboard() async {
    if (_rating > 0 && widget.sessionRecordId != null) {
      final db = ref.read(databaseProvider);
      await (db.update(db.sessionRecords)
            ..where((r) => r.id.equals(widget.sessionRecordId!)))
          .write(SessionRecordsCompanion(qualityRating: drift.Value(_rating)));
    }

    ref.invalidate(statsProvider);
    ref.invalidate(weekProgressProvider);
    ref.invalidate(recentSessionsProvider);
    ref.invalidate(todayStatusProvider);
    ref.invalidate(dashboardStatsProvider);
    ref.invalidate(sessionHistoryProvider);

    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainShellScreen()),
        (route) => false,
      );
    }
  }

  Future<void> _handleSaveNote() async {
    final noteText = _notesController.text.trim();
    if (widget.sessionRecordId != null) {
      final db = ref.read(databaseProvider);
      if (noteText.isNotEmpty) {
        await ref.read(saveSessionNoteProvider)(widget.sessionRecordId!, noteText);
        await db.updateSessionRecordNotes(widget.sessionRecordId!, noteText);
      }
      if (_rating > 0) {
        await (db.update(db.sessionRecords)
              ..where((r) => r.id.equals(widget.sessionRecordId!)))
            .write(SessionRecordsCompanion(qualityRating: drift.Value(_rating)));
      }
    }
    if (mounted) {
      _navigateToDashboard();
    }
  }

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFD4AF37);
    final computedTotalMinutes = widget.totalMinutes ??
        kRoutineBlocks.fold<int>(0, (sum, b) => sum + b.durationMinutes);
    final completedCount = widget.blocksCompleted ??
        (widget.blockOutcomes != null
            ? widget.blockOutcomes!.where((o) => o == 'completed').length
            : kRoutineBlocks.length);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              const Icon(
                Icons.check_circle_outline,
                size: 80,
                color: gold,
              ),
              const SizedBox(height: 24),
              const Text(
                'SESSION COMPLETE',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: gold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'The work is done. Leave it in the room.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  height: 1.5,
                ),
              ),
              if (widget.intention?.isNotEmpty == true) ...[
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF141419),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF2A2A2A)),
                  ),
                  child: Text(
                    '"${widget.intention}"',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: gold,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 24),
              _StatRow(
                label: 'Blocks Completed',
                value: '$completedCount / ${kRoutineBlocks.length}',
              ),
              const SizedBox(height: 12),
              _StatRow(
                label: 'Total Time',
                value: '$computedTotalMinutes min',
              ),
              const SizedBox(height: 12),
              const _StatRow(
                label: 'Status',
                value: 'Closed',
              ),
              if (widget.role != null || widget.scene != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    '${widget.role != null ? 'Role: ${widget.role}' : ''}${widget.role != null && widget.scene != null ? '  •  ' : ''}${widget.scene != null ? 'Scene: ${widget.scene}' : ''}',
                    style: const TextStyle(color: Colors.white54, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 24),

              // 5-Star Session Quality Rating
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final starIndex = index + 1;
                  final isFilled = starIndex <= _rating;
                  return GestureDetector(
                    onTap: () => setState(() => _rating = starIndex),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        isFilled ? Icons.star_rounded : Icons.star_border_rounded,
                        color: isFilled ? gold : Colors.white24,
                        size: 36,
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  _rating == 0 ? 'Rate this session' : _ratingLabels[_rating - 1],
                  style: const TextStyle(color: Colors.white38, fontSize: 14),
                ),
              ),
              const SizedBox(height: 24),

              // Actor's Journal Note input field
              TextField(
                controller: _notesController,
                maxLines: 4,
                style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
                decoration: InputDecoration(
                  hintText: "What surfaced during today's work? What do you carry forward?",
                  hintStyle: const TextStyle(color: Colors.white24),
                  filled: true,
                  fillColor: const Color(0xFF1A1A1A),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: gold),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _navigateToDashboard,
                    child: const Text('SKIP', style: TextStyle(color: Colors.white38, fontSize: 14)),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _handleSaveNote,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(120, 48),
                      backgroundColor: gold,
                      foregroundColor: const Color(0xFF0A0A0A),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    child: const Text('SAVE NOTE'),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              OutlinedButton(
                onPressed: () async {
                  final streak = widget.streak ?? (await ref.read(databaseProvider).getCurrentStreak());
                  final durationMinutes = computedTotalMinutes;
                  Share.share(
                    'I just completed my 9/9 block acting routine on The Instrument! 🔥\n'
                    'Streak: $streak days\n'
                    'Duration: $durationMinutes min\n'
                    'The instrument is tuned. 🎭',
                    subject: 'The Instrument — Session Complete',
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: gold),
                  foregroundColor: gold,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'SHARE PROGRESS',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _navigateToDashboard,
                style: ElevatedButton.styleFrom(
                  backgroundColor: gold,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'RETURN TO DASHBOARD',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;

  const _StatRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white60,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
