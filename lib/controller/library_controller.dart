// lib/controller/library_controller.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/library_scanner_service.dart';
import 'library_state.dart';

class LibraryController extends Cubit<LibraryState> {
  final LibraryScannerService _scannerService;
  bool _hasLoaded = false;

  LibraryController(this._scannerService) : super(LibraryState());

  /// Load library if not already loaded (called on startup)
  Future<void> scanAllMusicIfNeeded() async {
    if (_hasLoaded && state.tracks.isNotEmpty) {
      print('Library already loaded');
      return;
    }

    await scanAllMusic();
  }

  /// Load library from MediaStore (INSTANT!)
  Future<void> scanAllMusic() async {
    print('Controller: Loading library from MediaStore...');
    emit(state.copyWith(isScanning: true, errorMessage: null));

    try {
      final tracks = await _scannerService.scanAllMusic();

      _hasLoaded = true;
      emit(state.copyWith(tracks: tracks, isScanning: false));

      print('Controller: Library loaded, ${tracks.length} tracks');
    } catch (e) {
      print('Controller: Error loading library: $e');
      emit(state.copyWith(isScanning: false, errorMessage: e.toString()));
    }
  }

  void clearLibrary() {
    _hasLoaded = false;
    emit(LibraryState());
  }
}
