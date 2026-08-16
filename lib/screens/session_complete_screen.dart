import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants.dart';
import '../providers/progress_providers.dart';
import '../providers/today_provider.dart';

class SessionCompleteScreen extends ConsumerWidget {
  final int totalMinutes;
  final int blocksCompleted;

  const SessionCompleteScreen({
    super.key,
    required this.totalMinutes,
    required this.blocksCompleted,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.goldAccent.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: AppColors.goldAccent,
                  size: 48,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'ROUTINE COMPLETE',
                style: AppTextStyles.h1.copyWith(
                  color: AppColors.goldAccent,
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'You completed all 9 training blocks.',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.cardSurface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _ResultItem(
                      label: 'BLOCKS',
                      value: '$blocksCompleted/9',
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: AppColors.cardBorder,
                    ),
                    _ResultItem(
                      label: 'MINUTES',
                      value: '$totalMinutes',
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ref.invalidate(statsProvider);
                    ref.invalidate(weekProgressProvider);
                    ref.invalidate(recentSessionsProvider);
                    ref.invalidate(todayStatusProvider);
                    Navigator.of(context).popUntil((route) => route.isFirst);
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
                    'BACK TO TODAY',
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
      ),
    );
  }
}

class _ResultItem extends StatelessWidget {
  final String label;
  final String value;
  const _ResultItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.h1.copyWith(
            color: AppColors.goldAccent,
            fontSize: 24,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.caption,
        ),
      ],
    );
  }
}
