import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/database_provider.dart';
import '../providers/progress_providers.dart';
import '../providers/today_provider.dart';
import '../services/export_service.dart';
import '../services/import_service.dart';
import '../services/notification_service.dart';
import '../services/sound_service.dart';
import 'package:share_plus/share_plus.dart';
import 'onboarding_screen.dart';
import 'progress_screen.dart';

final soundEnabledProvider = StateProvider<bool>((ref) => true);
final hapticsEnabledProvider = StateProvider<bool>((ref) => true);
final voiceInstructionsEnabledProvider = StateProvider<bool>((ref) => true);
final notificationEnabledProvider = StateProvider<bool>((ref) => false);
final notificationTimeProvider = StateProvider<TimeOfDay>((ref) => const TimeOfDay(hour: 7, minute: 0));

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final sound = prefs.getBool('soundEnabled') ?? true;
    final haptics = prefs.getBool('haptics_enabled') ?? true;
    final voice = prefs.getBool('voice_instructions_enabled') ?? true;
    final notif = prefs.getBool('notificationEnabled') ?? false;
    final hour = prefs.getInt('notificationHour') ?? 7;
    final minute = prefs.getInt('notificationMinute') ?? 0;
    final time = TimeOfDay(hour: hour, minute: minute);

    if (!mounted) return;
    ref.read(soundEnabledProvider.notifier).state = sound;
    ref.read(hapticsEnabledProvider.notifier).state = haptics;
    ref.read(voiceInstructionsEnabledProvider.notifier).state = voice;
    ref.read(notificationEnabledProvider.notifier).state = notif;
    ref.read(notificationTimeProvider.notifier).state = time;

    SoundService.enabled = sound;
  }

  Future<void> _saveSound(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('soundEnabled', value);
    ref.read(soundEnabledProvider.notifier).state = value;
    SoundService.enabled = value;
  }

  Future<void> _saveHaptics(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('haptics_enabled', value);
    ref.read(hapticsEnabledProvider.notifier).state = value;
  }

  Future<void> _saveVoiceInstructions(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('voice_instructions_enabled', value);
    ref.read(voiceInstructionsEnabledProvider.notifier).state = value;
  }

  Future<void> _saveNotification(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationEnabled', value);
    ref.read(notificationEnabledProvider.notifier).state = value;

    final notifService = NotificationService();
    if (value) {
      final time = ref.read(notificationTimeProvider);
      await notifService.scheduleDailyReminder(
        hour: time.hour,
        minute: time.minute,
      );
    } else {
      await notifService.cancelReminder();
    }
  }

  Future<void> _saveTime(TimeOfDay time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('notificationHour', time.hour);
    await prefs.setInt('notificationMinute', time.minute);
    ref.read(notificationTimeProvider.notifier).state = time;

    // Re-schedule if reminders are active
    if (ref.read(notificationEnabledProvider)) {
      await NotificationService().scheduleDailyReminder(
        hour: time.hour,
        minute: time.minute,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final soundOn = ref.watch(soundEnabledProvider);
    final hapticsOn = ref.watch(hapticsEnabledProvider);
    final voiceOn = ref.watch(voiceInstructionsEnabledProvider);
    final notifOn = ref.watch(notificationEnabledProvider);
    final notifTime = ref.watch(notificationTimeProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'SETTINGS',
          style: TextStyle(
            color: Color(0xFFD4AF37),
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _SectionTitle('Session'),
          _SettingsTile(
            icon: Icons.volume_up,
            label: 'Sound Effects',
            subtitle: 'Tone at block transitions',
            trailing: Switch(
              value: soundOn,
              onChanged: _saveSound,
              activeThumbColor: const Color(0xFFD4AF37),
              activeTrackColor: const Color(0xFFD4AF37).withValues(alpha: 0.3),
            ),
          ),
          const SizedBox(height: 12),
          _SettingsTile(
            icon: Icons.vibration,
            label: 'Haptic Feedback',
            subtitle: 'Vibrate on block & sub-step transitions',
            trailing: Switch(
              value: hapticsOn,
              onChanged: _saveHaptics,
              activeThumbColor: const Color(0xFFD4AF37),
              activeTrackColor: const Color(0xFFD4AF37).withValues(alpha: 0.3),
            ),
          ),
          const SizedBox(height: 12),
          _SettingsTile(
            icon: Icons.record_voice_over,
            label: 'Voice Instructions',
            subtitle: 'Reads step instructions aloud',
            trailing: Switch(
              value: voiceOn,
              onChanged: _saveVoiceInstructions,
              activeThumbColor: const Color(0xFFD4AF37),
              activeTrackColor: const Color(0xFFD4AF37).withValues(alpha: 0.3),
            ),
          ),
          const SizedBox(height: 24),
          const _SectionTitle('Reminders'),
          _SettingsTile(
            icon: Icons.notifications,
            label: 'Daily Reminder',
            subtitle: notifOn
                ? 'Every day at ${_formatTime(notifTime)}'
                : 'Off',
            trailing: Switch(
              value: notifOn,
              onChanged: _saveNotification,
              activeThumbColor: const Color(0xFFD4AF37),
              activeTrackColor: const Color(0xFFD4AF37).withValues(alpha: 0.3),
            ),
          ),
          if (notifOn)
            Padding(
              padding: const EdgeInsets.only(left: 56, top: 8, bottom: 8),
              child: InkWell(
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: notifTime,
                    builder: (context, child) => Theme(
                      data: Theme.of(context).copyWith(
                        timePickerTheme: const TimePickerThemeData(
                          backgroundColor: Color(0xFF1A1A1A),
                          dialBackgroundColor: Color(0xFF2A2A2A),
                          hourMinuteTextColor: Colors.white,
                          dayPeriodTextColor: Colors.white70,
                          dialHandColor: Color(0xFFD4AF37),
                          dialTextColor: Colors.white,
                        ),
                      ),
                      child: child!,
                    ),
                  );
                  if (picked != null) await _saveTime(picked);
                },
                child: Row(
                  children: [
                    const Icon(Icons.access_time, color: Colors.white38, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Change time',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 24),
          const _SectionTitle('Data'),
          _SettingsTile(
            icon: Icons.replay,
            label: 'Replay Onboarding',
            subtitle: 'View the intro screens again',
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('has_completed_onboarding', false);
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const OnboardingScreen()),
                  (route) => false,
                );
              }
            },
          ),
          const SizedBox(height: 12),
          _SettingsTile(
            icon: Icons.download,
            label: 'Export All Data',
            subtitle: 'Save sessions & loads as JSON to Downloads',
            onTap: () async {
              final exportService = ref.read(exportServiceProvider);
              final path = await exportService.exportAllData();
              if (!context.mounted) return;
              if (path != null) {
                final displayPath = path.contains(RegExp(r'[\\/]'))
                    ? 'Downloads/${path.split(RegExp(r'[\\/]')).last}'
                    : path;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Saved to $displayPath',
                      style: const TextStyle(
                        color: Color(0xFF0A0A0F),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    backgroundColor: const Color(0xFFD4AF37),
                    duration: const Duration(seconds: 4),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Export failed. Check storage permission.'),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            },
          ),
          const SizedBox(height: 12),
          _SettingsTile(
            icon: Icons.upload_file,
            label: 'Import Sessions',
            subtitle: 'Restore from JSON backup',
            onTap: () async {
              final importService = ref.read(importServiceProvider);
              final result = await importService.importSessionsFromJson();

              if (result.imported > 0) {
                ref.invalidate(statsProvider);
                ref.invalidate(weekProgressProvider);
                ref.invalidate(recentSessionsProvider);
                ref.invalidate(todayStatusProvider);
                ref.invalidate(dashboardStatsProvider);
                ref.invalidate(sessionHistoryProvider);
              }

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      result.message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    backgroundColor: result.isSuccess
                        ? const Color(0xFF1B5E20)
                        : const Color(0xFF424242),
                    duration: const Duration(seconds: 3),
                  ),
                );
              }
            },
          ),
          const SizedBox(height: 12),
          _SettingsTile(
            icon: Icons.delete_forever,
            label: 'Reset All Progress',
            subtitle: 'Clear every session record. Cannot undo.',
            onTap: () => _showResetDialog(context),
          ),
          const SizedBox(height: 12),
          _SettingsTile(
            icon: Icons.download_outlined,
            label: 'Export Session History',
            subtitle: 'Share formatted session JSON with coach or backup',
            onTap: () async {
              final db = ref.read(databaseProvider);
              final json = await ExportService.generateJson(db);
              Share.share(
                json,
                subject: 'The Instrument — Session History Export',
              );
            },
          ),
        ],
      ),
    );
  }

  String _formatTime(TimeOfDay t) {
    final h = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final m = t.minute.toString().padLeft(2, '0');
    final ampm = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$h:$m $ampm';
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text('Reset Everything?', style: TextStyle(color: Colors.white)),
        content: const Text(
          'This will delete all session history, streaks, and progress. The work will be gone.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL', style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              final db = ref.read(databaseProvider);
              await db.delete(db.sessionRecords).go();
              await db.delete(db.sessions).go();
              await db.delete(db.dailyProgress).go();
              await db.delete(db.eveningLoads).go();

              ref.invalidate(statsProvider);
              ref.invalidate(weekProgressProvider);
              ref.invalidate(recentSessionsProvider);
              ref.invalidate(todayStatusProvider);
              ref.invalidate(dashboardStatsProvider);
              ref.invalidate(sessionHistoryProvider);

              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('All progress reset.'),
                    backgroundColor: Color(0xFFD4AF37),
                  ),
                );
              }
            },
            child: const Text('RESET', style: TextStyle(color: Colors.redAccent)),
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
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          color: Colors.white38,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF1A1A1A),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF2A2A2A)),
        ),
        child: ListTile(
          leading: Icon(icon, color: const Color(0xFFD4AF37)),
          title: Text(label, style: const TextStyle(color: Colors.white, fontSize: 15)),
          subtitle: Text(subtitle, style: const TextStyle(color: Colors.white54, fontSize: 13)),
          trailing: trailing,
          onTap: onTap,
        ),
      ),
    );
  }
}
