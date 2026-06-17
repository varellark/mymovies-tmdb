import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/movie.dart';

class FavoriteProvider extends ChangeNotifier {
  List<Movie> _favorites = [];
  List<Movie> get favorites => _favorites;

  static const String _storageKey = 'favorite_movies';

  FavoriteProvider() {
    _loadFavorites();
  }

  bool isFavorite(int movieId) {
    return _favorites.any((m) => m.id == movieId);
  }

  Future<void> toggleFavorite(Movie movie) async {
    if (isFavorite(movie.id)) {
      _favorites.removeWhere((m) => m.id == movie.id);
    } else {
      _favorites.insert(0, movie);
    }
    notifyListeners();
    await _saveFavorites();
  }

  Future<void> addFavorite(Movie movie) async {
    if (!isFavorite(movie.id)) {
      _favorites.insert(0, movie);
      notifyListeners();
      await _saveFavorites();
    }
  }

  Future<void> removeFavorite(int movieId) async {
    _favorites.removeWhere((m) => m.id == movieId);
    notifyListeners();
    await _saveFavorites();
  }

  Future<void> clearAll() async {
    _favorites = [];
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }

  Future<void> _saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = _favorites.map((m) => json.encode(m.toJson())).toList();
      await prefs.setStringList(_storageKey, jsonList);
    } catch (e) {
      debugPrint('Error menyimpan favorit: $e');
    }
  }

  Future<void> _loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = prefs.getStringList(_storageKey) ?? [];
      _favorites = jsonList
          .map((s) => Movie.fromJson(json.decode(s) as Map<String, dynamic>))
          .toList();
      notifyListeners();
    } catch (e) {
      debugPrint('Error memuat favorit: $e');
      _favorites = [];
    }
  }

  int get count => _favorites.length;
  bool get isEmpty => _favorites.isEmpty;
  bool get isNotEmpty => _favorites.isNotEmpty;
}
