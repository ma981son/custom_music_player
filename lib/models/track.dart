// lib/models/track.dart
class Track {
  final String id;
  final String title;
  final String filePath;
  final String? artist;
  final String? album;
  final Duration? duration;
  final int? albumId; // ← Make sure this exists!

  Track({
    required this.id,
    required this.title,
    required this.filePath,
    this.artist,
    this.album,
    this.duration,
    this.albumId, // ← Make sure this exists!
  });
}
