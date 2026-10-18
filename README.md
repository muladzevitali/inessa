# Inessa 🇵🇱

**Inessa** is a native SwiftUI iPhone app for learning Polish. It is inspired by the daily vocabulary and Lock Screen widget learning pattern, with its own design and implementation.

## MVP features

- **Word of the day** with English translation and Polish example sentence
- **Lock Screen widgets** (inline, rectangular, circular) and Home Screen widgets
- **96 starter words**, organized by A1, A2 and B1 with topic categories
- **Tap-to-reveal flashcards** and Polish speech playback
- **10-question multiple-choice quizzes** with instant feedback
- **Searchable library** with favorites and learned-word status
- **Progress dashboard**: daily target, study streak, learned words and quiz accuracy
- **Private, offline-friendly progress** stored locally on the iPhone (UserDefaults)

## Requirements

- Mac with Xcode 16 or later
- iPhone or simulator on iOS 17 or later
- XcodeGen, installed using Homebrew: brew install xcodegen
- For a physical device: a signing team in your Xcode settings

## Open and run

Run these commands on your Mac:

~~~bash
git clone https://github.com/muladzevitali/inessa.git
cd inessa
brew install xcodegen
xcodegen generate
open Inessa.xcodeproj
~~~

In Xcode select the **Inessa** scheme and a simulated iPhone, then press Command + R. The widget extension is embedded with the app.

To use a physical iPhone, configure your signing team for both Inessa and InessaWidget under Signing & Capabilities. If the default bundle IDs are unavailable, change them in project.yml and regenerate.

The Xcode project is generated from project.yml. Run xcodegen generate whenever you change the XcodeGen configuration.

## Add the Lock Screen widget

1. Open Inessa once after installation.
2. Long-press the Lock Screen, choose Customize, then Lock Screen.
3. Tap the widget region, search for Inessa, and add the rectangular or inline widget.
4. The next word is requested at local midnight. iOS may delay widget refresh.

The app and widget calculate the same daily word from a shared vocabulary collection. No App Group capability is required. The widget does not display the device's learned status.

## Code layout

~~~text
Inessa/
  InessaApp.swift
  Design/AppTheme.swift
  Models/StudyStore.swift
  Services/PronunciationService.swift
  Views/TodayView.swift
  Views/FlashcardsView.swift
  Views/QuizView.swift
  Views/LibraryView.swift
  Views/InsightsView.swift
InessaWidget/InessaWidget.swift
Shared/PolishWord.swift
Shared/Vocabulary.swift
InessaTests/VocabularyTests.swift
project.yml
.github/workflows/ios-build.yml
~~~

## Limitations and roadmap

The 96 words are an illustrative starter deck, not a complete Polish curriculum. Have a fluent Polish speaker review examples and translations before commercial release. iOS text-to-speech availability and voices vary by installed system resources.

No login, subscriptions, push notifications, server or analytics are included. Learning state stays on this device; deleting the app deletes progress.

Planned extensions: SRS flashcards, pronunciation recording, writing practice, better onboarding, a reviewed A1-B1 curriculum, reminders and optional iCloud sync.

## Building in CI

GitHub Actions uses macOS, XcodeGen and xcodebuild to build for a generic iPhone Simulator. No code signing required for simulator builds.
