// lib/models/sort_option.dart
enum SortOption {
  titleAsc('Title A-Z'),
  titleDesc('Title Z-A'),
  dateAddedAsc('Date added (oldest)'),
  dateAddedDesc('Date added (newest)'),
  albumAsc('Album A-Z'),
  albumDesc('Album Z-A'),
  artistAsc('Artist A-Z'),
  artistDesc('Artist Z-A'),
  durationAsc('Duration (shortest)'),
  durationDesc('Duration (longest)'),
  filePath('File path');

  final String label;
  const SortOption(this.label);
}
