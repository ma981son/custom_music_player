// lib/presentation/widget/album_art_widget.dart
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../services/media_store_service.dart';

class AlbumArtWidget extends StatefulWidget {
  final int? albumId;
  final double size;

  const AlbumArtWidget({super.key, required this.albumId, this.size = 50});

  @override
  State<AlbumArtWidget> createState() => _AlbumArtWidgetState();
}

class _AlbumArtWidgetState extends State<AlbumArtWidget> {
  Uint8List? _imageBytes;
  bool _isLoading = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadAlbumArt();
  }

  Future<void> _loadAlbumArt() async {
    if (widget.albumId == null) {
      setState(() => _hasError = true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final mediaStore = MediaStoreService();
      final base64String = await mediaStore.getAlbumArt(widget.albumId!);

      if (base64String != null && mounted) {
        setState(() {
          _imageBytes = base64Decode(base64String);
          _isLoading = false;
        });
      } else if (mounted) {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // While loading, show placeholder
    if (_isLoading) {
      return Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    // If we have album art, show it
    if (_imageBytes != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.memory(
          _imageBytes!,
          width: widget.size,
          height: widget.size,
          fit: BoxFit.cover,
        ),
      );
    }

    // Fallback placeholder (no album art)
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Icon(Icons.music_note, color: Colors.blue, size: widget.size / 2),
    );
  }
}
