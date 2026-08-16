# Changelog

All notable changes to **The Instrument** are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.1.0] - 2026-08-16

### Deep Exercise Mechanics & Dedicated Session Completion

#### Added
- **Single Source of Truth (`kRoutineBlocks`) (Micro-Phases 16a–16c)**
  - Unified routine configuration and metadata in `lib/core/constants.dart`.
  - Wired Routine screen, Block Detail screen, and Session timer engine to consume `kRoutineBlocks`.
- **Guided Exercise Sub-Steps & Live Instructions (Micro-Phases 17a–18d)**
  - **Breath Lab (Block 1)**: 4 guided sub-steps (Diaphragmatic Breathing, Rib Expansion, Breath Control, Silent Inhalation).
  - **Emotional Preparation (Block 5)**: 3-step Adler given circumstances vs. Strasberg affective memory sequence + exit ritual.
  - **Continuity of Thought (Block 6)**: 3-stage stream-of-consciousness, dual awareness, and character entry internal monologue.
  - **Character Embodiment (Block 7)**: 3-stage physical center/gait, vocal texture/rhythm, and full integration.
  - **Cold Reading / Text Work (Block 8)**: 3-stage first impulse cold take, script scoring/subtext, and text living integration.
  - **Integration & Cool-down (Block 9)**: 3-stage de-roling grounding, silent reflection, and releasing breaths.
- **Dedicated Session Completion Screen (Micro-Phase 19)**
  - Created `SessionCompletionScreen` featuring gold checkmark, blocks completed card (`9 / 9`), total duration card (`98 min`), and closed status.
  - "Return to Dashboard" action clearing back-stack and refreshing Riverpod stats providers.

---

## [1.0.0] - 2026-08-16

### Initial Release - Full Local Actor Training Companion

#### Added
- **Core Architecture & Shell (Micro-Phase 1)**
  - Initialized Flutter scaffold with dark luxury palette (`#0A0A0F` background, `#D4AF37` gold accent).
  - Configured 4-tab bottom navigation shell (`Today`, `Routine`, `Progress`, `Settings`).
  - Added typography standards, theme configurations, and core layout components.
- **Routine Tab (Micro-Phase 2)**
  - Created 9-block training list with block numbering badges, duration chips, category tags, and pending status pills.
- **Active Session Timer (Micro-Phase 3)**
  - Implemented session countdown player with large 72pt digital timer, linear progress bar, play/pause controls, block skip, and "Up Next" preview.
- **Progress Screen (Micro-Phase 4)**
  - Implemented stats dashboard with Streak Days, Total Sessions, and Total Minutes cards.
  - Implemented 7-day weekly completion checkmark grid and chronological session history.
- **Settings Screen (Micro-Phase 5)**
  - Added Preferences toggles for Daily Reminders and Sound Cues.
  - Added About app metrics and Data Reset confirmation action.
- **Drift Local Database & Schema (Micro-Phase 6)**
  - Configured SQLite persistence with `Sessions` and `DailyProgress` tables.
  - Added query methods for totals, week ranges, and consecutive streak calculations.
- **Reactive Progress Wiring (Micro-Phase 7)**
  - Connected `ProgressScreen` to live Drift database queries via Riverpod `FutureProvider`s.
  - Added empty state handling for fresh installs.
- **Session Persistence & Today Live Status (Micro-Phase 8)**
  - Automatically writes completed sessions and daily progress records to SQLite upon finishing block 9.
  - Connected Today screen chip to reflect live `MORNING ROUTINE: COMPLETED` vs `NOT STARTED`.
- **Functional Progress Reset (Micro-Phase 9)**
  - Connected Settings reset dialog to wipe local database tables and reactively invalidate UI state across all tabs with SnackBar feedback.
- **Sound Cues & Chimes (Micro-Phase 10)**
  - Added harmonic meditation bell audio cue (`bell.mp3`) triggered on every block transition and on routine completion.
- **Evening Load Script Editor (Micro-Phase 11)**
  - Added `EveningLoads` Drift table and full-screen editor to write and persist tomorrow's scene lines and preparation notes.
  - Connected live Today card with checkmark and truncated script preview.
- **Session Celebration Screen (Micro-Phase 12)**
  - Added `SessionCompleteScreen` post-routine celebratory recap displaying completed block count and total logged minutes.
- **Block Detail Screen & Direct Jump (Micro-Phase 13)**
  - Created `BlockDetailScreen` with comprehensive technique descriptions for each of the 9 blocks.
  - Added "Start From This Block" button to launch active sessions at any chosen block.
- **Daily Reminders via Local Notifications (Micro-Phase 14)**
  - Integrated `flutter_local_notifications` and `timezone` to schedule 7:00 AM daily training reminders.
  - Added Android reboot and exact alarm broadcast receivers.
