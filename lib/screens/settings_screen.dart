import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants.dart';
import '../providers/database_provider.dart';
import '../providers/progress_providers.dart';
import '../providers/today_provider.dart';
import '../services/notification_service.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _notifications = true;
  bool _soundCues = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            pinned: true,
            title: Text(
              'SETTINGS',
              style: AppTextStyles.h1.copyWith(color: AppColors.goldAccent),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 8),
                const _SectionTitle('PREFERENCES'),
                _ToggleRow(
                  icon: Icons.notifications_outlined,
                  label: 'Daily Reminders',
                  value: _notifications,
                  onChanged: (v) async {
                    setState(() => _notifications = v);
                    await NotificationService.scheduleDailyReminder(enabled: v);
                  },
                ),
                _ToggleRow(
                  icon: Icons.volume_up_outlined,
                  label: 'Sound Cues',
                  value: _soundCues,
                  onChanged: (v) => setState(() => _soundCues = v),
                ),
                const SizedBox(height: 24),
                const _SectionTitle('ABOUT'),
                const _InfoRow(
                  icon: Icons.info_outline,
                  label: 'Version',
                  value: '1.0.0',
                ),
                const _InfoRow(
                  icon: Icons.timer_outlined,
                  label: 'Total Routine Time',
                  value: '112 minutes',
                ),
                const _InfoRow(
                  icon: Icons.fitness_center_outlined,
                  label: 'Training Blocks',
                  value: '9 blocks',
                ),
                const SizedBox(height: 24),
                const _SectionTitle('DATA'),
                _ActionRow(
                  icon: Icons.delete_outline,
                  label: 'Reset All Progress',
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (dialogContext) => AlertDialog(
                        backgroundColor: AppColors.cardSurface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        title: Text(
                          'Reset Progress?',
                          style: AppTextStyles.h2.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        content: Text(
                          'This will clear all session history. This cannot be undone.',
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(dialogContext),
                            child: Text(
                              'CANCEL',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              final db = ref.read(databaseProvider);
                              await db.delete(db.sessions).go();
                              await db.delete(db.dailyProgress).go();
                              await db.delete(db.eveningLoads).go();
                              ref.invalidate(statsProvider);
                              ref.invalidate(weekProgressProvider);
                              ref.invalidate(recentSessionsProvider);
                              ref.invalidate(todayStatusProvider);
                              if (context.mounted) {
                                Navigator.pop(dialogContext);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: AppColors.cardSurface,
                                    content: Text(
                                      'All progress reset',
                                      style: AppTextStyles.body.copyWith(color: AppColors.goldAccent),
                                    ),
                                  ),
                                );
                              }
                            },
                            child: Text(
                              'RESET',
                              style: AppTextStyles.caption.copyWith(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 48),
                Center(
                  child: Text(
                    'THE INSTRUMENT',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.goldAccent,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'Built for actors. Privacy-first. Local-only.',
                    style: AppTextStyles.caption.copyWith(fontSize: 11),
                  ),
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

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Text(
        text,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.goldAccent,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _ToggleRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.goldAccent,
            activeTrackColor: AppColors.goldAccent.withValues(alpha: 0.3),
            inactiveThumbColor: AppColors.textSecondary,
            inactiveTrackColor: AppColors.cardBorder,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(color: AppColors.goldAccent),
          ),
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ActionRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.cardSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.redAccent, size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.body.copyWith(color: Colors.redAccent),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
