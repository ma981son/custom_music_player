// lib/state/playback_controller.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/track.dart';
import '../services/audio_player_service.dart';
import 'playback_state.dart';

/// This manages the playback state and tells the UI when things change
/// Think of it as a "remote control" for your music player
class PlaybackController extends Cubit<PlaybackState> {
  final AudioPlayerService _audioService;

  PlaybackController(this._audioService) : super(PlaybackState()) {
    // Listen to the audio service for position updates
    // Whenever position changes, update our state
    _audioService.positionStream.listen((position) {
      emit(state.copyWith(position: position));
    });
  }

  Future<void> play(Track track) async {
    emit(state.copyWith(currentTrack: track, isPlaying: true, position: Duration.zero));
    await _audioService.playTrack(track.filePath);
  }

  /// Pause the current track
  Future<void> pause() async {
    await _audioService.pause();
    emit(state.copyWith(isPlaying: false));
  }

  /// Resume playing
  Future<void> resume() async {
    await _audioService.resume();
    emit(state.copyWith(isPlaying: true));
  }
}
