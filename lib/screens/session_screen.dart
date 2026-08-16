import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../core/constants.dart';
import '../providers/database_provider.dart';
import '../database/database.dart';
import '../services/sound_service.dart';
import 'session_complete_screen.dart';

class SessionScreen extends ConsumerStatefulWidget {
  final int startBlockIndex;
  const SessionScreen({super.key, this.startBlockIndex = 0});

  @override
  ConsumerState<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends ConsumerState<SessionScreen> {
  late int _currentIndex;
  int _secondsRemaining = 0;
  Timer? _timer;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.startBlockIndex;
    _secondsRemaining = kRoutineBlocks[_currentIndex].durationMinutes * 60;
  }

  void _toggleTimer() {
    if (_isRunning) {
      _timer?.cancel();
      setState(() => _isRunning = false);
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (_secondsRemaining > 0) {
          setState(() => _secondsRemaining--);
        } else {
          _timer?.cancel();
          setState(() => _isRunning = false);
          if (_currentIndex < kRoutineBlocks.length - 1) {
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
    SoundService.playBell();
    _timer?.cancel();
    if (_currentIndex < kRoutineBlocks.length - 1) {
      setState(() {
        _currentIndex++;
        _secondsRemaining = kRoutineBlocks[_currentIndex].durationMinutes * 60;
        _isRunning = false;
      });
    }
  }

  Future<void> _onSessionComplete() async {
    SoundService.playBell();
    _timer?.cancel();
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

    await db.upsertDayProgress(DailyProgressCompanion(
      date: drift.Value(today),
      completed: const drift.Value(true),
      minutesLogged: drift.Value(totalMinutes),
    ));

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => SessionCompleteScreen(
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
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final current = kRoutineBlocks[_currentIndex];
    final total = kRoutineBlocks.fold<int>(0, (s, b) => s + b.durationMinutes);
    final elapsedMins = kRoutineBlocks.sublist(0, _currentIndex).fold<int>(0, (s, b) => s + b.durationMinutes) +
        ((current.durationMinutes * 60 - _secondsRemaining) ~/ 60);
    final progress = elapsedMins / total;
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 24),
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
            const SizedBox(height: 40),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.goldAccent.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${_currentIndex + 1}',
                  style: AppTextStyles.h1.copyWith(
                    color: AppColors.goldAccent,
                    fontSize: 40,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              current.name,
              style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              '${current.durationMinutes} MINUTES',
              style: AppTextStyles.caption,
            ),
            const SizedBox(height: 48),
            Text(
              _timeText,
              style: AppTextStyles.h1.copyWith(
                fontSize: 72,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 48),
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
            const SizedBox(height: 48),
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
          ],
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
