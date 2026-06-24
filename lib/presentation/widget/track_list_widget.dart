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
  final void Function(Track track, int index)? onTrackMenuTap;
  final Widget Function(Track track, int index)? trailingBuilder;
  final bool showTrackNumber;
  final bool showDuration;
  final bool showShuffleBar;
  final bool showTrackMenu;
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
    this.onTrackMenuTap,
    this.showTrackMenu = true,
  });

  @override
  Widget build(BuildContext context) {
    if (tracks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.library_music_outlined, size: 72, color: Colors.grey[300]),
            SizedBox(height: 16),
            Text(
              'No songs found',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey[600]),
            ),
            SizedBox(height: 8),
            Text(
              'Try refreshing your library',
              style: TextStyle(fontSize: 14, color: Colors.grey[400]),
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
                showTrackMenu: showTrackMenu,
                onTap: onTrackTap != null
                    ? () => onTrackTap!(track, index)
                    : null,
                onLongPress: onTrackLongPress != null
                    ? () => onTrackLongPress!(track, index)
                    : null,
                onTrackMenuTap: onTrackMenuTap != null
                    ? () => onTrackMenuTap!(track, index)
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
  final bool showTrackMenu;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onTrackMenuTap;
  final Widget? trailing;

  const TrackListTile({
    super.key,
    required this.track,
    required this.index,
    this.showTrackNumber = false,
    this.showDuration = true,
    this.showTrackMenu = true,
    this.onTap,
    this.onLongPress,
    this.onTrackMenuTap,
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
      trailing: trailing ?? _buildDefaultTrailing(),
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }

  Widget? _buildDefaultTrailing() {
    // If menu is enabled, show menu button
    if (showTrackMenu) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDuration && track.duration != null) ...[
            Text(
              _formatDuration(track.duration!),
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            SizedBox(width: 8),
          ],
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: onTrackMenuTap,
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
            iconSize: 20,
          ),
        ],
      );
    }

    // Otherwise, just show duration if available
    if (showDuration && track.duration != null) {
      return Text(
        _formatDuration(track.duration!),
        style: TextStyle(color: Colors.grey[600], fontSize: 12),
      );
    }

    return null;
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(d.inMinutes)}:${twoDigits(d.inSeconds % 60)}';
  }
}
