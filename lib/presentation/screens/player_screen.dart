import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player_final/controller/playback_controller.dart';
import 'package:music_player_final/presentation/widget/album_art_widget.dart';
import '../../controller/playback_state.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: Text('Now Playing'),
      ),
      body: BlocBuilder<PlaybackController, PlaybackState>(
        builder: (context, state) {
          final track = state.currentTrack;

          if (track == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.music_note, size: 80, color: Colors.grey[300]),
                  SizedBox(height: 16),
                  Text(
                    'No track selected',
                    style: TextStyle(fontSize: 18, color: Colors.grey[500]),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Pick a song from the Library tab',
                    style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                  ),
                ],
              ),
            );
          }

          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AlbumArtWidget(albumId: track.albumId, size: 220),
                  SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      track.title,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      track.artist ?? 'Unknown Artist',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 32),
                  Text(
                    _formatDuration(state.position),
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 16),
                  IconButton(
                    icon: Icon(
                      state.isPlaying
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_filled,
                      size: 72,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      final controller = context.read<PlaybackController>();
                      if (state.isPlaying) {
                        controller.pause();
                      } else {
                        controller.resume();
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(d.inMinutes)}:${twoDigits(d.inSeconds % 60)}';
  }
}
