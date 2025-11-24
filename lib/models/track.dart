// lib/models/track.dart
class Track {
  final String id;
  final String title;
  final String filePath;
  final String? artist;
  final String? album;
  final Duration? duration;

  Track({
    required this.id,
    required this.title,
    required this.filePath,
    this.artist,
    this.album,
    this.duration,
  });

  @override
  String toString() => 'Track(title: $title, artist: $artist)';
}
