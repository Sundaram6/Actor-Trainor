import 'package:flutter/material.dart';
import '../core/constants.dart';
import 'block_detail_screen.dart';

class RoutineScreen extends StatelessWidget {
  const RoutineScreen({super.key});

  static const List<Map<String, dynamic>> _blocks = [
    {
      'name': 'Breath Fundamentals',
      'duration': 10,
      'tag': 'BREATH',
      'desc': 'Diaphragmatic breathing, rib expansion, and breath control. The foundation for voice work and emotional access. Focus on deep, silent inhalation and controlled exhalation.',
    },
    {
      'name': 'Physical Warm-up',
      'duration': 10,
      'tag': 'BODY',
      'desc': 'Joint rotations, spine alignment, and body awareness. Prevents injury and centers physical presence. Move from the extremities toward the core.',
    },
    {
      'name': 'Memory Foundation',
      'duration': 15,
      'tag': 'MEMORY',
      'desc': 'Sense memory exercises and personal object recall. Builds the actor\'s sensory instrument. Recall a specific smell, texture, or sound with full sensory detail.',
    },
    {
      'name': 'Voice & Resonance',
      'duration': 15,
      'tag': 'VOICE',
      'desc': 'Vocal warm-ups, articulation drills, and resonance placement. Frees the natural voice. Work through lip trills, tongue twisters, and pitch variation.',
    },
    {
      'name': 'Emotional Preparation',
      'duration': 12,
      'tag': 'EMOTION',
      'desc': 'Private moment, emotional recall, and "as-if" exercises. Accesses truthful feeling without forcing emotion. Allow the body to respond naturally to the stimulus.',
    },
    {
      'name': 'Continuity of Thought',
      'duration': 15,
      'tag': 'MIND',
      'desc': 'Stream of consciousness and inner monologue work. Maintains active listening and a continuous thought line. Never let the mind go blank between lines.',
    },
    {
      'name': 'Character Embodiment',
      'duration': 12,
      'tag': 'CHARACTER',
      'desc': 'Physical transformation, center of gravity shifts, and character walk. Embodies the role physically before intellectualizing it. Find the body first.',
    },
    {
      'name': 'Cold Reading / Text Work',
      'duration': 13,
      'tag': 'TEXT',
      'desc': 'Sight-reading, script analysis, and scoring. Develops text handling skills under pressure. Look for operative words and beats in the scene.',
    },
    {
      'name': 'Integration & Cool-down',
      'duration': 10,
      'tag': 'INTEGRATION',
      'desc': 'Breath reset, reflection, and journaling. Consolidates the work and releases tension. Leave the character in the room, take the learning with you.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final total = _blocks.fold<int>(0, (s, b) => s + (b['duration'] as int));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            pinned: true,
            title: Text('ROUTINE', style: AppTextStyles.h1.copyWith(color: AppColors.goldAccent)),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(28),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text('$total MINUTES • 9 BLOCKS', style: AppTextStyles.caption),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) => _BlockCard(
                  index: i,
                  data: _blocks[i],
                  description: _blocks[i]['desc'] as String,
                ),
                childCount: _blocks.length,
              ),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
        ],
      ),
    );
  }
}

class _BlockCard extends StatelessWidget {
  final int index;
  final Map<String, dynamic> data;
  final String description;
  const _BlockCard({
    required this.index,
    required this.data,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlockDetailScreen(
              index: index,
              name: data['name'] as String,
              duration: data['duration'] as int,
              tag: data['tag'] as String,
              description: description,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.goldAccent.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: AppTextStyles.h2.copyWith(color: AppColors.goldAccent, fontSize: 18),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['name'] as String,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${data['duration']} MIN • ${data['tag']}',
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.goldAccent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.goldAccent.withValues(alpha: 0.3)),
              ),
              child: Text(
                'PENDING',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.goldAccent,
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
