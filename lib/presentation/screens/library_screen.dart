// lib/presentation/screens/library_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player_final/models/track.dart';
import 'package:music_player_final/presentation/widget/track_list_widget.dart';
import '../../controller/library_controller.dart';
import '../../controller/library_state.dart';
import '../../controller/playback_controller.dart';

class LibraryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: Text('Library'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              context.read<LibraryController>().scanAllMusic();
            },
          ),
        ],
      ),
      body: BlocBuilder<LibraryController, LibraryState>(
        builder: (context, state) {
          // Loading
          if (state.isScanning && state.tracks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading library...'),
                ],
              ),
            );
          }

          // Error
          if (state.errorMessage != null) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red),
                    SizedBox(height: 16),
                    Text(
                      'Error',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(state.errorMessage!, textAlign: TextAlign.center),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<LibraryController>().scanAllMusic(),
                      child: Text('Try Again'),
                    ),
                  ],
                ),
              ),
            );
          }

          // Track list with header
          return Column(
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(16),
                color: Colors.grey[200],
                child: Row(
                  children: [
                    Icon(Icons.music_note),
                    SizedBox(width: 8),
                    Text(
                      '${state.tracks.length} tracks',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Reusable track list
              Expanded(
                child: TrackListWidget(
                  tracks: state.tracks,
                  onTrackTap: (track, index) {
                    context.read<PlaybackController>().play(track);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Playing: ${track.title}'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  onTrackLongPress: (track, index) {
                    _showTrackOptions(context, track);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showTrackOptions(BuildContext context, Track track) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.play_arrow),
              title: Text('Play'),
              onTap: () {
                Navigator.pop(context);
                context.read<PlaybackController>().play(track);
              },
            ),
            ListTile(
              leading: Icon(Icons.playlist_add),
              title: Text('Add to queue'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Add to queue
              },
            ),
            ListTile(
              leading: Icon(Icons.playlist_add_check),
              title: Text('Add to playlist'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Show playlist picker
              },
            ),
          ],
        ),
      ),
    );
  }
}
