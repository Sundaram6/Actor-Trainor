import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/session_notes_provider.dart';
import 'session_detail_screen.dart';

class JournalScreen extends ConsumerWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const gold = Color(0xFFD4AF37);
    final journalAsync = ref.watch(allSessionNotesProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "ACTOR'S JOURNAL",
          style: TextStyle(
            color: gold,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white70, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: journalAsync.when(
          data: (entries) {
            if (entries.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text(
                    'Your journal is empty.\nComplete a session and reflect to build your practice log.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white24, fontSize: 16, height: 1.6),
                  ),
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: entries.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final entry = entries[index];
                final date = DateFormat('EEEE, MMM d').format(entry.session.completedAt);
                return GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => SessionDetailScreen(record: entry.session),
                    ),
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                date.toUpperCase(),
                                style: const TextStyle(
                                  color: gold,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            Text(
                              '${entry.session.totalMinutes} MIN · ${entry.session.blocksCompleted} BLOCKS',
                              style: const TextStyle(
                                color: Colors.white24,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        if (entry.session.roleTag != null && entry.session.roleTag!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0A0A0A),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: gold.withValues(alpha: 0.2)),
                            ),
                            child: Text(
                              entry.session.roleTag!.toUpperCase(),
                              style: const TextStyle(
                                color: gold,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            border: Border(
                              left: BorderSide(color: gold, width: 2),
                            ),
                          ),
                          padding: const EdgeInsets.only(left: 16, top: 4, bottom: 4),
                          child: Text(
                            entry.note,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator(color: gold)),
          error: (e, s) => const Center(
            child: Text(
              'Unable to load journal.',
              style: TextStyle(color: Colors.white24, fontSize: 14),
            ),
          ),
        ),
      ),
    );
  }
}
