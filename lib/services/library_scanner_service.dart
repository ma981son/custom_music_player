// lib/services/library_scanner_service.dart
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import '../models/track.dart';
import 'media_store_service.dart';

class LibraryScannerService {
  final _mediaStore = MediaStoreService();

  /// Scan all music using MediaStore (FAST!)
  Future<List<Track>> scanAllMusic() async {
    print('LibraryScannerService: Starting scan...');

    // Request permissions first
    final hasPermission = await _requestPermissions();
    if (!hasPermission) {
      throw Exception('Storage permission denied');
    }

    // Query MediaStore for all audio files
    final tracks = await _mediaStore.getAllAudioFiles();

    print(
      'LibraryScannerService: Scan complete, found ${tracks.length} tracks',
    );
    return tracks;
  }

  /// Request storage permissions
  Future<bool> _requestPermissions() async {
    if (Platform.isAndroid) {
      // Try audio permission first (Android 13+)
      var status = await Permission.audio.request();
      if (status.isGranted) {
        print('Audio permission granted');
        return true;
      }

      // Fallback to storage permission (Android 12 and below)
      status = await Permission.storage.request();
      if (status.isGranted) {
        print('Storage permission granted');
        return true;
      }

      print('Permission denied');
      return false;
    }

    // iOS permissions handled differently
    return true;
  }
}
