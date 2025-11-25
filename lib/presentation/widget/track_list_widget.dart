// lib/presentation/widgets/track_list_widget.dart
import 'package:flutter/material.dart';
import 'package:music_player_final/models/sort_option.dart';
import 'package:music_player_final/models/track.dart';
import 'package:music_player_final/presentation/widget/shuffle_bar_widget.dart';
import 'album_art_widget.dart';

class TrackListWidget extends StatelessWidget {
  final List<Track> tracks;
  final void Function(Track track, int index)? onTrackTap;
  final void Function(Track track, int index)? onTrackLongPress;
  final Widget Function(Track track, int index)? trailingBuilder;
  final bool showTrackNumber;
  final bool showDuration;
  final bool showShuffleBar;
  final void Function(Track track, int index)? onShuffleTap;
  final ScrollController? scrollController;
  final EdgeInsets? padding;
  final SortOption currentSortOption;
  final void Function(SortOption option)? onSortOptionChanged;

  const TrackListWidget({
    super.key,
    required this.tracks,
    this.onTrackTap,
    this.onTrackLongPress,
    this.trailingBuilder,
    this.showTrackNumber = false,
    this.showDuration = true,
    this.scrollController,
    this.padding,
    required this.showShuffleBar,
    this.onShuffleTap,
    required this.currentSortOption,
    this.onSortOptionChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (tracks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.music_off, size: 64, color: Colors.grey[400]),
            SizedBox(height: 16),
            Text(
              'No tracks',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        if (showShuffleBar)
          ShuffleBarWidget(
            tracks: tracks,
            onShuffleTap: onShuffleTap,
            onFallbackTap: onTrackTap,
            currentSortOption: currentSortOption,
            onSortOptionChanged: onSortOptionChanged,
          ),
        Expanded(
          child: ListView.builder(
            controller: scrollController,
            padding: padding,
            itemCount: tracks.length,
            itemBuilder: (context, index) {
              final track = tracks[index];

              return TrackListTile(
                key: ValueKey(track.filePath),
                track: track,
                index: index,
                showTrackNumber: showTrackNumber,
                showDuration: showDuration,
                onTap: onTrackTap != null
                    ? () => onTrackTap!(track, index)
                    : null,
                onLongPress: onTrackLongPress != null
                    ? () => onTrackLongPress!(track, index)
                    : null,
                trailing: trailingBuilder?.call(track, index),
              );
            },
          ),
        ),
      ],
    );
  }
}

class TrackListTile extends StatelessWidget {
  final Track track;
  final int index;
  final bool showTrackNumber;
  final bool showDuration;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Widget? trailing;

  const TrackListTile({
    super.key,
    required this.track,
    required this.index,
    this.showTrackNumber = false,
    this.showDuration = true,
    this.onTap,
    this.onLongPress,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showTrackNumber) ...[
            SizedBox(
              width: 32,
              child: Text(
                '${index + 1}',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(width: 8),
          ],
          AlbumArtWidget(albumId: track.albumId, size: 50),
        ],
      ),
      title: Text(
        track.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        track.artist ?? 'Unknown Artist',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.grey[600], fontSize: 14),
      ),
      trailing:
          trailing ??
          (showDuration && track.duration != null
              ? Text(
                  _formatDuration(track.duration!),
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                )
              : null),
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(d.inMinutes)}:${twoDigits(d.inSeconds % 60)}';
  }
}
