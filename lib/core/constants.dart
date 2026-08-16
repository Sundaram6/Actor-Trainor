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

class BlockConfig {
  final String id;
  final String name;
  final int durationMinutes;
  final String tag;
  final String description;

  const BlockConfig({
    required this.id,
    required this.name,
    required this.durationMinutes,
    required this.tag,
    required this.description,
  });
}

const List<BlockConfig> kRoutineBlocks = [
  BlockConfig(
    id: 'blockBreath',
    name: 'Breath Fundamentals',
    durationMinutes: 10,
    tag: 'BREATH',
    description: 'Diaphragmatic breathing, rib expansion, and breath control. The foundation for voice work and emotional access. Focus on deep, silent inhalation and controlled exhalation.',
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
    description: 'Private moment, emotional recall, and "as-if" exercises. Accesses truthful feeling without forcing emotion. Allow the body to respond naturally to the stimulus.',
  ),
  BlockConfig(
    id: 'blockContinuity',
    name: 'Continuity of Thought',
    durationMinutes: 15,
    tag: 'MIND',
    description: 'Stream of consciousness and inner monologue work. Maintains active listening and a continuous thought line. Never let the mind go blank between lines.',
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
