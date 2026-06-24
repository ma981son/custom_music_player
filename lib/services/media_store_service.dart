import 'package:flutter/services.dart';
import '../models/track.dart';

class MediaStoreService {
  static const platform = MethodChannel('media_store');

  Future<List<Track>> getAllAudioFiles() async {
    try {
      print('MediaStore: Querying audio files...');

      final List<dynamic> result = await platform.invokeMethod(
        'getAllAudioFiles',
      );

      print('MediaStore: Found ${result.length} tracks');

      return result.map((data) {
        return Track(
          id: data['id'] as String,
          title: data['title'] as String? ?? 'Unknown Title',
          artist: data['artist'] as String?,
          album: data['album'] as String?,
          genre: data['genre'] as String?,
          filePath: data['filePath'] as String,
          duration: data['duration'] != null
              ? Duration(milliseconds: (data['duration'] as int))
              : null,
          albumId: data['albumId'] as int?,
          dateAdded: data['dateAdded'] != null
              ? DateTime.fromMillisecondsSinceEpoch(
                  (data['dateAdded'] as int) * 1000,
                )
              : null,
        );
      }).toList();
    } on PlatformException catch (e) {
      print('MediaStore error: ${e.message}');
      throw Exception('Failed to query MediaStore: ${e.message}');
    }
  }

  // New method: Get album art for a specific album
  Future<String?> getAlbumArt(int albumId) async {
    try {
      final String? base64 = await platform.invokeMethod('getAlbumArt', {
        'albumId': albumId,
      });
      return base64;
    } catch (e) {
      return null;
    }
  }
}
