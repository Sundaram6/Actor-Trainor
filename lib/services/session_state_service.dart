import 'package:shared_preferences/shared_preferences.dart';

class SessionStateService {
  static const String _keyActive = 'session_active';
  static const String _keyBlockIndex = 'session_block_index';
  static const String _keyStepIndex = 'session_step_index';
  static const String _keyRemainingSeconds = 'session_remaining_seconds';
  static const String _keyStartedAt = 'session_started_at';
  static const String _keyIsPaused = 'session_is_paused';
  static const String _keyBlockStartedAt = 'session_block_started_at';
  static const String _keyBlockDurationSeconds = 'session_block_duration_seconds';

  Future<void> saveState({
    required int blockIndex,
    required int stepIndex,
    required int remainingSeconds,
    bool isPaused = false,
    DateTime? startedAt,
    int? blockDurationSeconds,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyActive, true);
    await prefs.setInt(_keyBlockIndex, blockIndex);
    await prefs.setInt(_keyStepIndex, stepIndex);
    await prefs.setInt(_keyRemainingSeconds, remainingSeconds);
    await prefs.setInt(_keyStartedAt, DateTime.now().millisecondsSinceEpoch);
    await prefs.setBool(_keyIsPaused, isPaused);
    if (startedAt != null) {
      await prefs.setInt(_keyBlockStartedAt, startedAt.millisecondsSinceEpoch);
    }
    if (blockDurationSeconds != null) {
      await prefs.setInt(_keyBlockDurationSeconds, blockDurationSeconds);
    }
  }

  Future<SessionSnapshot?> loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final active = prefs.getBool(_keyActive) ?? false;
    if (!active) return null;

    final startedAt = prefs.getInt(_keyStartedAt);
    if (startedAt == null) return null;

    // Discard if older than 4 hours (session is stale)
    final started = DateTime.fromMillisecondsSinceEpoch(startedAt);
    if (DateTime.now().difference(started).inHours > 4) {
      await clearState();
      return null;
    }

    final blockStartedAtMillis = prefs.getInt(_keyBlockStartedAt);
    return SessionSnapshot(
      blockIndex: prefs.getInt(_keyBlockIndex) ?? 0,
      stepIndex: prefs.getInt(_keyStepIndex) ?? 0,
      remainingSeconds: prefs.getInt(_keyRemainingSeconds) ?? 0,
      isPaused: prefs.getBool(_keyIsPaused) ?? false,
      startedAt: blockStartedAtMillis != null
          ? DateTime.fromMillisecondsSinceEpoch(blockStartedAtMillis)
          : null,
      blockDurationSeconds: prefs.getInt(_keyBlockDurationSeconds),
    );
  }

  Future<void> clearState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyActive);
    await prefs.remove(_keyBlockIndex);
    await prefs.remove(_keyStepIndex);
    await prefs.remove(_keyRemainingSeconds);
    await prefs.remove(_keyStartedAt);
    await prefs.remove(_keyIsPaused);
    await prefs.remove(_keyBlockStartedAt);
    await prefs.remove(_keyBlockDurationSeconds);
  }
}

class SessionSnapshot {
  final int blockIndex;
  final int stepIndex;
  final int remainingSeconds;
  final bool isPaused;
  final DateTime? startedAt;
  final int? blockDurationSeconds;

  SessionSnapshot({
    required this.blockIndex,
    required this.stepIndex,
    required this.remainingSeconds,
    this.isPaused = false,
    this.startedAt,
    this.blockDurationSeconds,
  });
}
