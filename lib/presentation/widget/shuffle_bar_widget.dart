// lib/presentation/widgets/shuffle_bar_widget.dart
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:music_player_final/models/track.dart';
import 'package:music_player_final/models/sort_option.dart';
import 'package:music_player_final/presentation/widget/sort_options.dart';

class ShuffleBarWidget extends StatelessWidget {
  final List<Track> tracks;
  final void Function(Track track, int index)? onShuffleTap;
  final void Function(Track track, int index)? onFallbackTap;
  final SortOption currentSortOption;
  final void Function(SortOption option)? onSortOptionChanged;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? textColor;

  const ShuffleBarWidget({
    super.key,
    required this.tracks,
    this.onShuffleTap,
    this.onFallbackTap,
    required this.currentSortOption,
    this.onSortOptionChanged,
    this.backgroundColor,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor ?? Colors.grey[100],
      child: InkWell(
        onTap: tracks.isNotEmpty ? _onTap : null,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(Icons.shuffle, color: iconColor ?? Colors.blue, size: 24),
              SizedBox(width: 12),
              Text(
                'Shuffle',
                style: TextStyle(
                  color: textColor ?? Colors.blue,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
              Text(
                '${tracks.length} tracks',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              IconButton(
                onPressed: () => _showSortOptions(context),
                icon: Icon(Icons.sort, color: iconColor ?? Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTap() {
    if (tracks.isEmpty) return;

    final random = Random();
    final randomIndex = random.nextInt(tracks.length);
    final randomTrack = tracks[randomIndex];

    if (onShuffleTap != null) {
      onShuffleTap!(randomTrack, randomIndex);
    } else {
      onFallbackTap?.call(randomTrack, randomIndex);
    }
  }

  void _showSortOptions(BuildContext context) {
    SortOptionsPanel.show(
      context,
      currentOption: currentSortOption,
      onOptionSelected: (option) {
        onSortOptionChanged?.call(option);
      },
    );
  }
}
