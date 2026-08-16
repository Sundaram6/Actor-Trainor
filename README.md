# The Instrument 🎭

> **A privacy-first, local-only actor training companion.**  
> Dark-first, gold-accented, single-user, zero cloud. Built to sharpen the actor's instrument through disciplined daily practice.

---

## 🌟 Overview

**The Instrument** is a specialized mobile application crafted specifically for actors. It structures and guides a comprehensive **112-minute, 9-block daily morning routine** spanning breathwork, vocal resonance, sense memory, emotional preparation, character embodiment, text work, and cool-down.

Everything is stored strictly on-device using a local SQLite database. No accounts, no trackers, no cloud sync—pure focus on the craft.

---

## 🧠 The 9 Training Blocks (112 Minutes)

| # | Block Name | Duration | Category | Focus |
|---|---|---|---|---|
| **1** | **Breath Fundamentals** | 10 min | `BREATH` | Diaphragmatic breathing, rib expansion, and breath control. |
| **2** | **Physical Warm-up** | 10 min | `BODY` | Joint rotations, spine alignment, and body awareness. |
| **3** | **Memory Foundation** | 15 min | `MEMORY` | Sense memory exercises and sensory instrument recall. |
| **4** | **Voice & Resonance** | 15 min | `VOICE` | Vocal warm-ups, articulation drills, and resonance placement. |
| **5** | **Emotional Preparation** | 12 min | `EMOTION` | Private moment, emotional recall, and "as-if" exercises. |
| **6** | **Continuity of Thought** | 15 min | `MIND` | Stream of consciousness and continuous inner monologue. |
| **7** | **Character Embodiment** | 12 min | `CHARACTER` | Physical transformation, center of gravity shifts, character walk. |
| **8** | **Cold Reading / Text Work** | 13 min | `TEXT` | Sight-reading, script analysis, and beat scoring. |
| **9** | **Integration & Cool-down** | 10 min | `INTEGRATION` | Breath reset, reflection, and releasing character tension. |

---

## ✨ Key Features

- 📅 **Today Dashboard**: Real-time morning routine status (`NOT STARTED` / `COMPLETED`), week/day progression indicator, and live Evening Load card.
- ⏱️ **Active Session Timer**: 72pt digital countdown display, linear routine progress bar, play/pause controls, skip navigation, and "Up Next" preview.
- 🔔 **Harmonic Sound Cues**: Gentle harmonic meditation chime on every block transition and upon final session completion.
- 🏆 **Celebratory Completion Screen**: Post-routine recap displaying completed blocks (`9/9`), total minutes (`112 min`), and one-tap return to Today.
- 📖 **Block Detail Guides**: In-depth technique descriptions with ability to **"Start From This Block"** directly into the session player.
- 📊 **Progress & Analytics Dashboard**: Real-time calculated streak counter, total sessions, cumulative minutes logged, 7-day weekly completion checkmark grid, and session history log.
- ✍️ **Evening Load Editor**: Distraction-free script preparation editor to paste, review, and persist tomorrow's lines and scene prep notes.
- ⏰ **Daily 7:00 AM Reminders**: Local notification scheduling with timezone awareness and exact alarm / reboot resilience.
- 🛡️ **Zero Cloud & Instant Data Reset**: Local-only SQLite storage via Drift with an optional one-tap full progress reset.

---

## 🛠️ Technology Stack

- **Framework**: [Flutter](https://flutter.dev/) (Material 3 Dark Theme)
- **State Management**: [Riverpod 2.5](https://riverpod.dev/) (`flutter_riverpod`)
- **Local Database**: [Drift](https://drift.simonbinder.eu/) + [sqlite3_flutter_libs](https://pub.dev/packages/sqlite3_flutter_libs) + `drift_flutter`
- **Audio Engine**: [Audioplayers](https://pub.dev/packages/audioplayers)
- **Notifications**: [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications) + [timezone](https://pub.dev/packages/timezone)
- **Design Tokens**: Dark Luxury Palette (`#0A0A0F` Obsidian Background, `#1A1A24` Card Surface, `#D4AF37` Gold Accent, `#F5F5F0` Text).

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>= 3.4.0)
- Android SDK (API Level 21+) / JDK 17
- Dart SDK (>= 3.4.0)

### Installation & Run

1. **Clone the repository:**
   ```bash
   git clone https://github.com/Sundaram6/Actor-Trainor.git
   cd Actor-Trainor
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Generate Drift SQLite code (if modifying schema):**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Run on connected Android device or emulator:**
   ```bash
   flutter run
   ```

5. **Build Debug APK:**
   ```bash
   flutter build apk --debug
   ```

---

## 🔒 Privacy & Architecture

The Instrument requires no network permissions. All user data (session timestamps, daily progress, streak computations, and evening script text) resides exclusively in the app's sandboxed SQLite database file (`instrument_db`).
