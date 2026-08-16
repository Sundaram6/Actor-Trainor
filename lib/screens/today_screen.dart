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
    final statusAsync = ref.watch(todayStatusProvider);

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
                                '112 MINUTE ROUTINE',
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
                const SizedBox(height: 24),
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
                const SizedBox(height: 24),
                Consumer(
                  builder: (context, ref, _) {
                    final now = DateTime.now();
                    final tomorrow = DateTime(now.year, now.month, now.day).add(const Duration(days: 1));
                    final loadAsync = ref.watch(eveningLoadProvider(tomorrow));

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
                                          ? load.scriptText.length > 30
                                              ? '${load.scriptText.substring(0, 30)}...'
                                              : load.scriptText
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
