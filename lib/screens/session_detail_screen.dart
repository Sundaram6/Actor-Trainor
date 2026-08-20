import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import '../database/database.dart';

class SessionDetailScreen extends ConsumerWidget {
  final SessionRecord record;

  const SessionDetailScreen({super.key, required this.record});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateStr = DateFormat('EEEE, MMM d · h:mm a').format(record.completedAt);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'SESSION RECORD',
          style: TextStyle(
            color: Color(0xFFD4AF37),
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Color(0xFFD4AF37)),
            onPressed: () {
              final text = '''
The Instrument — Session Record
Date: $dateStr
Blocks: ${record.blocksCompleted}/9
Duration: ${record.totalMinutes} min
${record.intention?.isNotEmpty == true ? 'Intention: ${record.intention}' : ''}
${record.notes?.isNotEmpty == true ? 'Notes: ${record.notes}' : ''}
'''.trim();
              Share.share(text, subject: 'The Instrument — Session Record');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dateStr,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            _DetailRow(label: 'BLOCKS COMPLETED', value: '${record.blocksCompleted} / 9'),
            _DetailRow(label: 'DURATION', value: '${record.totalMinutes} min'),
            if (record.intention?.isNotEmpty == true) ...[
              const SizedBox(height: 24),
              const _SectionTitle('INTENTION'),
              const SizedBox(height: 8),
              Text(
                record.intention!,
                style: const TextStyle(color: Colors.white70, fontSize: 15, height: 1.5),
              ),
            ],
            if (record.notes?.isNotEmpty == true) ...[
              const SizedBox(height: 24),
              const _SectionTitle('NOTES'),
              const SizedBox(height: 8),
              Text(
                record.notes!,
                style: const TextStyle(color: Colors.white70, fontSize: 15, height: 1.5),
              ),
            ],
            const SizedBox(height: 40),
            Center(
              child: Text(
                'The instrument is tuned.',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.2),
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
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
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFFD4AF37),
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
      ),
    );
  }
}
