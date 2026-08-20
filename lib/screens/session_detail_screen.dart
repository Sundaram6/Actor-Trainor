import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../core/constants.dart' show allBlocks;
import '../database/database.dart';

class SessionDetailScreen extends ConsumerWidget {
  final SessionRecord record;

  const SessionDetailScreen({super.key, required this.record});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            icon: const Icon(Icons.share_outlined),
            color: gold,
            onPressed: () => _shareRecord(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timestamp
            Text(
              _formatDate(record.completedAt),
              style: const TextStyle(color: Colors.white54, fontSize: 14),
            ),
            const SizedBox(height: 24),

            // Stats row
            Row(
              children: [
                _StatCard(
                  label: 'BLOCKS',
                  value: '${record.blocksCompleted} / 9',
                ),
                const SizedBox(width: 12),
                _StatCard(
                  label: 'DURATION',
                  value: '${record.totalMinutes} min',
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Intention
            if (record.intention != null && record.intention!.isNotEmpty) ...[
              const _SectionTitle(title: 'INTENTION'),
              const SizedBox(height: 8),
              _DarkCard(child: Text(record.intention!, style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.5))),
              const SizedBox(height: 24),
            ],

            // Notes
            if (record.notes != null && record.notes!.isNotEmpty) ...[
              const _SectionTitle(title: 'NOTES'),
              const SizedBox(height: 8),
              _DarkCard(child: Text(record.notes!, style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.5))),
              const SizedBox(height: 24),
            ],

            // Block Breakdown
            const _SectionTitle(title: 'BLOCK BREAKDOWN'),
            const SizedBox(height: 12),
            _DarkCard(
              child: Column(children: _parseBlocks().map((b) => _BlockRow(block: b)).toList()),
            ),
            const SizedBox(height: 32),

            // Footer
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

    if (record.blocksJson.isNotEmpty) {
      try {
        final List<dynamic> decoded = jsonDecode(record.blocksJson);
        return decoded.asMap().entries.map((e) {
          final idx = e.key;
          final status = (e.value as String? ?? 'skipped').toLowerCase();
          final name = idx < allBlocks.length ? allBlocks[idx].title : 'Block ${idx + 1}';
          return {'index': idx, 'name': name, 'completed': status == 'completed'};
        }).toList();
      } catch (_) {}
    }

    // Fallback: infer from blocksCompleted count
    return List.generate(totalBlocks, (i) {
      final name = i < allBlocks.length ? allBlocks[i].title : 'Block ${i + 1}';
      return {'index': i, 'name': name, 'completed': i < record.blocksCompleted};
    });
  }

  String _formatDate(DateTime dt) {
    final months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    final day = dt.day;
    final suffix = (day >= 11 && day <= 13) ? 'th' : (day % 10 == 1 ? 'st' : day % 10 == 2 ? 'nd' : day % 10 == 3 ? 'rd' : 'th');
    return '${months[dt.month - 1]} $day$suffix, ${dt.year} · ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  void _shareRecord(BuildContext context) {
    final buffer = StringBuffer()
      ..writeln('🎭 The Instrument — Session Record')
      ..writeln('')
      ..writeln('📅 ${_formatDate(record.completedAt)}')
      ..writeln('⏱️ ${record.totalMinutes} minutes')
      ..writeln('🧱 ${record.blocksCompleted} / 9 blocks');
    if (record.intention != null) buffer.writeln('🎯 Intention: ${record.intention}');
    if (record.notes != null) buffer.writeln('📝 Notes: ${record.notes}');
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
    return Text(
      title,
      style: const TextStyle(color: Color(0xFFD4AF37), fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1.2),
    );
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
            child: Text(
              '${index + 1}',
              style: TextStyle(color: completed ? gold : Colors.white38, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                color: completed ? Colors.white.withValues(alpha: 0.9) : Colors.white38,
                fontSize: 14,
                fontWeight: completed ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ),
          Icon(
            completed ? Icons.check_rounded : Icons.remove_rounded,
            color: completed ? gold : Colors.white24,
            size: 18,
          ),
        ],
      ),
    );
  }
}
