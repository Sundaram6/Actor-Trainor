import 'dart:async';
import 'dart:convert';
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../core/constants.dart';
import '../providers/block_notes_provider.dart';
import '../providers/database_provider.dart';
import '../providers/session_checkin_provider.dart';
import '../database/database.dart';
import '../services/sound_service.dart';
import '../services/tts_service.dart';
import '../widgets/breathing_guide.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../services/session_state_service.dart';
import '../widgets/notes_bottom_sheet.dart';
import '../widgets/role_scene_dialog.dart';
import '../widgets/skip_reason_bottom_sheet.dart';
import 'session_completion_screen.dart';
import 'settings_screen.dart';
import '../services/widget_service.dart';

class SessionScreen extends ConsumerStatefulWidget {
  final int startBlockIndex;
  final String? initialIntention;
  final int? initialEnergy;
  final int? initialFocus;
  final int? initialPhysical;
  final String? roleTag;

  const SessionScreen({
    super.key,
    this.startBlockIndex = 0,
    this.initialIntention,
    this.initialEnergy,
    this.initialFocus,
    this.initialPhysical,
    this.roleTag,
  });

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
  late List<String?> _skipReasons;
  String? _sessionIntention;
  final TextEditingController _intentionController = TextEditingController();
  final Map<int, String> _pendingBlockNotes = {};

  Future<void> _showBlockNoteSheet(BuildContext context, int blockIndex) async {
    final block = kRoutineBlocks[blockIndex];
    final controller = TextEditingController(text: _pendingBlockNotes[blockIndex] ?? '');

    final note = await showModalBottomSheet<String?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'NOTE: ${block.name.toUpperCase()}',
              style: const TextStyle(
                color: Color(0xFFD4AF37),
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              maxLines: 3,
              autofocus: true,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Note on ${block.name}...',
                hintStyle: const TextStyle(color: Colors.white24),
                filled: true,
                fillColor: const Color(0xFF0A0A0A),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFD4AF37)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(sheetContext),
                  child: const Text('CANCEL', style: TextStyle(color: Colors.white38)),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4AF37),
                    foregroundColor: const Color(0xFF0A0A0A),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    final text = controller.text.trim();
                    Navigator.pop(sheetContext, text);
                  },
                  child: const Text('SAVE'),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    if (note != null) {
      setState(() {
        if (note.isEmpty) {
          _pendingBlockNotes.remove(blockIndex);
        } else {
          _pendingBlockNotes[blockIndex] = note;
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    unawaited(WakelockPlus.enable().catchError((_) {}));
    _currentIndex = widget.startBlockIndex;
    _blockOutcomes = List.filled(kRoutineBlocks.length, 'pending');
    _skipReasons = List<String?>.filled(kRoutineBlocks.length, null);
    if (widget.initialIntention != null && widget.initialIntention!.isNotEmpty) {
      _sessionIntention = widget.initialIntention;
      ref.read(sessionStateServiceProvider).setIntention(widget.initialIntention);
    }
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
    final service = ref.read(sessionStateServiceProvider);
    final saved = await service.loadState();

    if (saved == null) {
      if (widget.initialIntention == null && _sessionIntention == null) {
        _showIntentionDialog();
      }
      return;
    }

    if (saved.startedAt != null &&
        DateTime.now().difference(saved.startedAt!).inHours > 4) {
      await service.clearState();
      if (widget.initialIntention == null && _sessionIntention == null) {
        _showIntentionDialog();
      }
      return;
    }

    if (!mounted) return;

    final resume = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => RepaintBoundary(
        child: AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'Resume Session?',
            style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.w600),
          ),
          content: Text(
            'You have a session in progress from ${_formatTime(saved.startedAt)}.\n\nBlock: ${saved.currentBlockIndex + 1} of 9',
            style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('START FRESH', style: TextStyle(color: Colors.white54)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('RESUME', style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );

    if (resume == true) {
      if (saved.intention != null && saved.intention!.isNotEmpty) {
        _sessionIntention = saved.intention;
      }
      if (saved.blockOutcomes != null) {
        _blockOutcomes = List<String>.from(saved.blockOutcomes!);
      }
      if (saved.skipReasons != null) {
        _skipReasons = List<String?>.from(saved.skipReasons!);
      }

      setState(() {
        _currentIndex = saved.currentBlockIndex;
        _subStepIndex = saved.currentSubStepIndex;
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
    } else {
      await service.clearState();
      if (mounted && widget.initialIntention == null && _sessionIntention == null) {
        _showIntentionDialog();
      }
    }
  }

  String _formatTime(DateTime? dt) {
    if (dt == null) return 'earlier';
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  void _showIntentionDialog() {
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
            'Set Your Intention',
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
              const Text(
                'What are you training today?',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _intentionController,
                autofocus: true,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'e.g., Breath support for Shakespeare scene',
                  hintStyle: const TextStyle(color: Colors.white30, fontSize: 13),
                  filled: true,
                  fillColor: const Color(0xFF1A1A24),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF2A2A2A)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFD4AF37)),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
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
                      onPressed: () {
                        setState(() {
                          _sessionIntention = null;
                        });
                        Navigator.pop(dialogContext);
                      },
                      child: const Text(
                        'SKIP',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
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
                        final text = _intentionController.text.trim();
                        setState(() {
                          _sessionIntention = text.isNotEmpty ? text : null;
                        });
                        Navigator.pop(dialogContext);
                      },
                      child: const Text(
                        'START SESSION',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          letterSpacing: 0.8,
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
                  final blocksData = List.generate(kRoutineBlocks.length, (i) {
                    if (_skipReasons[i] != null) {
                      return {'status': _blockOutcomes[i], 'reason': _skipReasons[i]};
                    }
                    return _blockOutcomes[i];
                  });

                  await SessionStateService().saveState(
                    blockIndex: _currentIndex,
                    stepIndex: _subStepIndex,
                    remainingSeconds: _secondsRemaining,
                    isPaused: true,
                    startedAt: _blockStartedAt,
                    blockDurationSeconds: _blockDurationSeconds,
                    blockOutcomes: _blockOutcomes,
                    intention: _sessionIntention,
                    skipReasons: _skipReasons,
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

                    final role = ref.read(roleProvider) ?? widget.roleTag;
                    final scene = ref.read(sceneProvider);

                    final insertedId = await db.insertSessionRecord(SessionRecordsCompanion(
                      completedAt: drift.Value(now),
                      blocksCompleted: drift.Value(completedBlocks),
                      totalMinutes: drift.Value(loggedMins),
                      blocksJson: drift.Value(jsonEncode(blocksData)),
                      intention: drift.Value(_sessionIntention),
                      roleTag: drift.Value(role),
                      role: drift.Value(role),
                      scene: drift.Value(scene),
                    ));

                    ref.read(roleProvider.notifier).state = null;
                    ref.read(sceneProvider.notifier).state = null;

                    if (widget.initialEnergy != null &&
                        widget.initialFocus != null &&
                        widget.initialPhysical != null) {
                      await ref.read(saveSessionCheckInProvider)(
                        insertedId,
                        widget.initialEnergy!,
                        widget.initialFocus!,
                        widget.initialPhysical!,
                      );
                    }

                    for (final entry in _pendingBlockNotes.entries) {
                      if (entry.value.trim().isNotEmpty) {
                        await ref.read(saveBlockNoteProvider)(
                          insertedId,
                          entry.key,
                          entry.value.trim(),
                        );
                      }
                    }
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

  Future<void> _skipCurrentBlock() async {
    ref.read(ttsServiceProvider).stop();
    final hapticsOn = ref.read(hapticsEnabledProvider);
    hapticLight(enabled: hapticsOn);

    final block = kRoutineBlocks[_currentIndex];
    final reason = await showModalBottomSheet<String?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SkipReasonBottomSheet(blockName: block.name),
    );

    if (reason == null) return;
    if (!mounted) return;

    _blockOutcomes[_currentIndex] = 'skipped';
    _skipReasons[_currentIndex] = reason;
    _nextBlock();
  }

  void _startTimer() {
    _timer?.cancel();
    _blockStartedAt ??= clock.now().subtract(
      Duration(seconds: _blockDurationSeconds - _secondsRemaining),
    );
    _speakCurrentInstruction();
    final db = ref.read(databaseProvider);
    db.getCurrentStreak().then((streak) {
      WidgetService.update(isCompleted: false, streak: streak, inProgress: true);
    });
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
            intention: _sessionIntention,
            skipReasons: _skipReasons,
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
        intention: _sessionIntention,
        skipReasons: _skipReasons,
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
        intention: _sessionIntention,
        skipReasons: _skipReasons,
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
      intention: _sessionIntention,
      skipReasons: _skipReasons,
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
        intention: _sessionIntention,
        skipReasons: _skipReasons,
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

    if (!mounted) return;

    final notes = await showModalBottomSheet<String?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const NotesBottomSheet(),
    );

    if (!mounted) return;

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

    final blocksData = List.generate(kRoutineBlocks.length, (i) {
      if (_skipReasons[i] != null) {
        return {'status': _blockOutcomes[i], 'reason': _skipReasons[i]};
      }
      return _blockOutcomes[i];
    });

    final role = ref.read(roleProvider) ?? widget.roleTag;
    final scene = ref.read(sceneProvider);

    final insertedId = await db.insertSessionRecord(SessionRecordsCompanion(
      completedAt: drift.Value(now),
      blocksCompleted: drift.Value(completedBlocksCount),
      totalMinutes: drift.Value(totalMinutes),
      blocksJson: drift.Value(jsonEncode(blocksData)),
      intention: drift.Value(_sessionIntention),
      notes: drift.Value(notes),
      roleTag: drift.Value(role),
      role: drift.Value(role),
      scene: drift.Value(scene),
    ));

    ref.read(roleProvider.notifier).state = null;
    ref.read(sceneProvider.notifier).state = null;

    if (widget.initialEnergy != null &&
        widget.initialFocus != null &&
        widget.initialPhysical != null) {
      await ref.read(saveSessionCheckInProvider)(
        insertedId,
        widget.initialEnergy!,
        widget.initialFocus!,
        widget.initialPhysical!,
      );
    }

    for (final entry in _pendingBlockNotes.entries) {
      if (entry.value.trim().isNotEmpty) {
        await ref.read(saveBlockNoteProvider)(
          insertedId,
          entry.key,
          entry.value.trim(),
        );
      }
    }

    await db.upsertDayProgress(DailyProgressCompanion(
      date: drift.Value(today),
      completed: const drift.Value(true),
      minutesLogged: drift.Value(totalMinutes),
    ));

    final updatedStreak = await db.getCurrentStreak();
    await WidgetService.update(isCompleted: true, streak: updatedStreak, inProgress: false);

    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => SessionCompletionScreen(
            totalMinutes: totalMinutes,
            blocksCompleted: completedBlocksCount,
            blockOutcomes: _blockOutcomes,
            intention: _sessionIntention,
            notes: notes,
            sessionRecordId: insertedId,
            streak: updatedStreak,
            role: role,
            scene: scene,
          ),
        ),
        (route) => route.isFirst,
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
    _intentionController.dispose();
    try {
      ref.read(ttsServiceProvider).stop();
    } catch (_) {}
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
          backgroundColor: const Color(0xFF0A0A0A),
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'SESSION',
            style: TextStyle(
              color: Color(0xFFD4AF37),
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
              fontSize: 16,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.close, color: AppColors.textSecondary),
            onPressed: _showAbandonDialog,
          ),
          bottom: _sessionIntention != null && _sessionIntention!.isNotEmpty
              ? PreferredSize(
                  preferredSize: const Size.fromHeight(36),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.brightness_5_outlined,
                          color: Color(0xFFD4AF37),
                          size: 14,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            _sessionIntention!,
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : null,
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
                    if (_currentIndex == 0 && kRoutineBlocks[0].subSteps != null)
                      BreathingGuide(
                        key: ValueKey('breath_${_currentIndex}_$_subStepIndex'),
                        durationSeconds: _secondsRemaining,
                        isPaused: _isPaused,
                      )
                    else
                      Text(
                        _timeText,
                        style: AppTextStyles.h1.copyWith(
                          fontSize: 64,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    const SizedBox(height: 24),
                    // Control row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_note_outlined, color: Color(0xFFD4AF37), size: 28),
                          tooltip: 'Block Note',
                          onPressed: () => _showBlockNoteSheet(context, _currentIndex),
                        ),
                        const SizedBox(width: 12),
                        // Pause / Resume button
                        _ControlButton(
                          icon: _isPaused
                              ? Icons.play_arrow
                              : (_isRunning ? Icons.pause : Icons.play_arrow),
                          onPressed: _togglePauseResume,
                        ),
                        const SizedBox(width: 16),
                        // Next sub-step button
                        _ControlButton(
                          icon: Icons.skip_next,
                          onPressed: _isPaused
                              ? null
                              : (hasSubSteps && !isLastSubStep
                                  ? _nextSubStep
                                  : null),
                        ),
                        const SizedBox(width: 16),
                        // Skip block / Complete button
                        _ControlButton(
                          icon: isLastBlock ? Icons.check : Icons.fast_forward,
                          onPressed: _isPaused
                              ? null
                              : (isLastBlock ? _onSessionComplete : _skipCurrentBlock),
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
