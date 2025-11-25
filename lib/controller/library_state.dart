// In library_state.dart
import 'package:music_player_final/models/sort_option.dart';
import 'package:music_player_final/models/track.dart';

class LibraryState {
  final List<Track> tracks;
  final bool isScanning;
  final String? errorMessage;
  final SortOption sortOption;

  LibraryState({
    this.tracks = const [],
    this.isScanning = false,
    this.errorMessage,
    this.sortOption = SortOption.dateAddedAsc,
  });

  LibraryState copyWith({
    List<Track>? tracks,
    bool? isScanning,
    String? errorMessage,
    SortOption? sortOption,
  }) {
    return LibraryState(
      tracks: tracks ?? this.tracks,
      isScanning: isScanning ?? this.isScanning,
      errorMessage: errorMessage,
      sortOption: sortOption ?? this.sortOption,
    );
  }
}
