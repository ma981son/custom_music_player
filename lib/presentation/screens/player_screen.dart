// lib/screens/player_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player_final/controller/playback_controller.dart';
import '../../models/track.dart';
import '../../controller/playback_state.dart';

class PlayerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Simple Music Player')),

      // BlocBuilder automatically rebuilds when PlaybackState changes
      body: BlocBuilder<PlaybackController, PlaybackState>(
        builder: (context, state) {
          // 'state' is the current PlaybackState

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Show the current track name
                Text(
                  state.currentTrack?.title ?? 'No track playing',
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(height: 20),

                // Show how far into the song we are
                Text(
                  _formatDuration(state.position),
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 40),

                // Play/Pause button
                IconButton(
                  icon: Icon(
                    state.isPlaying ? Icons.pause : Icons.play_arrow,
                    size: 64,
                  ),
                  onPressed: () {
                    // Get the PlaybackController
                    final controller = context.read<PlaybackController>();

                    if (state.currentTrack == null) {
                      // No track yet, play a demo track
                      final demoTrack = Track(
                        id: '1',
                        title: 'Demo Song',
                        filePath: '/storage/emulated/0/Music/demo.mp3',
                        artist: 'Demo Artist',
                      );
                      controller.play(demoTrack);
                    } else if (state.isPlaying) {
                      // Currently playing, so pause it
                      controller.pause();
                    } else {
                      // Currently paused, so resume
                      controller.resume();
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Helper to format Duration as MM:SS
  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(d.inMinutes)}:${twoDigits(d.inSeconds % 60)}';
  }
}
