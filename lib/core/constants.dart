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
