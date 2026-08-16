import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../app.dart';
import '../core/constants.dart';
import '../providers/progress_providers.dart';
import '../providers/today_provider.dart';

class SessionCompletionScreen extends ConsumerWidget {
  final int? totalMinutes;
  final int? blocksCompleted;

  const SessionCompletionScreen({
    super.key,
    this.totalMinutes,
    this.blocksCompleted,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final computedTotalMinutes = totalMinutes ??
        kRoutineBlocks.fold<int>(0, (sum, b) => sum + b.durationMinutes);
    final completedCount = blocksCompleted ?? kRoutineBlocks.length;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              const Icon(
                Icons.check_circle_outline,
                size: 80,
                color: Color(0xFFD4AF37),
              ),
              const SizedBox(height: 32),
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
              const SizedBox(height: 16),
              const Text(
                'The work is done. Leave it in the room.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 48),
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
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(statsProvider);
                  ref.invalidate(weekProgressProvider);
                  ref.invalidate(recentSessionsProvider);
                  ref.invalidate(todayStatusProvider);
                  ref.invalidate(dashboardStatsProvider);
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const MainShellScreen()),
                    (route) => false,
                  );
                },
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
