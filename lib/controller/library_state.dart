// lib/controller/library_state.dart
import '../models/track.dart';

class LibraryState {
  final List<Track> tracks;
  final bool isScanning;
  final String? errorMessage;

  LibraryState({
    this.tracks = const [],
    this.isScanning = false,
    this.errorMessage,
  });

  LibraryState copyWith({
    List<Track>? tracks,
    bool? isScanning,
    String? errorMessage,
  }) {
    return LibraryState(
      tracks: tracks ?? this.tracks,
      isScanning: isScanning ?? this.isScanning,
      errorMessage: errorMessage, // Don't use ?? here! We want to allow null
    );
  }

  @override
  String toString() =>
      'LibraryState(tracks: ${tracks.length}, isScanning: $isScanning, error: $errorMessage)';
}
