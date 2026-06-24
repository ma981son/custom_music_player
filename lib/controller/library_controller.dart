// lib/controller/library_controller.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player_final/models/sort_option.dart';
import 'package:music_player_final/models/track.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/library_scanner_service.dart';
import 'library_state.dart';

class LibraryController extends Cubit<LibraryState> {
  final LibraryScannerService _scannerService;
  bool _hasLoaded = false;

  LibraryController(this._scannerService) : super(LibraryState());

  Future<void> scanAllMusicIfNeeded() async {
    if (_hasLoaded && state.tracks.isNotEmpty) return;
    await scanAllMusic();
  }

  Future<void> scanAllMusic() async {
    emit(state.copyWith(isScanning: true, errorMessage: null));

    try {
      final savedSortOption = await _loadSortOption();
      final tracks = await _scannerService.scanAllMusic();
      final sortedTracks = _sortTracks(tracks, savedSortOption);

      _hasLoaded = true;
      emit(
        state.copyWith(
          tracks: sortedTracks,
          isScanning: false,
          sortOption: savedSortOption,
        ),
      );
    } catch (e) {
      final message = e.toString().toLowerCase().contains('permission')
          ? 'Music access was denied.\nPlease grant storage permission in your device settings.'
          : 'Could not load your music library.\nPlease try again.';
      emit(state.copyWith(isScanning: false, errorMessage: message));
    }
  }

  void setSortOption(SortOption option) async {
    final sortedTracks = _sortTracks(state.tracks, option);
    emit(state.copyWith(tracks: sortedTracks, sortOption: option));
    await _saveSortOption(option);
  }

  Future<void> _saveSortOption(SortOption option) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('sort_option', option.name);
  }

  Future<SortOption> _loadSortOption() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('sort_option');
    if (saved != null) {
      return SortOption.values.byName(saved);
    }
    return SortOption.dateAddedDesc;
  }

  List<Track> _sortTracks(List<Track> tracks, SortOption option) {
    final sorted = List<Track>.from(tracks);

    switch (option) {
      case SortOption.titleAsc:
        sorted.sort(
          (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
        );
      case SortOption.titleDesc:
        sorted.sort(
          (a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()),
        );
      case SortOption.dateAddedAsc:
        sorted.sort(
          (a, b) => (a.dateAdded ?? DateTime(0)).compareTo(
            b.dateAdded ?? DateTime(0),
          ),
        );
      case SortOption.dateAddedDesc:
        sorted.sort(
          (a, b) => (b.dateAdded ?? DateTime(0)).compareTo(
            a.dateAdded ?? DateTime(0),
          ),
        );
      case SortOption.albumAsc:
        sorted.sort(
          (a, b) => (a.album ?? '').toLowerCase().compareTo(
            (b.album ?? '').toLowerCase(),
          ),
        );
      case SortOption.albumDesc:
        sorted.sort(
          (a, b) => (b.album ?? '').toLowerCase().compareTo(
            (a.album ?? '').toLowerCase(),
          ),
        );
      case SortOption.artistAsc:
        sorted.sort(
          (a, b) => (a.artist ?? '').toLowerCase().compareTo(
            (b.artist ?? '').toLowerCase(),
          ),
        );
      case SortOption.artistDesc:
        sorted.sort(
          (a, b) => (b.artist ?? '').toLowerCase().compareTo(
            (a.artist ?? '').toLowerCase(),
          ),
        );
      case SortOption.durationAsc:
        sorted.sort(
          (a, b) => (a.duration ?? Duration.zero).compareTo(
            b.duration ?? Duration.zero,
          ),
        );
      case SortOption.durationDesc:
        sorted.sort(
          (a, b) => (b.duration ?? Duration.zero).compareTo(
            a.duration ?? Duration.zero,
          ),
        );
      case SortOption.filePath:
        sorted.sort((a, b) => (a.filePath).compareTo(b.filePath));
    }

    return sorted;
  }

  void clearLibrary() {
    _hasLoaded = false;
    emit(LibraryState());
  }
}
