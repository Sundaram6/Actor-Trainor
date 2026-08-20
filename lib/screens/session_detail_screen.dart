import 'dart:convert';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../core/constants.dart' show allBlocks;
import '../database/database.dart';
import '../providers/database_provider.dart';
import '../providers/progress_providers.dart';
import '../providers/session_checkin_provider.dart';
import '../providers/session_notes_provider.dart';
import '../providers/today_provider.dart';
import '../screens/progress_screen.dart' show sessionHistoryProvider;

class SessionDetailScreen extends ConsumerStatefulWidget {
  final SessionRecord record;
  const SessionDetailScreen({super.key, required this.record});

  @override
  ConsumerState<SessionDetailScreen> createState() => _SessionDetailScreenState();
}

class _SessionDetailScreenState extends ConsumerState<SessionDetailScreen> {
  bool _isEditingNotes = false;
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController(text: widget.record.notes ?? '');
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveNotes() async {
    final newNotes = _notesController.text.trim();
    final db = ref.read(databaseProvider);

    await (db.update(db.sessionRecords)
          ..where((t) => t.id.equals(widget.record.id)))
        .write(
      SessionRecordsCompanion(
        notes: drift.Value(newNotes.isEmpty ? null : newNotes),
      ),
    );

    await ref.read(saveSessionNoteProvider)(widget.record.id, newNotes);

    ref.invalidate(sessionHistoryProvider);
    ref.invalidate(dashboardStatsProvider);
    ref.invalidate(todayStatusProvider);
    ref.invalidate(statsProvider);
    ref.invalidate(weekProgressProvider);
    ref.invalidate(mostSkippedBlockProvider);

    setState(() => _isEditingNotes = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Notes updated', style: TextStyle(color: Colors.white)),
          backgroundColor: Color(0xFF1B5E20),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFD4AF37);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Session Record',
          style: TextStyle(color: gold, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            color: Colors.white38,
            onPressed: _confirmDelete,
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            color: gold,
            onPressed: _shareRecord,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    _formatDate(widget.record.completedAt),
                    style: const TextStyle(color: Colors.white54, fontSize: 14),
                  ),
                ),
                if (widget.record.qualityRating != null)
                  Row(
                    children: List.generate(5, (i) {
                      final isFilled = i < widget.record.qualityRating!;
                      return Icon(
                        isFilled ? Icons.star_rounded : Icons.star_border_rounded,
                        color: isFilled ? gold : Colors.white24,
                        size: 18,
                      );
                    }),
                  ),
              ],
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                _StatCard(label: 'BLOCKS', value: '${widget.record.blocksCompleted} / 9'),
                const SizedBox(width: 12),
                _StatCard(label: 'DURATION', value: '${widget.record.totalMinutes} min'),
              ],
            ),
            const SizedBox(height: 24),

            if (widget.record.intention != null && widget.record.intention!.isNotEmpty) ...[
              const _SectionTitle(title: 'INTENTION'),
              const SizedBox(height: 8),
              _DarkCard(child: Text(widget.record.intention!, style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.5))),
              const SizedBox(height: 24),
            ],

            // NOTES — editable
            Row(
              children: [
                const _SectionTitle(title: 'NOTES'),
                const Spacer(),
                if (!_isEditingNotes)
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    color: Colors.white38,
                    onPressed: () => setState(() => _isEditingNotes = true),
                  )
                else
                  Row(
                    children: [
                      TextButton(
                        onPressed: () => setState(() {
                          _isEditingNotes = false;
                          _notesController.text = widget.record.notes ?? '';
                        }),
                        child: const Text('CANCEL', style: TextStyle(color: Colors.white54, fontSize: 12)),
                      ),
                      TextButton(
                        onPressed: _saveNotes,
                        child: const Text('SAVE', style: TextStyle(color: gold, fontSize: 12, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 8),
            _DarkCard(
              child: _isEditingNotes
                  ? TextField(
                      controller: _notesController,
                      style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: 'Add post-session reflections...',
                        hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.2)),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    )
                  : widget.record.notes != null && widget.record.notes!.isNotEmpty
                      ? Text(widget.record.notes!, style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.5))
                      : Text('No notes added.', style: TextStyle(color: Colors.white.withValues(alpha: 0.3), fontStyle: FontStyle.italic)),
            ),
            const SizedBox(height: 24),

            const _SectionTitle(title: 'BLOCK BREAKDOWN'),
            const SizedBox(height: 12),
            _DarkCard(
              child: Column(children: _parseBlocks().map((b) => _BlockRow(block: b)).toList()),
            ),
            const SizedBox(height: 24),

            const _SectionTitle(title: 'ACTOR\'S JOURNAL'),
            const SizedBox(height: 12),
            Consumer(
              builder: (context, ref, child) {
                final noteAsync = ref.watch(sessionNoteProvider(widget.record.id));
                return noteAsync.when(
                  data: (note) {
                    final effectiveNote = (note != null && note.isNotEmpty)
                        ? note
                        : (widget.record.notes != null && widget.record.notes!.isNotEmpty
                            ? widget.record.notes
                            : null);
                    if (effectiveNote != null && effectiveNote.isNotEmpty) {
                      return Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          border: Border(
                            left: BorderSide(color: gold, width: 2),
                          ),
                        ),
                        padding: const EdgeInsets.only(left: 16, top: 4, bottom: 4),
                        child: Text(
                          effectiveNote,
                          style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
                        ),
                      );
                    }
                    return const Text(
                      'No journal entry for this session.',
                      style: TextStyle(color: Colors.white24, fontSize: 14, fontStyle: FontStyle.italic),
                    );
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (e, s) => const SizedBox.shrink(),
                );
              },
            ),
            const SizedBox(height: 24),

            const _SectionTitle(title: 'STATE CHECK-IN'),
            const SizedBox(height: 12),
            Consumer(
              builder: (context, ref, child) {
                final checkInAsync = ref.watch(sessionCheckInProvider(widget.record.id));
                return checkInAsync.when(
                  data: (checkIn) {
                    if (checkIn == null) {
                      return const Text(
                        'No check-in recorded.',
                        style: TextStyle(color: Colors.white24, fontSize: 14, fontStyle: FontStyle.italic),
                      );
                    }
                    return Row(
                      children: [
                        _CheckInChip(label: 'Energy', value: checkIn.energyLevel),
                        const SizedBox(width: 12),
                        _CheckInChip(label: 'Focus', value: checkIn.focusLevel),
                        const SizedBox(width: 12),
                        _CheckInChip(label: 'Body', value: checkIn.physicalReadiness),
                      ],
                    );
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (e, s) => const SizedBox.shrink(),
                );
              },
            ),
            const SizedBox(height: 32),

            Center(
              child: Text(
                'The Instrument · Actor Training',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.2), fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _parseBlocks() {
    const totalBlocks = 9;
    if (widget.record.blocksJson.isNotEmpty) {
      try {
        final List<dynamic> decoded = jsonDecode(widget.record.blocksJson);
        return decoded.asMap().entries.map((e) {
          final idx = e.key;
          String status;
          String? reason;
          if (e.value is Map) {
            final map = e.value as Map<String, dynamic>;
            status = (map['status'] as String? ?? 'skipped').toLowerCase();
            reason = map['reason'] as String?;
          } else {
            status = (e.value as String? ?? 'skipped').toLowerCase();
            reason = null;
          }
          final name = idx < allBlocks.length ? allBlocks[idx].title : 'Block ${idx + 1}';
          return {'index': idx, 'name': name, 'completed': status == 'completed', 'reason': reason};
        }).toList();
      } catch (_) {}
    }
    return List.generate(totalBlocks, (i) {
      final name = i < allBlocks.length ? allBlocks[i].title : 'Block ${i + 1}';
      return {'index': i, 'name': name, 'completed': i < widget.record.blocksCompleted, 'reason': null};
    });
  }

  String _formatDate(DateTime dt) {
    final months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    final day = dt.day;
    final suffix = (day >= 11 && day <= 13) ? 'th' : (day % 10 == 1 ? 'st' : day % 10 == 2 ? 'nd' : day % 10 == 3 ? 'rd' : 'th');
    return '${months[dt.month - 1]} $day$suffix, ${dt.year} · ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _confirmDelete() async {
    const gold = Color(0xFFD4AF37);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Record', style: TextStyle(color: gold, fontWeight: FontWeight.w600)),
        content: const Text('This session record will be permanently removed. This cannot be undone.', style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.5)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('CANCEL', style: TextStyle(color: Colors.white54))),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('DELETE', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600))),
        ],
      ),
    );

    if (confirmed != true) return;

    final db = ref.read(databaseProvider);
    await (db.delete(db.sessionRecords)..where((t) => t.id.equals(widget.record.id))).go();

    ref.invalidate(sessionHistoryProvider);
    ref.invalidate(dashboardStatsProvider);
    ref.invalidate(todayStatusProvider);
    ref.invalidate(statsProvider);
    ref.invalidate(weekProgressProvider);
    ref.invalidate(mostSkippedBlockProvider);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Session deleted', style: TextStyle(color: Colors.white)), backgroundColor: Color(0xFF424242), duration: Duration(seconds: 2)),
      );
      Navigator.pop(context);
    }
  }

  void _shareRecord() {
    final buffer = StringBuffer()
      ..writeln('🎭 The Instrument — Session Record')
      ..writeln('')
      ..writeln('📅 ${_formatDate(widget.record.completedAt)}')
      ..writeln('⏱️ ${widget.record.totalMinutes} minutes')
      ..writeln('🧱 ${widget.record.blocksCompleted} / 9 blocks');
    if (widget.record.intention != null) buffer.writeln('🎯 Intention: ${widget.record.intention}');
    if (widget.record.notes != null) buffer.writeln('📝 Notes: ${widget.record.notes}');
    buffer.writeln('');
    buffer.writeln('Trained with The Instrument.');
    Share.share(buffer.toString(), subject: 'The Instrument Session Record');
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Color(0xFFD4AF37), fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 1)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title, style: const TextStyle(color: Color(0xFFD4AF37), fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1.2));
  }
}

class _DarkCard extends StatelessWidget {
  final Widget child;
  const _DarkCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: child,
    );
  }
}

class _BlockRow extends StatelessWidget {
  final Map<String, dynamic> block;
  const _BlockRow({required this.block});

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFD4AF37);
    final completed = block['completed'] as bool;
    final index = block['index'] as int;
    final name = block['name'] as String;
    final reason = block['reason'] as String?;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: completed ? gold.withValues(alpha: 0.15) : Colors.white.withValues(alpha: 0.05),
              shape: BoxShape.circle,
              border: Border.all(color: completed ? gold : Colors.white24),
            ),
            alignment: Alignment.center,
            child: Text('${index + 1}', style: TextStyle(color: completed ? gold : Colors.white38, fontSize: 12, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: completed ? Colors.white.withValues(alpha: 0.9) : Colors.white38,
                    fontSize: 14,
                    fontWeight: completed ? FontWeight.w500 : FontWeight.normal,
                  ),
                ),
                if (!completed && reason != null)
                  Text(
                    reason,
                    style: const TextStyle(color: Colors.white38, fontSize: 11),
                  ),
              ],
            ),
          ),
          Icon(completed ? Icons.check_rounded : Icons.remove_rounded, color: completed ? gold : Colors.white24, size: 18),
        ],
      ),
    );
  }
}

class _CheckInChip extends StatelessWidget {
  final String label;
  final int value;

  const _CheckInChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFD4AF37);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: gold.withValues(alpha: 0.3)),
      ),
      child: Text(
        '$label: $value',
        style: const TextStyle(color: gold, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}

