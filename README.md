# Custom Music Player

A Flutter music player app built with `flutter_bloc` (Cubit) for state management and `just_audio` for playback. This project is in early development — right now it can load and play a single audio file with play/pause/resume controls and a live position display.

## Features

**Working today:**
- Play, pause, and resume a track
- Live playback position display (MM:SS)
- Cross-platform Flutter app (Android, iOS, macOS, Windows, Linux, Web scaffolding included)

**Not implemented yet on `main`:**
- Track/library browsing — the UI currently plays a single hardcoded demo track (`player_screen.dart`) rather than letting you pick a file
- Seeking, skip next/previous, shuffle, repeat
- Playlists
- Persisted state (position/queue resets on restart)
- Metadata/artwork loading (the `Track` model has `artist`, `album`, and `duration` fields, but nothing currently populates them from real files)

**In progress on `feature/library` (not yet merged):** a much fuller experience is being built on this branch:
- Full device library scan via a custom Android `MediaStore` integration (`MediaStorePlugin.kt` + a `media_store` platform channel) — pulls title, artist, album, genre, duration, album ID, and date added for every audio file on the device
- Runtime storage/media permission requests (`permission_handler`)
- A Library tab with sorting (title, artist, album, duration, date added, file path — ascending/descending), with the chosen sort persisted via `shared_preferences`
- A search screen with search history
- A shuffle bar for jumping to a random track
- Album art loading per album ID
- A bottom-navigation shell (`MainScreen`) switching between Library and Player tabs

This branch's library scanning is **Android-only** for now — the `MediaStorePlugin` is registered only in the Android `MainActivity.kt`, with no iOS/desktop equivalent yet. Check it out with `git checkout feature/library` (or `git fetch origin feature/library` first if it's not local yet) to try it.

## Architecture

The app follows a simple layered structure on top of the BLoC pattern:

```
lib/
├── main.dart                          # App entry point; wires up dependencies
├── models/
│   └── track.dart                     # Track data model (id, title, filePath, artist, album, duration)
├── services/
│   └── audio_player_service.dart      # Thin wrapper around just_audio's AudioPlayer
├── controller/
│   ├── playback_controller.dart       # Cubit — exposes play/pause/resume, emits PlaybackState
│   └── playback_state.dart            # Immutable state: currentTrack, isPlaying, position
└── presentation/
    └── screens/
        └── player_screen.dart         # UI, rebuilds via BlocBuilder<PlaybackController, PlaybackState>
```

**Data flow:** `PlayerScreen` reads/dispatches through `PlaybackController` (a `Cubit`), which delegates actual audio playback to `AudioPlayerService` (a wrapper around `just_audio`) and emits a new `PlaybackState` on every change. The UI rebuilds automatically via `BlocBuilder`.

## Tech stack

| Purpose | Package |
|---|---|
| State management | [`flutter_bloc`](https://pub.dev/packages/flutter_bloc) (Cubit) |
| Audio playback | [`just_audio`](https://pub.dev/packages/just_audio) |
| Linting | `flutter_lints` |

Flutter SDK: `^3.10.1`

## Getting started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (channel: stable)
- A configured platform toolchain for whichever target you're running (Android Studio/SDK, Xcode, or desktop build tools)

### Install dependencies
```sh
flutter pub get
```

### Run the app
```sh
flutter run
```
Select a connected device/emulator, or a desktop/web target, when prompted.

> **Note:** The demo track path is currently hardcoded to `/storage/emulated/0/Music/demo.mp3` in [`player_screen.dart`](lib/presentation/screens/player_screen.dart) (an Android-style path). To try playback, place an MP3 at that path on your test device, or edit the path/track before running on another platform.

### Run tests
```sh
flutter test
```

### Analyze/lint
```sh
flutter analyze
```

## Platform support

Platform runner projects exist for Android, iOS, macOS, Windows, Linux, and Web, so `flutter run -d <platform>` should work out of the box for any of them, subject to the usual platform toolchain setup.
