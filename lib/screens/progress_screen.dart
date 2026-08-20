import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:the_instrument/database/database.dart';
import 'package:the_instrument/providers/database_provider.dart';
import 'package:the_instrument/providers/progress_providers.dart';
import 'session_detail_screen.dart';

final sessionHistoryProvider = StreamProvider<List<SessionRecord>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.select(db.sessionRecords).watch();
});

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(sessionHistoryProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'PROGRESS',
          style: TextStyle(
            color: Color(0xFFD4AF37),
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
        ),
      ),
      body: historyAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: Color(0xFFD4AF37)),
        ),
        error: (err, _) => Center(
          child: Text('Error: $err', style: const TextStyle(color: Colors.white70)),
        ),
        data: (sessions) {
          if (sessions.isEmpty) {
            return const Center(
              child: Text(
                'No sessions yet.\nThe work begins with the first breath.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: sessions.length + 1,
            separatorBuilder: (context, index) => SizedBox(height: index == 0 ? 16 : 12),
            itemBuilder: (context, index) {
              if (index == 0) {
                return Consumer(
                  builder: (context, ref, child) {
                    final weeklyAsync = ref.watch(weeklyReportProvider);
                    return weeklyAsync.when(
                      data: (report) => _WeeklyReportCard(report: report),
                      loading: () => const SizedBox.shrink(),
                      error: (err, stack) => const SizedBox.shrink(),
                    );
                  },
                );
              }

              final session = sessions[sessions.length - index]; // newest first
              final date = session.completedAt;
              final formattedDate = DateFormat('EEE, MMM d').format(date);
              final formattedTime = DateFormat('h:mm a').format(date);

              List<String> outcomes = List.filled(9, 'pending');
              try {
                final List<dynamic> parsed = jsonDecode(session.blocksJson);
                if (parsed.isNotEmpty) {
                  outcomes = List<String>.generate(
                    9,
                    (i) {
                      if (i >= parsed.length) return 'pending';
                      final item = parsed[i];
                      if (item is Map) {
                        return (item['status'] as String?) ?? 'pending';
                      }
                      return item.toString();
                    },
                  );
                } else {
                  for (int i = 0; i < session.blocksCompleted.clamp(0, 9); i++) {
                    outcomes[i] = 'completed';
                  }
                }
              } catch (_) {
                for (int i = 0; i < session.blocksCompleted.clamp(0, 9); i++) {
                  outcomes[i] = 'completed';
                }
              }

              final completedCount = outcomes.where((o) => o == 'completed').length;
              final skippedCount = outcomes.where((o) => o == 'skipped').length;

              return Material(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => SessionDetailScreen(record: session),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF2A2A2A)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD4AF37).withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Color(0xFFD4AF37),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                formattedDate,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '$formattedTime · ${session.blocksCompleted} blocks · ${session.totalMinutes} min',
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 13,
                                ),
                              ),
                              if (session.intention?.isNotEmpty == true) ...[
                                const SizedBox(height: 6),
                                Text(
                                  '"${session.intention}"',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                              if (session.notes?.isNotEmpty == true) ...[
                                const SizedBox(height: 4),
                                Text(
                                  session.notes!,
                                  style: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 13,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                              const SizedBox(height: 10),
                              // 9-block completion bar
                              Row(
                                children: List.generate(9, (blockIndex) {
                                  final outcome = outcomes[blockIndex];
                                  Color barColor;
                                  switch (outcome) {
                                    case 'completed':
                                      barColor = const Color(0xFFD4AF37); // Gold
                                      break;
                                    case 'skipped':
                                      barColor = const Color(0xFF5C2A2A); // Dark Red
                                      break;
                                    default:
                                      barColor = const Color(0xFF2A2A2A); // Dark Grey
                                  }

                                  return Expanded(
                                    child: Container(
                                      height: 4,
                                      margin: EdgeInsets.only(right: blockIndex < 8 ? 2 : 0),
                                      decoration: BoxDecoration(
                                        color: barColor,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '9 blocks • $completedCount completed • $skippedCount skipped',
                                style: const TextStyle(
                                  color: Colors.white38,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

typedef _WeeklyReportCard = WeeklyReportCard;
typedef _MiniStat = MiniStat;

class WeeklyReportCard extends StatelessWidget {
  final WeeklyReport report;
  const WeeklyReportCard({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFD4AF37);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'THIS WEEK',
            style: TextStyle(color: gold, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1.2),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _MiniStat(label: 'SESSIONS', value: '${report.sessionsCompleted}'),
              const SizedBox(width: 12),
              _MiniStat(label: 'MINUTES', value: '${report.totalMinutes}'),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _MiniStat(label: 'COMPLETION', value: '${(report.completionRate * 100).toStringAsFixed(0)}%'),
              const SizedBox(width: 12),
              _MiniStat(
                label: 'MOST SKIPPED',
                value: report.mostSkippedBlock ?? '—',
                smallValue: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final bool smallValue;
  const MiniStat({super.key, required this.label, required this.value, this.smallValue = false});

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFD4AF37);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF0A0A0A),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: gold, fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 1),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: smallValue ? 13 : 18,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
