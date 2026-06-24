// lib/services/library_scanner_service.dart
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import '../models/track.dart';
import 'media_store_service.dart';

class LibraryScannerService {
  final _mediaStore = MediaStoreService();

  Future<List<Track>> scanAllMusic() async {
    final hasPermission = await _requestPermissions();
    if (!hasPermission) {
      throw Exception('Storage permission denied');
    }
    return await _mediaStore.getAllAudioFiles();
  }

  Future<bool> _requestPermissions() async {
    if (Platform.isAndroid) {
      var status = await Permission.audio.request();
      if (status.isGranted) return true;

      status = await Permission.storage.request();
      return status.isGranted;
    }
    return true;
  }
}
