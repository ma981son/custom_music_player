// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'services/audio_player_service.dart';
import 'controller/playback_controller.dart';
import 'presentation/screens/player_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Create our audio service
    final audioService = AudioPlayerService();

    return MaterialApp(
      home: BlocProvider(
        // Provide the PlaybackManager to the whole app
        create: (_) => PlaybackController(audioService),
        child: PlayerScreen(),
      ),
    );
  }
}
