import 'package:flutter/material.dart';
import 'package:music_player_final/controller/playback_controller.dart';
import 'package:music_player_final/models/track.dart';
import 'package:music_player_final/presentation/widget/playable_track_tile.dart';
import 'package:music_player_final/services/search_history_service.dart';

class SearchScreen extends StatefulWidget {
  final List<Track> tracks;
  final PlaybackController playbackController;

  const SearchScreen({
    super.key,
    required this.tracks,
    required this.playbackController,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _textController = TextEditingController();
  final _historyService = SearchHistoryService();
  List<String> _history = [];
  bool _hasSearched = false;
  List<Track> _titleResults = [];
  List<Track> _artistResults = [];
  List<Track> _albumResults = [];
  List<Track> _genreResults = [];
  bool _artistExpanded = false;
  bool _albumExpanded = false;
  bool _genreExpanded = false;
  static const int _sectionLimit = 10;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _loadHistory() async {
    final history = await _historyService.loadHistory();
    setState(() => _history = history);
  }

  Future<void> _search(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;

    await _historyService.addSearch(trimmed);
    final q = trimmed.toLowerCase();

    final updatedHistory = await _historyService.loadHistory();
    setState(() {
      _hasSearched = true;
      _artistExpanded = false;
      _albumExpanded = false;
      _genreExpanded = false;
      _titleResults = widget.tracks
          .where((t) => t.title.toLowerCase().contains(q))
          .toList();
      _artistResults = widget.tracks
          .where((t) => t.artist?.toLowerCase().contains(q) ?? false)
          .toList();
      _albumResults = widget.tracks
          .where((t) => t.album?.toLowerCase().contains(q) ?? false)
          .toList();
      _genreResults = widget.tracks
          .where((t) => t.genre?.toLowerCase().contains(q) ?? false)
          .toList();
      _history = updatedHistory;
    });
  }

  Future<void> _removeHistoryEntry(String query) async {
    await _historyService.removeSearch(query);
    await _loadHistory();
  }

  void _onHistoryTap(String query) {
    _textController.text = query;
    _search(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: TextField(
          controller: _textController,
          autofocus: true,
          style: const TextStyle(color: Colors.white, fontSize: 18),
          decoration: const InputDecoration(
            hintText: 'Search songs, artists, albums...',
            hintStyle: TextStyle(color: Colors.white60),
            border: InputBorder.none,
          ),
          textInputAction: TextInputAction.search,
          onSubmitted: _search,
        ),
        actions: [
          IconButton(
            onPressed: () {
              _textController.clear();
              setState(() => _hasSearched = false);
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: _hasSearched ? _buildResults() : _buildHistory(),
    );
  }

  Widget _buildHistory() {
    if (_history.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'Search your library',
              style: TextStyle(fontSize: 16, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: Text(
            'Recent searches',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[500],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _history.length,
            itemBuilder: (context, index) {
              final query = _history[index];
              return ListTile(
                leading: Icon(Icons.history, color: Colors.grey[400]),
                title: Text(query),
                trailing: IconButton(
                  icon: Icon(Icons.close, size: 18, color: Colors.grey[400]),
                  onPressed: () => _removeHistoryEntry(query),
                ),
                onTap: () => _onHistoryTap(query),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildResults() {
    final hasAny =
        _titleResults.isNotEmpty ||
        _artistResults.isNotEmpty ||
        _albumResults.isNotEmpty ||
        _genreResults.isNotEmpty;

    if (!hasAny) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'No results for "${_textController.text}"',
              style: TextStyle(fontSize: 16, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_titleResults.isNotEmpty)
            _buildSection('Songs', _titleResults, null, null, null),
          if (_artistResults.isNotEmpty)
            _buildSection(
              'Artists',
              _artistResults,
              _artistExpanded,
              'Artists',
              () => setState(() => _artistExpanded = true),
            ),
          if (_albumResults.isNotEmpty)
            _buildSection(
              'Albums',
              _albumResults,
              _albumExpanded,
              'Albums',
              () => setState(() => _albumExpanded = true),
            ),
          if (_genreResults.isNotEmpty)
            _buildSection(
              'Genre',
              _genreResults,
              _genreExpanded,
              'Genre',
              () => setState(() => _genreExpanded = true),
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSection(
    String title,
    List<Track> tracks,
    bool? expanded,
    String? expandKey,
    VoidCallback? onShowMore,
  ) {
    final isLimited = expanded != null;
    final visible = isLimited && expanded == false
        ? tracks.take(_sectionLimit).toList()
        : tracks;
    final remaining = tracks.length - _sectionLimit;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey[500],
              letterSpacing: 0.5,
            ),
          ),
        ),
        ...visible.map(
          (track) => PlayableTrackTile(
            key: ValueKey('${expandKey ?? "songs"}_${track.id}'),
            track: track,
            index: tracks.indexOf(track),
            playbackController: widget.playbackController,
          ),
        ),
        if (isLimited && expanded == false && remaining > 0)
          TextButton(
            onPressed: onShowMore,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Show $remaining more',
                style: const TextStyle(color: Colors.blue),
              ),
            ),
          ),
      ],
    );
  }
}
