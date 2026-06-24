import 'package:flutter/material.dart';
import 'package:music_player_final/controller/playback_controller.dart';
import 'package:music_player_final/models/track.dart';
import 'track_list_widget.dart';

class PlayableTrackTile extends StatelessWidget {
  final Track track;
  final int index;
  final PlaybackController playbackController;

  const PlayableTrackTile({
    super.key,
    required this.track,
    required this.index,
    required this.playbackController,
  });

  @override
  Widget build(BuildContext context) {
    return TrackListTile(
      track: track,
      index: index,
      showTrackMenu: true,
      onTap: () => playbackController.play(track),
      onTrackMenuTap: () => _showOptions(context),
    );
  }

  void _showOptions(BuildContext context) {
    FocusScope.of(context).unfocus();
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.play_arrow),
              title: const Text('Play'),
              onTap: () {
                Navigator.pop(sheetContext);
                playbackController.play(track);
              },
            ),
          ],
        ),
      ),
    );
  }
}
