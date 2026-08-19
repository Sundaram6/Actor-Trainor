import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../app.dart';
import '../core/constants.dart';
import '../providers/database_provider.dart';
import '../providers/progress_providers.dart';
import '../providers/today_provider.dart';
import 'progress_screen.dart';

class SessionCompletionScreen extends ConsumerStatefulWidget {
  final int? totalMinutes;
  final int? blocksCompleted;
  final List<String>? blockOutcomes;
  final String? intention;
  final int? sessionRecordId;
  final int? streak;

  const SessionCompletionScreen({
    super.key,
    this.totalMinutes,
    this.blocksCompleted,
    this.blockOutcomes,
    this.intention,
    this.sessionRecordId,
    this.streak,
  });

  @override
  ConsumerState<SessionCompletionScreen> createState() => _SessionCompletionScreenState();
}

class _SessionCompletionScreenState extends ConsumerState<SessionCompletionScreen> {
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _handleReturn() async {
    final noteText = _notesController.text.trim();
    if (noteText.isNotEmpty && widget.sessionRecordId != null) {
      final db = ref.read(databaseProvider);
      await db.updateSessionRecordNotes(widget.sessionRecordId!, noteText);
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

  @override
  Widget build(BuildContext context) {
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
                color: Color(0xFFD4AF37),
              ),
              const SizedBox(height: 24),
              const Text(
                'SESSION COMPLETE',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFD4AF37),
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
                      color: Color(0xFFD4AF37),
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
              const SizedBox(height: 20),
              // Journal input field
              TextField(
                controller: _notesController,
                maxLines: 3,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
                decoration: InputDecoration(
                  hintText: "What landed? What didn't?",
                  hintStyle: const TextStyle(color: Colors.white38, fontSize: 14),
                  filled: true,
                  fillColor: const Color(0xFF141419),
                  contentPadding: const EdgeInsets.all(16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF2A2A2A)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF2A2A2A)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFD4AF37)),
                  ),
                ),
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
                  side: const BorderSide(color: Color(0xFFD4AF37)),
                  foregroundColor: const Color(0xFFD4AF37),
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
                onPressed: _handleReturn,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4AF37),
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
