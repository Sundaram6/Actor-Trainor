import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants.dart';
import '../providers/evening_load_provider.dart';
import '../providers/today_provider.dart';
import 'evening_load_screen.dart';
import 'session_screen.dart';

class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(dashboardStatsProvider);
    final statusAsync = ref.watch(todayStatusProvider);
    final mostSkippedAsync = ref.watch(mostSkippedBlockProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            pinned: true,
            title: Text(
              'THE INSTRUMENT',
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
                      _DashboardStatCard(
                        label: 'Today',
                        value: stats.isCompleted ? 'Completed' : 'Not started',
                        valueColor: stats.isCompleted
                            ? const Color(0xFFD4AF37)
                            : Colors.white70,
                      ),
                      const SizedBox(width: 8),
                      _DashboardStatCard(
                        label: 'Streak',
                        value: '${stats.streak}',
                        valueColor: stats.streak > 0
                            ? const Color(0xFFD4AF37)
                            : Colors.white,
                      ),
                      const SizedBox(width: 8),
                      _DashboardStatCard(
                        label: 'This Week',
                        value: '${stats.thisWeekCount}',
                        valueColor: stats.thisWeekCount > 0
                            ? const Color(0xFFD4AF37)
                            : Colors.white,
                      ),
                    ],
                  ),
                  loading: () => Row(
                    children: const [
                      _DashboardStatCard(label: 'Today', value: 'Not started'),
                      SizedBox(width: 8),
                      _DashboardStatCard(label: 'Streak', value: '0'),
                      SizedBox(width: 8),
                      _DashboardStatCard(label: 'This Week', value: '0'),
                    ],
                  ),
                  error: (error, stack) => Row(
                    children: const [
                      _DashboardStatCard(label: 'Today', value: 'Not started'),
                      SizedBox(width: 8),
                      _DashboardStatCard(label: 'Streak', value: '0'),
                      SizedBox(width: 8),
                      _DashboardStatCard(label: 'This Week', value: '0'),
                    ],
                  ),
                ),
                mostSkippedAsync.when(
                  data: (data) {
                    if (data == null || (data['count'] as int? ?? 0) < 2) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF2A2A2A)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 3,
                              height: 36,
                              decoration: BoxDecoration(
                                color: const Color(0xFFD4AF37),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Icon(
                              Icons.trending_up,
                              color: Color(0xFFD4AF37),
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Most skipped: ${data['name']} (${data['count']}×)',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  const Text(
                                    'This week',
                                    style: TextStyle(
                                      color: Colors.white38,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (error, stack) => const SizedBox.shrink(),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.cardSurface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.goldAccent.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '1',
                                style: AppTextStyles.h1.copyWith(
                                  color: AppColors.goldAccent,
                                  fontSize: 24,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Week 1 • Day 1',
                                style: AppTextStyles.h2.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '98 MINUTE ROUTINE',
                                style: AppTextStyles.caption,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      statusAsync.when(
                        data: (completed) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: completed
                                ? AppColors.goldAccent.withValues(alpha: 0.1)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.goldAccent.withValues(alpha: 0.5),
                            ),
                          ),
                          child: Text(
                            completed
                                ? 'MORNING ROUTINE: COMPLETED'
                                : 'MORNING ROUTINE: NOT STARTED',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.goldAccent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        loading: () => const SizedBox.shrink(),
                        error: (error, stack) => const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SessionScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.goldAccent,
                      foregroundColor: AppColors.background,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'START ROUTINE',
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Consumer(
                  builder: (context, ref, _) {
                    final loadAsync = ref.watch(activeEveningLoadProvider);

                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const EveningLoadScreen()),
                        );
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.cardSurface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              loadAsync.when(
                                data: (load) => load != null ? Icons.check_circle : Icons.add,
                                loading: () => Icons.add,
                                error: (error, stack) => Icons.add,
                              ),
                              color: AppColors.goldAccent,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    loadAsync.when(
                                      data: (load) => load != null ? 'Evening Load: Set' : 'Evening Load: Not Set',
                                      loading: () => 'Evening Load: Not Set',
                                      error: (error, stack) => 'Evening Load: Not Set',
                                    ),
                                    style: AppTextStyles.body.copyWith(
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    loadAsync.when(
                                      data: (load) => load != null
                                          ? load.title
                                          : 'Tap to prepare tomorrow\'s lines',
                                      loading: () => 'Tap to prepare tomorrow\'s lines',
                                      error: (error, stack) => 'Tap to prepare tomorrow\'s lines',
                                    ),
                                    style: AppTextStyles.caption,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardStatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _DashboardStatCard({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF2A2A2A)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white60,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: valueColor ?? Colors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
