# The Instrument — Comprehensive App Checklist 🎭

> **Quality Assurance, Feature Verification & Production Readiness Checklist**  
> *The Instrument* — Privacy-First, Local-Only Actor Training Companion.

---

## 🏛️ 1. Core Architecture & Philosophy Checklist

- [x] **Privacy-First & Local-Only**: Zero cloud dependencies, zero external tracking, zero analytics beacons.
- [x] **Offline-First Persistence**: Powered entirely by local SQLite using Drift (`drift_flutter` + `sqlite3_flutter_libs`).
- [x] **Dark Luxury Aesthetic**: Obsidian background (`#0A0A0F`), dark card surfaces (`#1A1A24`), border accents (`#2A2A38`), gold highlights (`#D4AF37`), and off-white typography (`#F5F5F0`).
- [x] **8px Grid System**: Consistent spacing (`8px`, `16px`, `24px`, `32px`, `48px`) across all views.
- [x] **Riverpod State Management**: Reactive UI updates powered by `StateNotifierProvider` / `FutureProvider` invalidation.
- [x] **Static Analysis Clean**: Zero lint warnings or deprecated API calls under Flutter strict lints.

---

## 📱 2. Four-Tab Shell & Navigation Checklist

### Tab 1 — Today Screen (`lib/screens/today_screen.dart`)
- [x] **Sliver App Bar**: Displays `TODAY` header and current date (e.g. `WEEK 1 • DAY 1 • SUN, AUG 16`).
- [x] **Live Routine Status Chip**:
  - [x] Displays `MORNING ROUTINE: NOT STARTED` with gold outlined container when today has no completed session.
  - [x] Reactively flips to `MORNING ROUTINE: COMPLETED` with solid gold filled badge when routine completes.
- [x] **Start Routine CTA**: Full-width gold elevated button launching `SessionScreen`.
- [x] **Live Evening Load Card**:
  - [x] Shows `Evening Load: Not Set` with gray circle indicator when no text is saved for today.
  - [x] Shows `Evening Load: Set` with gold checkmark and 2-line snippet preview when notes/script exist.
  - [x] Tapping the card opens `EveningLoadScreen`.

### Tab 2 — Routine Screen (`lib/screens/routine_screen.dart`)
- [x] **Header**: Displays `ROUTINE` with total duration summary (`112 MINUTES • 9 BLOCKS`).
- [x] **9 Fixed Training Blocks**:
  1. `Breath Fundamentals` (10 min • `BREATH`)
  2. `Physical Warm-up` (10 min • `BODY`)
  3. `Memory Foundation` (15 min • `MEMORY`)
  4. `Voice & Resonance` (15 min • `VOICE`)
  5. `Emotional Preparation` (12 min • `EMOTION`)
  6. `Continuity of Thought` (15 min • `MIND`)
  7. `Character Embodiment` (12 min • `CHARACTER`)
  8. `Cold Reading / Text Work` (13 min • `TEXT`)
  9. `Integration & Cool-down` (10 min • `INTEGRATION`)
- [x] **Card UI**: Numbered badge, title, subtitle (`$duration MIN • $tag`), and `PENDING` pill.
- [x] **Interactivity**: Tapping any block navigates directly to `BlockDetailScreen`.

### Tab 3 — Progress Screen (`lib/screens/progress_screen.dart`)
- [x] **Header**: Displays `PROGRESS` title with `YOUR JOURNEY` section header.
- [x] **Stat Cards Grid**:
  - [x] `STREAK`: Current consecutive completed days counter.
  - [x] `SESSIONS`: Total lifetime sessions completed.
  - [x] `TOTAL TIME`: Cumulative practice minutes logged.
- [x] **Weekly Completion Grid (`THIS WEEK`)**:
  - [x] 7-column calendar row (`M`, `T`, `W`, `T`, `F`, `S`, `S`).
  - [x] Gold filled circle with checkmark for completed days.
  - [x] Dark circle outline for incomplete/future days.
- [x] **Recent History (`RECENT SESSIONS`)**:
  - [x] Chronological list of completed sessions with formatted date, block count (`9/9`), and time (`112 min`).
  - [x] Empty state fallback (`No sessions completed yet`) when database is fresh or reset.

### Tab 4 — Settings Screen (`lib/screens/settings_screen.dart`)
- [x] **Header**: Displays `SETTINGS` title.
- [x] **Preferences Section**:
  - [x] `Daily Reminders` switch toggle: Schedules or cancels 7:00 AM notification.
  - [x] `Sound Cues` switch toggle: Enables/disables transition audio chimes.
- [x] **About Section**:
  - [x] Version row (`1.0.0`).
  - [x] Total Routine Time (`112 minutes`).
  - [x] Training Blocks count (`9 blocks`).
- [x] **Data Section**:
  - [x] `Reset All Progress` row with red accent styling.
  - [x] Confirmation dialog (`Reset Progress? This cannot be undone`).
  - [x] Wipes SQLite tables (`sessions`, `dailyProgress`, `eveningLoads`).
  - [x] Invalidates Riverpod providers and shows confirmation SnackBar.
- [x] **Footer Branding**: `THE INSTRUMENT` • `Built for actors. Privacy-first. Local-only.`

---

## ⏱️ 3. Training Player & Flow Checklist

### Active Session Screen (`lib/screens/session_screen.dart`)
- [x] **Linear Progress Bar**: Reflects overall elapsed time across all 9 blocks (0.0 to 1.0).
- [x] **Block Header**: Shows `BLOCK X OF 9`.
- [x] **Numbered Badge**: Large circular gold badge with active block number.
- [x] **Block Info**: Active block title and duration in minutes.
- [x] **Digital Countdown Timer**: Large 72pt monospace display (`MM:SS`).
- [x] **Controls**:
  - [x] Play / Pause toggle with auto-countdown.
  - [x] Next / Skip button advancing immediately to the next block.
  - [x] Checkmark button on final block (Block 9) completing the session.
- [x] **Up Next Card**: Displays upcoming block number and title (hidden on block 9).
- [x] **Sound Cue**: Triggers bell chime on every transition.
- [x] **Start From Block Support**: Constructor accepts `startBlockIndex` (defaults to 0).

### Block Detail Screen (`lib/screens/block_detail_screen.dart`)
- [x] **App Bar**: Back arrow button popping to Routine list.
- [x] **Block Header**: Large number badge, block name, duration, and category tag.
- [x] **Technique Guide**: `ABOUT THIS BLOCK` gold label with full pedagogical instructions.
- [x] **Direct Launch Action**: `START FROM THIS BLOCK` button navigating directly into `SessionScreen` at the chosen block index.

### Session Complete Celebration Screen (`lib/screens/session_complete_screen.dart`)
- [x] **Celebration Badge**: Circular gold checkmark badge.
- [x] **Headline**: `ROUTINE COMPLETE` with subtitle `You completed all 9 training blocks.`.
- [x] **Summary Card**:
  - [x] `9/9` BLOCKS completed.
  - [x] `112` MINUTES logged.
- [x] **Back Action**: `BACK TO TODAY` full-width gold button popping back to root and invalidating providers.

### Evening Load Screen (`lib/screens/evening_load_screen.dart`)
- [x] **App Bar**: Back button and gold `SAVE` text button.
- [x] **Editor Card**: Dark surface card with auto-focused multi-line TextField.
- [x] **Pre-population**: Loads existing saved notes for today's date if already present.
- [x] **Persistence**: Saves to `EveningLoads` Drift table upon tapping `SAVE`.

---

## 🗄️ 4. Local Database (Drift / SQLite) Checklist

### Tables & Schema (`lib/database/database.dart`)
- [x] `Sessions` Table: `id` (autoIncrement), `date`, `blocksCompleted`, `totalMinutes`, `isComplete`.
- [x] `DailyProgress` Table: `date` (primaryKey), `completed`, `minutesLogged`.
- [x] `EveningLoads` Table: `date` (primaryKey), `scriptText`, `createdAt`.

### Database Operations
- [x] `insertSession(SessionsCompanion session)`: Appends completed session record.
- [x] `getTotalSessions()`: Counts total session entries.
- [x] `getTotalMinutes()`: Sums total minutes across sessions.
- [x] `getCurrentStreak()`: Computes uninterrupted consecutive daily practice streak.
- [x] `getRecentSessions({int limit = 5})`: Retrieves recent session history chronologically.
- [x] `upsertDayProgress(DailyProgressCompanion progress)`: Upserts daily completion flag.
- [x] `getDayProgress(DateTime date)`: Fetches specific day record.
- [x] `getWeekProgress(DateTime startOfWeek)`: Returns 7-day boolean completion list.
- [x] `upsertEveningLoad(EveningLoadsCompanion load)`: Upserts evening script text.
- [x] `getEveningLoad(DateTime date)`: Retrieves evening script text for given date.

---

## 🔔 5. Background Services & Permissions Checklist

### Sound Service (`lib/services/sound_service.dart`)
- [x] Bundled audio asset: `assets/sounds/bell.mp3`.
- [x] `SoundService.playBell()` handles audio playback via `audioplayers`.
- [x] Test-environment flag (`SoundService.enabled`) for headless regression stability.

### Daily Reminders (`lib/services/notification_service.dart`)
- [x] Initialized via `tz_data.initializeTimeZones()` and `FlutterLocalNotificationsPlugin`.
- [x] `scheduleDailyReminder({required bool enabled})` computes next 7:00 AM instance (`_nextInstanceOf7AM`).
- [x] Configured with `Importance.high`, `Priority.high`, and `AndroidScheduleMode.exactAllowWhileIdle`.
- [x] `android/app/src/main/AndroidManifest.xml` permissions:
  - [x] `android.permission.RECEIVE_BOOT_COMPLETED`
  - [x] `android.permission.SCHEDULE_EXACT_ALARM`
  - [x] `android.permission.USE_EXACT_ALARM`
- [x] Android broadcast receivers registered for reboot persistence:
  - [x] `com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver`
  - [x] `com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver`

---

## 🧪 6. Testing & Quality Assurance Checklist

- [x] **Static Analysis**: `flutter analyze` passes with **0 issues**.
- [x] **Headless Widget Tests**: `test/screenshot_test.dart` passes all tests.
- [x] **Font & Visual Fidelity**: Real Roboto typography and MaterialIcons loaded during test renders.
- [x] **Build Verification**: `flutter build apk --debug` builds successfully with 0 errors.
- [x] **Visual Snapshots Verified**:
  - [x] Today Screen (`today_screen.png`, `today_completed.png`, `today_evening_load_set.png`)
  - [x] Routine Tab (`routine_tab.png`)
  - [x] Progress Tab (`progress_tab.png`, `progress_completed.png`, `progress_after_reset.png`)
  - [x] Settings Tab (`settings_tab.png`, `settings_reminders_on.png`)
  - [x] Session Screen (`session_screen.png`)
  - [x] Session Complete Screen (`session_complete_screen.png`)
  - [x] Block Detail Screen (`block_detail_screen.png`)
  - [x] Evening Load Screen (`evening_load_screen.png`)

---

## 🔮 7. Future Feature Roadmap (Backlog)

- [ ] **Custom Block Timers**: Allow actors to customize durations for individual training blocks.
- [ ] **Line Teleprompter Mode**: In-app line memorization view for Evening Load scene text with variable scroll speed.
- [ ] **Voice Note Recorder**: On-device audio journaling for emotional recall and vocal exploration.
- [ ] **Encrypted Backup & Restore**: Export/import local SQLite database to encrypted backup file.
- [ ] **Ambient Soundscapes**: Built-in background brown noise / binaural beats option during focus blocks.
