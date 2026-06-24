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
          return TrackListWidget(
            tracks: state.tracks,
            showShuffleBar: true,
            currentSortOption: state.sortOption,
            onSortOptionChanged: (option) {
              context.read<LibraryController>().setSortOption(option);
            },
            onTrackTap: (track, index) {
              context.read<PlaybackController>().play(track);
            },
            onTrackMenuTap: (track, index) {
              _showTrackOptions(context, track);
            },
          );
        },
      ),
    );
  }

  void _showTrackOptions(BuildContext context, Track track) {
    final playbackController = context.read<PlaybackController>();
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.play_arrow),
              title: Text('Play'),
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
