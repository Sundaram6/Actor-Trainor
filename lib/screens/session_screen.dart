import 'dart:async';
import 'dart:convert';
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../core/constants.dart';
import '../providers/database_provider.dart';
import '../database/database.dart';
import '../services/sound_service.dart';
import '../services/tts_service.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../services/session_state_service.dart';
import 'session_completion_screen.dart';
import 'settings_screen.dart';

class SessionScreen extends ConsumerStatefulWidget {
  final int startBlockIndex;
  const SessionScreen({super.key, this.startBlockIndex = 0});

  @override
  ConsumerState<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends ConsumerState<SessionScreen>
    with WidgetsBindingObserver {
  late int _currentIndex;
  int _subStepIndex = 0;
  int _secondsRemaining = 0;
  int _blockDurationSeconds = 0;
  DateTime? _blockStartedAt;
  DateTime? _pausedAt;
  Timer? _timer;
  bool _isRunning = false;
  bool _isPaused = false;
  late List<String> _blockOutcomes;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    unawaited(WakelockPlus.enable().catchError((_) {}));
    _currentIndex = widget.startBlockIndex;
    _blockOutcomes = List.filled(kRoutineBlocks.length, 'pending');
    final block = kRoutineBlocks[_currentIndex];
    if (block.subSteps != null) {
      _subStepIndex = 0;
      _blockDurationSeconds = block.subSteps![0].durationSeconds;
    } else {
      _blockDurationSeconds = block.durationMinutes * 60;
    }
    _secondsRemaining = _blockDurationSeconds;
    _blockStartedAt = clock.now();

    WidgetsBinding.instance.addPostFrameCallback((_) => _checkResumeState());
  }

  void _speakCurrentInstruction() {
    final block = kRoutineBlocks[_currentIndex];
    final instruction = block.subSteps != null
        ? block.subSteps![_subStepIndex].instruction
        : block.description;
    ref.read(ttsServiceProvider).speak(instruction);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (_isRunning && !_isPaused && _blockStartedAt != null) {
        final elapsed = clock.now().difference(_blockStartedAt!).inSeconds;
        final remaining = _blockDurationSeconds - elapsed;
        if (remaining > 0) {
          setState(() {
            _secondsRemaining = remaining.clamp(0, _blockDurationSeconds);
          });
        } else {
          _advanceBlockOrStep();
        }
      }
    }
  }

  Future<void> _checkResumeState() async {
    if (widget.startBlockIndex > 0) return;
    final saved = await SessionStateService().loadState();
    if (saved != null && mounted) {
      final blockName = saved.blockIndex < kRoutineBlocks.length
          ? kRoutineBlocks[saved.blockIndex].name
          : 'Block ${saved.blockIndex + 1}';
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => RepaintBoundary(
          child: AlertDialog(
            backgroundColor: const Color(0xFF1A1A1A),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: Color(0xFF2A2A2A)),
            ),
            title: const Text(
              'Resume Session?',
              style: TextStyle(
                color: Color(0xFFD4AF37),
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            content: Text(
              'You have an unfinished session in $blockName. Resume where you left off?',
              style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  await SessionStateService().clearState();
                  if (mounted) Navigator.pop(context);
                },
                child: const Text('START FRESH', style: TextStyle(color: Colors.white54)),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _currentIndex = saved.blockIndex;
                    _subStepIndex = saved.stepIndex;
                    if (saved.blockOutcomes != null) {
                      _blockOutcomes = List<String>.from(saved.blockOutcomes!);
                    }
                    final block = kRoutineBlocks[_currentIndex];
                    _blockDurationSeconds = saved.blockDurationSeconds ??
                        (block.subSteps != null
                            ? block.subSteps![_subStepIndex].durationSeconds
                            : block.durationMinutes * 60);

                    if (saved.isPaused) {
                      _secondsRemaining = saved.remainingSeconds;
                      _blockStartedAt = clock.now().subtract(
                        Duration(seconds: _blockDurationSeconds - _secondsRemaining),
                      );
                      _isPaused = true;
                      _isRunning = false;
                    } else if (saved.startedAt != null) {
                      final elapsed = clock.now().difference(saved.startedAt!).inSeconds;
                      final remaining = _blockDurationSeconds - elapsed;
                      if (remaining > 0) {
                        _secondsRemaining = remaining.clamp(0, _blockDurationSeconds);
                        _blockStartedAt = saved.startedAt;
                        _isPaused = false;
                        _startTimer();
                      } else {
                        _secondsRemaining = 0;
                        _advanceBlockOrStep();
                      }
                    } else {
                      _secondsRemaining = saved.remainingSeconds;
                      _blockStartedAt = clock.now().subtract(
                        Duration(seconds: _blockDurationSeconds - _secondsRemaining),
                      );
                      _isPaused = false;
                    }
                  });
                  Navigator.pop(context);
                },
                child: const Text(
                  'RESUME',
                  style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Future<void> _showAbandonDialog() async {
    ref.read(ttsServiceProvider).stop();
    final hapticsOn = ref.read(hapticsEnabledProvider);
    hapticMedium(enabled: hapticsOn);

    final block = kRoutineBlocks[_currentIndex];
    final hasSubSteps = block.subSteps != null;
    final subtitleText = hasSubSteps
        ? 'You are on Block ${_currentIndex + 1} — Step ${_subStepIndex + 1}'
        : 'You are on Block ${_currentIndex + 1}';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => RepaintBoundary(
        child: AlertDialog(
          backgroundColor: const Color(0xFF141419),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFF2A2A2A)),
          ),
          title: const Text(
            'Leave Session?',
            style: TextStyle(
              color: Color(0xFFD4AF37),
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                subtitleText,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              // RESUME button
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFD4AF37),
                  side: const BorderSide(color: Color(0xFFD4AF37), width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: const Text(
                  'RESUME',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // SAVE & EXIT button
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFD4AF37),
                  side: const BorderSide(color: Color(0xFFD4AF37), width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  _timer?.cancel();
                  ref.read(ttsServiceProvider).stop();
                  await SessionStateService().saveState(
                    blockIndex: _currentIndex,
                    stepIndex: _subStepIndex,
                    remainingSeconds: _secondsRemaining,
                    isPaused: true,
                    startedAt: _blockStartedAt,
                    blockDurationSeconds: _blockDurationSeconds,
                    blockOutcomes: _blockOutcomes,
                  );

                  // Record session progress in DB if any blocks finished
                  final completedBlocks = _blockOutcomes.where((o) => o == 'completed').length;
                  if (completedBlocks > 0 || _blockOutcomes.contains('skipped')) {
                    final db = ref.read(databaseProvider);
                    final now = clock.now();
                    final loggedMins = kRoutineBlocks
                        .asMap()
                        .entries
                        .where((e) => _blockOutcomes[e.key] == 'completed')
                        .fold<int>(0, (sum, e) => sum + e.value.durationMinutes);

                    await db.insertSessionRecord(SessionRecordsCompanion(
                      completedAt: drift.Value(now),
                      blocksCompleted: drift.Value(completedBlocks),
                      totalMinutes: drift.Value(loggedMins),
                      blocksJson: drift.Value(jsonEncode(_blockOutcomes)),
                    ));
                  }

                  if (dialogContext.mounted) {
                    Navigator.pop(dialogContext);
                  }
                  if (mounted) {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  }
                },
                child: const Text(
                  'SAVE & EXIT',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // DISCARD button
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFD4AF37),
                  side: const BorderSide(color: Color(0xFFD4AF37), width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  _timer?.cancel();
                  ref.read(ttsServiceProvider).stop();
                  await SessionStateService().clearState();
                  if (dialogContext.mounted) {
                    Navigator.pop(dialogContext);
                  }
                  if (mounted) {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  }
                },
                child: const Text(
                  'DISCARD',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showSkipBlockDialog() async {
    ref.read(ttsServiceProvider).stop();
    final hapticsOn = ref.read(hapticsEnabledProvider);
    hapticLight(enabled: hapticsOn);

    final currentBlock = kRoutineBlocks[_currentIndex];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => RepaintBoundary(
        child: AlertDialog(
          backgroundColor: const Color(0xFF141419),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFF2A2A2A)),
          ),
          title: const Text(
            'Skip Block?',
            style: TextStyle(
              color: Color(0xFFD4AF37),
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text.rich(
                TextSpan(
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.5,
                  ),
                  children: [
                    const TextSpan(text: 'You are about to skip '),
                    TextSpan(
                      text: currentBlock.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(text: '. This block will be marked as skipped.'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  // CANCEL button (gold outline)
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFD4AF37),
                        side: const BorderSide(color: Color(0xFFD4AF37), width: 1.5),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => Navigator.pop(dialogContext),
                      child: const Text(
                        'CANCEL',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // SKIP button (gold fill background with dark text)
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD4AF37),
                        foregroundColor: const Color(0xFF0A0A0F),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(dialogContext);
                        _blockOutcomes[_currentIndex] = 'skipped';
                        _nextBlock();
                      },
                      child: const Text(
                        'SKIP',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _startTimer() {
    _timer?.cancel();
    _blockStartedAt ??= clock.now().subtract(
      Duration(seconds: _blockDurationSeconds - _secondsRemaining),
    );
    _speakCurrentInstruction();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_blockStartedAt == null) return;
      final elapsed = clock.now().difference(_blockStartedAt!).inSeconds;
      final remaining = _blockDurationSeconds - elapsed;
      if (remaining > 0) {
        setState(() => _secondsRemaining = remaining.clamp(0, _blockDurationSeconds));
        if (_secondsRemaining % 5 == 0) {
          SessionStateService().saveState(
            blockIndex: _currentIndex,
            stepIndex: _subStepIndex,
            remainingSeconds: _secondsRemaining,
            isPaused: _isPaused,
            startedAt: _blockStartedAt,
            blockDurationSeconds: _blockDurationSeconds,
            blockOutcomes: _blockOutcomes,
          );
        }
      } else {
        setState(() => _secondsRemaining = 0);
        _advanceBlockOrStep();
      }
    });
    setState(() => _isRunning = true);
  }

  void _advanceBlockOrStep() {
    final block = kRoutineBlocks[_currentIndex];
    final hasSubSteps = block.subSteps != null;
    if (hasSubSteps && _subStepIndex < block.subSteps!.length - 1) {
      _nextSubStep();
    } else if (_currentIndex < kRoutineBlocks.length - 1) {
      _blockOutcomes[_currentIndex] = 'completed';
      _nextBlock();
    } else {
      _blockOutcomes[_currentIndex] = 'completed';
      _onSessionComplete();
    }
  }

  void _togglePauseResume() {
    final hapticsOn = ref.read(hapticsEnabledProvider);
    if (_isPaused) {
      // Resume
      hapticLight(enabled: hapticsOn);
      if (_pausedAt != null && _blockStartedAt != null) {
        final pausedDuration = clock.now().difference(_pausedAt!);
        _blockStartedAt = _blockStartedAt!.add(pausedDuration);
        _pausedAt = null;
      } else {
        _blockStartedAt = clock.now().subtract(
          Duration(seconds: _blockDurationSeconds - _secondsRemaining),
        );
      }
      setState(() => _isPaused = false);
      _startTimer();
      SessionStateService().saveState(
        blockIndex: _currentIndex,
        stepIndex: _subStepIndex,
        remainingSeconds: _secondsRemaining,
        isPaused: false,
        startedAt: _blockStartedAt,
        blockDurationSeconds: _blockDurationSeconds,
        blockOutcomes: _blockOutcomes,
      );
    } else if (_isRunning) {
      // Pause
      ref.read(ttsServiceProvider).stop();
      hapticLight(enabled: hapticsOn);
      _pausedAt = clock.now();
      _timer?.cancel();
      setState(() {
        _isRunning = false;
        _isPaused = true;
      });
      SessionStateService().saveState(
        blockIndex: _currentIndex,
        stepIndex: _subStepIndex,
        remainingSeconds: _secondsRemaining,
        isPaused: true,
        startedAt: _blockStartedAt,
        blockDurationSeconds: _blockDurationSeconds,
        blockOutcomes: _blockOutcomes,
      );
    } else {
      // First start
      _blockStartedAt = clock.now().subtract(
        Duration(seconds: _blockDurationSeconds - _secondsRemaining),
      );
      setState(() => _isPaused = false);
      _startTimer();
    }
  }

  void _nextSubStep() {
    ref.read(ttsServiceProvider).stop();
    final hapticsOn = ref.read(hapticsEnabledProvider);
    hapticLight(enabled: hapticsOn);
    ref.read(soundServiceProvider).playTransitionTone();
    final block = kRoutineBlocks[_currentIndex];
    setState(() {
      _subStepIndex++;
      _blockDurationSeconds = block.subSteps![_subStepIndex].durationSeconds;
      _secondsRemaining = _blockDurationSeconds;
      _blockStartedAt = clock.now();
    });
    _speakCurrentInstruction();
    SessionStateService().saveState(
      blockIndex: _currentIndex,
      stepIndex: _subStepIndex,
      remainingSeconds: _secondsRemaining,
      isPaused: _isPaused,
      startedAt: _blockStartedAt,
      blockDurationSeconds: _blockDurationSeconds,
      blockOutcomes: _blockOutcomes,
    );
  }

  void _nextBlock() {
    if (_isPaused) return;
    ref.read(ttsServiceProvider).stop();
    final hapticsOn = ref.read(hapticsEnabledProvider);
    hapticMedium(enabled: hapticsOn);
    ref.read(soundServiceProvider).playTransitionTone();
    _timer?.cancel();
    if (_currentIndex < kRoutineBlocks.length - 1) {
      setState(() {
        _currentIndex++;
        _subStepIndex = 0;
        final block = kRoutineBlocks[_currentIndex];
        _blockDurationSeconds = block.subSteps != null
            ? block.subSteps![0].durationSeconds
            : block.durationMinutes * 60;
        _secondsRemaining = _blockDurationSeconds;
        _blockStartedAt = clock.now();
        _isRunning = false;
        _isPaused = false;
      });
      SessionStateService().saveState(
        blockIndex: _currentIndex,
        stepIndex: _subStepIndex,
        remainingSeconds: _secondsRemaining,
        isPaused: false,
        startedAt: _blockStartedAt,
        blockDurationSeconds: _blockDurationSeconds,
        blockOutcomes: _blockOutcomes,
      );
    }
  }

  Future<void> _onSessionComplete() async {
    ref.read(ttsServiceProvider).stop();
    final hapticsOn = ref.read(hapticsEnabledProvider);
    hapticSuccess(enabled: hapticsOn);
    ref.read(soundServiceProvider).playCompletionTone();
    _timer?.cancel();
    _blockOutcomes[_currentIndex] = 'completed';
    await SessionStateService().clearState();
    final db = ref.read(databaseProvider);
    final now = clock.now();
    final today = DateTime(now.year, now.month, now.day);
    final totalMinutes = kRoutineBlocks.fold<int>(0, (s, b) => s + b.durationMinutes);
    final completedBlocksCount = _blockOutcomes.where((o) => o == 'completed').length;

    await db.insertSession(SessionsCompanion(
      date: drift.Value(now),
      blocksCompleted: drift.Value(completedBlocksCount),
      totalMinutes: drift.Value(totalMinutes),
      isComplete: const drift.Value(true),
    ));

    await db.insertSessionRecord(SessionRecordsCompanion(
      completedAt: drift.Value(now),
      blocksCompleted: drift.Value(completedBlocksCount),
      totalMinutes: drift.Value(totalMinutes),
      blocksJson: drift.Value(jsonEncode(_blockOutcomes)),
    ));

    await db.upsertDayProgress(DailyProgressCompanion(
      date: drift.Value(today),
      completed: const drift.Value(true),
      minutesLogged: drift.Value(totalMinutes),
    ));

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => SessionCompletionScreen(
            totalMinutes: totalMinutes,
            blocksCompleted: completedBlocksCount,
            blockOutcomes: _blockOutcomes,
          ),
        ),
      );
    }
  }

  String get _timeText {
    final m = _secondsRemaining ~/ 60;
    final s = _secondsRemaining % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    ref.read(ttsServiceProvider).stop();
    WidgetsBinding.instance.removeObserver(this);
    unawaited(WakelockPlus.disable().catchError((_) {}));
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final current = kRoutineBlocks[_currentIndex];
    final total = kRoutineBlocks.fold<int>(0, (s, b) => s + b.durationMinutes);
    final elapsedMins = kRoutineBlocks.sublist(0, _currentIndex).fold<int>(0, (s, b) => s + b.durationMinutes) +
        ((_blockDurationSeconds - _secondsRemaining) ~/ 60);
    final progress = total > 0 ? elapsedMins / total : 0.0;
    final isLastBlock = _currentIndex == kRoutineBlocks.length - 1;
    final hasSubSteps = current.subSteps != null;
    final isLastSubStep = hasSubSteps ? _subStepIndex >= current.subSteps!.length - 1 : true;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _showAbandonDialog();
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'SESSION',
            style: AppTextStyles.h1.copyWith(color: AppColors.goldAccent),
          ),
          leading: IconButton(
            icon: const Icon(Icons.close, color: AppColors.textSecondary),
            onPressed: _showAbandonDialog,
          ),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              // Main session content
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: AppColors.cardSurface,
                        color: AppColors.goldAccent,
                        minHeight: 6,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'BLOCK ${_currentIndex + 1} OF ${kRoutineBlocks.length}',
                      style: AppTextStyles.caption,
                    ),
                    const SizedBox(height: 24),
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: AppColors.goldAccent.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${_currentIndex + 1}',
                          style: AppTextStyles.h1.copyWith(
                            color: AppColors.goldAccent,
                            fontSize: 36,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      hasSubSteps
                          ? current.subSteps![_subStepIndex].title
                          : current.name,
                      style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      hasSubSteps
                          ? 'STEP ${_subStepIndex + 1} OF ${current.subSteps!.length}'
                          : '${current.durationMinutes} MINUTES',
                      style: AppTextStyles.caption,
                    ),
                    if (hasSubSteps) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.cardSurface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: Text(
                          current.subSteps![_subStepIndex].instruction,
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    Text(
                      _timeText,
                      style: AppTextStyles.h1.copyWith(
                        fontSize: 64,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // 3-button control row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Pause / Resume button
                        _ControlButton(
                          icon: _isPaused
                              ? Icons.play_arrow
                              : (_isRunning ? Icons.pause : Icons.play_arrow),
                          onPressed: _togglePauseResume,
                        ),
                        const SizedBox(width: 24),
                        // Next sub-step button
                        _ControlButton(
                          icon: Icons.skip_next,
                          onPressed: _isPaused
                              ? null
                              : (hasSubSteps && !isLastSubStep
                                  ? _nextSubStep
                                  : null),
                        ),
                        const SizedBox(width: 24),
                        // Skip block / Complete button
                        _ControlButton(
                          icon: isLastBlock ? Icons.check : Icons.fast_forward,
                          onPressed: _isPaused
                              ? null
                              : (isLastBlock ? _onSessionComplete : _showSkipBlockDialog),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    if (!isLastBlock) ...[
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text('UP NEXT', style: AppTextStyles.caption),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.cardSurface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: Row(
                          children: [
                            Text(
                              '${_currentIndex + 2}',
                              style: AppTextStyles.h2.copyWith(
                                color: AppColors.goldAccent,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                kRoutineBlocks[_currentIndex + 1].name,
                                style: AppTextStyles.body.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                  ],
                ),
              ),
              // PAUSED overlay
              if (_isPaused)
                Positioned.fill(
                  child: Container(
                    color: const Color(0xDD0A0A0F),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'PAUSED',
                            style: TextStyle(
                              color: Color(0xFFD4AF37),
                              fontSize: 48,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 8,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _timeText,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 24,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          const SizedBox(height: 32),
                          Material(
                            color: const Color(0xFFD4AF37),
                            borderRadius: BorderRadius.circular(50),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(50),
                              onTap: _togglePauseResume,
                              child: Container(
                                width: 72,
                                height: 72,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: const Icon(
                                  Icons.play_arrow,
                                  color: Color(0xFF0A0A0F),
                                  size: 36,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'TAP TO RESUME',
                            style: TextStyle(
                              color: Colors.white38,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  const _ControlButton({required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: onPressed == null ? AppColors.cardSurface : AppColors.goldAccent,
      borderRadius: BorderRadius.circular(50),
      child: InkWell(
        borderRadius: BorderRadius.circular(50),
        onTap: onPressed,
        child: Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
          child: Icon(
            icon,
            color: onPressed == null
                ? AppColors.textSecondary
                : AppColors.background,
            size: 32,
          ),
        ),
      ),
    );
  }
}
