import 'package:flutter/material.dart';

// --- AppColors ---
abstract class AppColors {
  static const Color background = Color(0xFF0A0A0F);
  static const Color cardSurface = Color(0xFF1A1A24);
  static const Color cardBorder = Color(0xFF2A2A38);
  static const Color goldAccent = Color(0xFFD4AF37);
  static const Color textPrimary = Color(0xFFF5F5F0);
  static const Color primaryText = Color(0xFFF5F5F0);
  static const Color textSecondary = Color(0xFF8A8A8A);
  static const Color secondaryText = Color(0xFF8A8A8A);
  static const Color errorCritical = Color(0xFFE53935);
  static const Color success = Color(0xFF43A047);
}

// Top-level color aliases
const Color background = AppColors.background;
const Color cardSurface = AppColors.cardSurface;
const Color cardBorder = AppColors.cardBorder;
const Color goldAccent = AppColors.goldAccent;
const Color primaryText = AppColors.primaryText;
const Color textPrimary = AppColors.textPrimary;
const Color secondaryText = AppColors.secondaryText;
const Color textSecondary = AppColors.textSecondary;
const Color errorCritical = AppColors.errorCritical;
const Color success = AppColors.success;

// --- Block IDs ---
const String blockArrival = 'blockArrival';
const String blockMobility = 'blockMobility';
const String blockBreathLab = 'blockBreathLab';
const String blockAttention = 'blockAttention';
const String blockVoice = 'blockVoice';
const String blockRhythm = 'blockRhythm';
const String blockDialogue = 'blockDialogue';
const String blockImagination = 'blockImagination';
const String blockCamera = 'blockCamera';

// --- Block Durations (total 106 minutes) ---
const Map<String, int> blockDurations = {
  blockArrival: 3,
  blockMobility: 15,
  blockBreathLab: 20,
  blockAttention: 12,
  blockVoice: 14,
  blockRhythm: 8,
  blockDialogue: 13,
  blockImagination: 11,
  blockCamera: 10,
};

// --- AppTextStyles ---
abstract class AppTextStyles {
  static const TextStyle h1 = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: goldAccent,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: primaryText,
  );

  static const TextStyle body = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 16,
    color: primaryText,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 12,
    color: secondaryText,
  );
}

// Top-level typography aliases
const TextStyle h1 = AppTextStyles.h1;
const TextStyle h2 = AppTextStyles.h2;
const TextStyle body = AppTextStyles.body;
const TextStyle caption = AppTextStyles.caption;

// --- UI Strings ---
const String appTitle = 'THE INSTRUMENT';
const String tabToday = 'Today';
const String tabRoutine = 'Routine';
const String tabProgress = 'Progress';
const String tabSettings = 'Settings';

const String weekNumberDefault = '1';
const String weekDayDefault = 'Week 1 \u2022 Day 1';
const String morningRoutineNotStarted = 'MORNING ROUTINE: NOT STARTED';
const String startRoutineButton = 'START ROUTINE';
const String eveningLoadNotSet = 'Evening Load: Not Set';
const String eveningLoadSubtitle = "Tap to prepare tomorrow's lines";

class SubStep {
  final String title;
  final String instruction;
  final int durationSeconds;

  const SubStep({
    required this.title,
    required this.instruction,
    required this.durationSeconds,
  });
}

class BlockConfig {
  final String id;
  final String name;
  final int durationMinutes;
  final String tag;
  final String description;
  final List<SubStep>? subSteps;

  const BlockConfig({
    required this.id,
    required this.name,
    required this.durationMinutes,
    required this.tag,
    required this.description,
    this.subSteps,
  });
}

const List<BlockConfig> kRoutineBlocks = [
  BlockConfig(
    id: 'blockBreath',
    name: 'Breath Lab',
    durationMinutes: 10,
    tag: 'BREATH',
    description: 'Four-stage breath instrument: diaphragmatic, rib expansion, control, and silent inhalation. The foundation for voice and emotional access.',
    subSteps: [
      SubStep(
        title: 'Diaphragmatic Breathing',
        instruction: 'Place one hand on your belly, one on your chest. Breathe so only the belly hand moves. Complete 10 silent cycles.',
        durationSeconds: 150,
      ),
      SubStep(
        title: 'Rib Expansion',
        instruction: 'Shift focus to lateral expansion of the lower ribs. Feel the intercostals stretch on inhale. 10 cycles.',
        durationSeconds: 150,
      ),
      SubStep(
        title: 'Breath Control',
        instruction: 'Inhale for 4 counts. Hold for 4. Exhale for 6. Extend the exhale by 1 count each round until you reach 10.',
        durationSeconds: 150,
      ),
      SubStep(
        title: 'Silent Inhalation',
        instruction: 'Breathe so quietly that someone beside you would not know you are breathing. 10 cycles. No sound on inhale or exhale.',
        durationSeconds: 150,
      ),
    ],
  ),
  BlockConfig(
    id: 'blockBody',
    name: 'Physical Warm-up',
    durationMinutes: 10,
    tag: 'BODY',
    description: 'Joint rotations, spine alignment, and body awareness. Prevents injury and centers physical presence. Move from the extremities toward the core.',
  ),
  BlockConfig(
    id: 'blockMemory',
    name: 'Memory Foundation',
    durationMinutes: 15,
    tag: 'MEMORY',
    description: 'Sense memory exercises and personal object recall. Builds the actor\'s sensory instrument. Recall a specific smell, texture, or sound with full sensory detail.',
  ),
  BlockConfig(
    id: 'blockVoice',
    name: 'Voice & Resonance',
    durationMinutes: 15,
    tag: 'VOICE',
    description: 'Vocal warm-ups, articulation drills, and resonance placement. Frees the natural voice. Work through lip trills, tongue twisters, and pitch variation.',
  ),
  BlockConfig(
    id: 'blockEmotion',
    name: 'Emotional Preparation',
    durationMinutes: 12,
    tag: 'EMOTION',
    description: 'Three-step emotional preparation: imagination, circumstances, exit ritual. Choose your method — Adler (given circumstances) or Strasberg (affective memory).',
    subSteps: [
      SubStep(
        title: 'Imagination — The "As-If"',
        instruction: 'Adler: What are the given circumstances? Who am I? Where am I? What do I want? State it in one sentence. Strasberg: Choose a personal memory that carries the same emotional temperature as the scene. Do not force the feeling — let the memory do the work.',
        durationSeconds: 240,
      ),
      SubStep(
        title: 'Circumstances — Deepening',
        instruction: 'Adler: Add sensory specifics. What time of day? What is the weather? What did you eat for breakfast? The more specific, the more truthful. Strasberg: Relive the memory through the five senses. Smell, taste, texture, sound, sight. Do not watch yourself — be inside it.',
        durationSeconds: 240,
      ),
      SubStep(
        title: 'Exit Ritual — Release',
        instruction: 'Both methods: Shake the hands vigorously. Take three sharp exhales through the mouth. Touch the floor. The emotion is a tool, not a tattoo. Leave it in the room. Do not carry it into your day.',
        durationSeconds: 240,
      ),
    ],
  ),
  BlockConfig(
    id: 'blockContinuity',
    name: 'Continuity of Thought',
    durationMinutes: 15,
    tag: 'MIND',
    description: 'Six-anchor continuity game. Hold a continuous stream of consciousness while weaving in concrete sensory images. Do not let the mind go blank between anchors.',
    subSteps: [
      SubStep(
        title: 'Anchor 1 — The Red Door',
        instruction: 'A red door you have never opened. Keep talking. Do not stop. Let the image lead you.',
        durationSeconds: 150,
      ),
      SubStep(
        title: 'Anchor 2 — Mother\'s Voice',
        instruction: 'The sound of your mother saying your name. Weave it into the stream without breaking the thread.',
        durationSeconds: 150,
      ),
      SubStep(
        title: 'Anchor 3 — Rain on Asphalt',
        instruction: 'The smell of rain on hot asphalt. Stay in the stream. Let the sensory memory carry the thought forward.',
        durationSeconds: 150,
      ),
      SubStep(
        title: 'Anchor 4 — Stone in Palm',
        instruction: 'The weight of a cold stone in your palm. Keep the monologue alive. No blanks.',
        durationSeconds: 150,
      ),
      SubStep(
        title: 'Anchor 5 — Empty Room Clock',
        instruction: 'A clock ticking in an empty room. Maintain continuity. The thought must not die.',
        durationSeconds: 150,
      ),
      SubStep(
        title: 'Anchor 6 — Childhood Taste',
        instruction: 'The taste of something you loved as a child. Ride it to the end. Finish the 15 minutes unbroken.',
        durationSeconds: 150,
      ),
    ],
  ),
  BlockConfig(
    id: 'blockCharacter',
    name: 'Character Embodiment',
    durationMinutes: 12,
    tag: 'CHARACTER',
    description: 'Physical transformation, center of gravity shifts, and character walk. Embodies the role physically before intellectualizing it. Find the body first.',
  ),
  BlockConfig(
    id: 'blockColdRead',
    name: 'Cold Reading / Text Work',
    durationMinutes: 13,
    tag: 'TEXT',
    description: 'Sight-reading, script analysis, and scoring. Develops text handling skills under pressure. Look for operative words and beats in the scene.',
  ),
  BlockConfig(
    id: 'blockIntegration',
    name: 'Integration & Cool-down',
    durationMinutes: 10,
    tag: 'INTEGRATION',
    description: 'Breath reset, reflection, and journaling. Consolidates the work and releases tension. Leave the character in the room, take the learning with you.',
  ),
];
