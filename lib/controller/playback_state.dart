// lib/state/playback_state.dart
import '../models/track.dart';

/// This holds all the information about what's currently playing
class PlaybackState {
  final Track? currentTrack; // What song is playing? (null = nothing)
  final bool isPlaying; // Is it playing or paused?
  final Duration position; // How far into the song are we?

  PlaybackState({
    this.currentTrack,
    this.isPlaying = false,
    this.position = Duration.zero,
  });

  /// Create a new state with some values changed
  /// (We never modify state directly, we create a new copy)
  PlaybackState copyWith({
    Track? currentTrack,
    bool? isPlaying,
    Duration? position,
  }) {
    return PlaybackState(
      currentTrack: currentTrack ?? this.currentTrack,
      isPlaying: isPlaying ?? this.isPlaying,
      position: position ?? this.position,
    );
  }
}
