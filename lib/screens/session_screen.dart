import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../core/constants.dart';
import '../providers/database_provider.dart';
import '../database/database.dart';
import '../services/sound_service.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../services/session_state_service.dart';
import 'session_completion_screen.dart';

class SessionScreen extends ConsumerStatefulWidget {
  final int startBlockIndex;
  const SessionScreen({super.key, this.startBlockIndex = 0});

  @override
  ConsumerState<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends ConsumerState<SessionScreen> {
  late int _currentIndex;
  int _subStepIndex = 0;
  int _secondsRemaining = 0;
  Timer? _timer;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    unawaited(WakelockPlus.enable().catchError((_) {}));
    _currentIndex = widget.startBlockIndex;
    _secondsRemaining = kRoutineBlocks[_currentIndex].durationMinutes * 60;
    if (kRoutineBlocks[_currentIndex].subSteps != null) {
      _subStepIndex = 0;
      _secondsRemaining = kRoutineBlocks[_currentIndex].subSteps![0].durationSeconds;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkResumeState());
  }

  Future<void> _checkResumeState() async {
    if (widget.startBlockIndex > 0) return;
    final saved = await SessionStateService().loadState();
    if (saved != null && mounted) {
      final blockName = saved.blockIndex < kRoutineBlocks.length
          ? kRoutineBlocks[saved.blockIndex].name
          : 'Block ${saved.blockIndex + 1}';
      final resume = await showDialog<bool>(
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
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            content: Text(
              'You have an unfinished session in $blockName. Resume where you left off?',
              style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('START FRESH', style: TextStyle(color: Colors.white54)),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('RESUME', style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      );
      if (resume == true && mounted) {
        setState(() {
          _currentIndex = saved.blockIndex;
          _subStepIndex = saved.stepIndex;
          _secondsRemaining = saved.remainingSeconds;
        });
      } else {
        await SessionStateService().clearState();
      }
    }
  }

  void _toggleTimer() {
    if (_isRunning) {
      _timer?.cancel();
      setState(() => _isRunning = false);
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (_secondsRemaining > 0) {
          setState(() => _secondsRemaining--);
          if (_secondsRemaining % 5 == 0) {
            SessionStateService().saveState(
              blockIndex: _currentIndex,
              stepIndex: _subStepIndex,
              remainingSeconds: _secondsRemaining,
            );
          }
        } else {
          final block = kRoutineBlocks[_currentIndex];
          final hasSubSteps = block.subSteps != null;
          if (hasSubSteps && _subStepIndex < block.subSteps!.length - 1) {
            ref.read(soundServiceProvider).playTransitionTone();
            setState(() {
              _subStepIndex++;
              _secondsRemaining = block.subSteps![_subStepIndex].durationSeconds;
            });
            SessionStateService().saveState(
              blockIndex: _currentIndex,
              stepIndex: _subStepIndex,
              remainingSeconds: _secondsRemaining,
            );
          } else if (_currentIndex < kRoutineBlocks.length - 1) {
            _nextBlock();
          } else {
            _onSessionComplete();
          }
        }
      });
      setState(() => _isRunning = true);
    }
  }

  void _nextBlock() {
    ref.read(soundServiceProvider).playTransitionTone();
    _timer?.cancel();
    if (_currentIndex < kRoutineBlocks.length - 1) {
      setState(() {
        _currentIndex++;
        _subStepIndex = 0;
        final block = kRoutineBlocks[_currentIndex];
        _secondsRemaining = block.subSteps != null
            ? block.subSteps![0].durationSeconds
            : block.durationMinutes * 60;
        _isRunning = false;
      });
      SessionStateService().saveState(
        blockIndex: _currentIndex,
        stepIndex: _subStepIndex,
        remainingSeconds: _secondsRemaining,
      );
    }
  }

  Future<void> _onSessionComplete() async {
    ref.read(soundServiceProvider).playCompletionTone();
    _timer?.cancel();
    await SessionStateService().clearState();
    final db = ref.read(databaseProvider);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final totalMinutes = kRoutineBlocks.fold<int>(0, (s, b) => s + b.durationMinutes);

    await db.insertSession(SessionsCompanion(
      date: drift.Value(now),
      blocksCompleted: const drift.Value(9),
      totalMinutes: drift.Value(totalMinutes),
      isComplete: const drift.Value(true),
    ));

    await db.insertSessionRecord(SessionRecordsCompanion(
      completedAt: drift.Value(now),
      blocksCompleted: const drift.Value(9),
      totalMinutes: drift.Value(totalMinutes),
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
            blocksCompleted: 9,
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
    unawaited(WakelockPlus.disable().catchError((_) {}));
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final current = kRoutineBlocks[_currentIndex];
    final total = kRoutineBlocks.fold<int>(0, (s, b) => s + b.durationMinutes);
    final elapsedMins = kRoutineBlocks.sublist(0, _currentIndex).fold<int>(0, (s, b) => s + b.durationMinutes) +
        ((current.durationMinutes * 60 - _secondsRemaining) ~/ 60);
    final progress = total > 0 ? elapsedMins / total : 0.0;
    final isLastBlock = _currentIndex == kRoutineBlocks.length - 1;

    return Scaffold(
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
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
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
                current.subSteps != null
                    ? current.subSteps![_subStepIndex].title
                    : current.name,
                style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                current.subSteps != null
                    ? 'STEP ${_subStepIndex + 1} OF ${current.subSteps!.length}'
                    : '${current.durationMinutes} MINUTES',
                style: AppTextStyles.caption,
              ),
              if (current.subSteps != null) ...[
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _ControlButton(
                    icon: _isRunning ? Icons.pause : Icons.play_arrow,
                    onPressed: _toggleTimer,
                  ),
                  const SizedBox(width: 24),
                  _ControlButton(
                    icon: isLastBlock ? Icons.check : Icons.skip_next,
                    onPressed: isLastBlock ? _onSessionComplete : _nextBlock,
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
