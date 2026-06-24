class Track {
  final String id;
  final String title;
  final String filePath;
  final String? artist;
  final String? album;
  final String? genre;
  final Duration? duration;
  final int? albumId;
  final DateTime? dateAdded;

  Track({
    required this.id,
    required this.title,
    required this.filePath,
    this.artist,
    this.album,
    this.genre,
    this.duration,
    this.albumId,
    this.dateAdded,
  });
}
