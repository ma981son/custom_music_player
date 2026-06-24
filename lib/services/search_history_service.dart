import 'package:shared_preferences/shared_preferences.dart';

class SearchHistoryService {
  static const _key = 'search_history';
  static const _maxEntries = 10;

  Future<List<String>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  Future<void> addSearch(String query) async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList(_key) ?? [];
    history.remove(query);
    history.insert(0, query);
    if (history.length > _maxEntries) history.removeLast();
    await prefs.setStringList(_key, history);
  }

  Future<void> removeSearch(String query) async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList(_key) ?? [];
    history.remove(query);
    await prefs.setStringList(_key, history);
  }
}
