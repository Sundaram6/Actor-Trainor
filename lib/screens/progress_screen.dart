import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants.dart';
import '../providers/progress_providers.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(statsProvider);
    final weekAsync = ref.watch(weekProgressProvider);
    final recentAsync = ref.watch(recentSessionsProvider);
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            pinned: true,
            title: Text(
              'PROGRESS',
              style: AppTextStyles.h1.copyWith(color: AppColors.goldAccent),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 8),
                statsAsync.when(
                  data: (stats) => Row(
                    children: [
                      _StatCard(label: 'STREAK', value: '${stats['streak']} DAYS'),
                      const SizedBox(width: 12),
                      _StatCard(label: 'SESSIONS', value: '${stats['sessions']}'),
                      const SizedBox(width: 12),
                      _StatCard(label: 'MINUTES', value: '${stats['minutes']}'),
                    ],
                  ),
                  loading: () => const Center(
                    child: CircularProgressIndicator(color: AppColors.goldAccent),
                  ),
                  error: (error, stack) => const SizedBox.shrink(),
                ),
                const SizedBox(height: 32),
                Text('THIS WEEK', style: AppTextStyles.h2),
                const SizedBox(height: 16),
                weekAsync.when(
                  data: (week) => Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.cardSurface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(7, (i) {
                        return Column(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: week[i]
                                    ? AppColors.goldAccent
                                    : AppColors.cardSurface,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: week[i]
                                      ? AppColors.goldAccent
                                      : AppColors.cardBorder,
                                ),
                              ),
                              child: week[i]
                                  ? const Icon(
                                      Icons.check,
                                      color: AppColors.background,
                                      size: 18,
                                    )
                                  : null,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              days[i],
                              style: AppTextStyles.caption.copyWith(
                                color: week[i]
                                    ? AppColors.textPrimary
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                  loading: () => const Center(
                    child: CircularProgressIndicator(color: AppColors.goldAccent),
                  ),
                  error: (error, stack) => const SizedBox.shrink(),
                ),
                const SizedBox(height: 32),
                Text('RECENT', style: AppTextStyles.h2),
                const SizedBox(height: 16),
                recentAsync.when(
                  data: (sessions) {
                    if (sessions.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.cardSurface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: Center(
                          child: Text(
                            'No sessions yet.\nStart your first routine!',
                            style: AppTextStyles.caption,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }
                    return Column(
                      children: sessions.map((s) => _HistoryRow(
                        day: _formatDate(s.date),
                        blocks: '${s.blocksCompleted}/9',
                        time: '${s.totalMinutes} min',
                      )).toList(),
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(color: AppColors.goldAccent),
                  ),
                  error: (error, stack) => const SizedBox.shrink(),
                ),
                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d = DateTime(date.year, date.month, date.day);
    if (d == today) return 'Today';
    if (d == today.subtract(const Duration(days: 1))) return 'Yesterday';
    return '${date.day}/${date.month}';
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.cardSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: AppTextStyles.h1.copyWith(
                color: AppColors.goldAccent,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryRow extends StatelessWidget {
  final String day;
  final String blocks;
  final String time;
  const _HistoryRow({
    required this.day,
    required this.blocks,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              day,
              style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
            ),
          ),
          Text(
            blocks,
            style: AppTextStyles.caption.copyWith(color: AppColors.goldAccent),
          ),
          const SizedBox(width: 24),
          Text(
            time,
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }
}
