// lib/services/audio_player_service.dart
import 'package:just_audio/just_audio.dart';

/// This service actually plays the audio files
class AudioPlayerService {
  final AudioPlayer _player = AudioPlayer();

  /// Plays a track from a file path
  Future<void> playTrack(String filePath) async {
    await _player.setFilePath(filePath);
    await _player.play();
  }

  /// Pauses the current track
  Future<void> pause() async {
    await _player.pause();
  }

  /// Resumes playing
  Future<void> resume() async {
    await _player.play();
  }

  /// Is music currently playing?
  bool get isPlaying => _player.playing;

  /// Stream that tells us the current position (for showing progress)
  Stream<Duration> get positionStream => _player.positionStream;
}
