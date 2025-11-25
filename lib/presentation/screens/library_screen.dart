// lib/presentation/screens/library_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player_final/presentation/widget/album_art_widget.dart';
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

          // Empty
          if (state.tracks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.library_music, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No music found', style: TextStyle(fontSize: 18)),
                ],
              ),
            );
          }

          // Track list
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

              // Track list
              Expanded(
                child: ListView.builder(
                  itemCount: state.tracks.length,
                  itemBuilder: (context, index) {
                    final track = state.tracks[index];

                    return ListTile(
                      // USE AlbumArtWidget instead of Container
                      leading: AlbumArtWidget(albumId: track.albumId, size: 50),

                      title: Text(
                        track.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      subtitle: Text(
                        track.artist ?? 'Unknown Artist',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      trailing: track.duration != null
                          ? Text(
                              _formatDuration(track.duration!),
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            )
                          : null,

                      onTap: () {
                        context.read<PlaybackController>().play(track);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Playing: ${track.title}'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
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
