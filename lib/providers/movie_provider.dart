import 'package:flutter/foundation.dart';
import '../models/movie.dart';
import '../services/tmdb_service.dart';

enum MovieCategory { nowPlaying, popular, topRated, upcoming }

class MovieProvider extends ChangeNotifier {
  final TmdbService _service;

  MovieProvider({TmdbService? service}) : _service = service ?? TmdbService();

  List<Movie> _nowPlaying = [];
  List<Movie> _popular = [];
  List<Movie> _topRated = [];
  List<Movie> _upcoming = [];

  List<Movie> get nowPlaying => _nowPlaying;
  List<Movie> get popular => _popular;
  List<Movie> get topRated => _topRated;
  List<Movie> get upcoming => _upcoming;

  bool _isLoadingNowPlaying = false;
  bool _isLoadingPopular = false;
  bool _isLoadingTopRated = false;
  bool _isLoadingUpcoming = false;
  bool _isLoadingSearch = false;
  bool _isLoadingDetail = false;

  bool get isLoadingNowPlaying => _isLoadingNowPlaying;
  bool get isLoadingPopular => _isLoadingPopular;
  bool get isLoadingTopRated => _isLoadingTopRated;
  bool get isLoadingUpcoming => _isLoadingUpcoming;
  bool get isLoadingSearch => _isLoadingSearch;
  bool get isLoadingDetail => _isLoadingDetail;

  String? _error;
  String? get error => _error;

  List<Movie> _searchResults = [];
  List<Movie> get searchResults => _searchResults;
  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  Movie? _selectedMovie;
  Movie? get selectedMovie => _selectedMovie;

  int _nowPlayingPage = 1;
  int _popularPage = 1;

  bool _hasMoreNowPlaying = true;
  bool _hasMorePopular = true;

  bool get hasMoreNowPlaying => _hasMoreNowPlaying;
  bool get hasMorePopular => _hasMorePopular;

  Future<void> fetchNowPlaying({bool refresh = false}) async {
    if (refresh) {
      _nowPlayingPage = 1;
      _hasMoreNowPlaying = true;
    }
    if (!_hasMoreNowPlaying) return;
    if (_isLoadingNowPlaying) return;

    _isLoadingNowPlaying = true;
    _error = null;
    notifyListeners();

    try {
      final movies = await _service.getNowPlaying(page: _nowPlayingPage);
      if (refresh || _nowPlayingPage == 1) {
        _nowPlaying = movies;
      } else {
        _nowPlaying = [..._nowPlaying, ...movies];
      }
      if (movies.length < 20) _hasMoreNowPlaying = false;
      _nowPlayingPage++;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoadingNowPlaying = false;
      notifyListeners();
    }
  }

  Future<void> fetchPopular({bool refresh = false}) async {
    if (refresh) {
      _popularPage = 1;
      _hasMorePopular = true;
    }
    if (!_hasMorePopular) return;
    if (_isLoadingPopular) return;

    _isLoadingPopular = true;
    _error = null;
    notifyListeners();

    try {
      final movies = await _service.getPopular(page: _popularPage);
      if (refresh || _popularPage == 1) {
        _popular = movies;
      } else {
        _popular = [..._popular, ...movies];
      }
      if (movies.length < 20) _hasMorePopular = false;
      _popularPage++;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoadingPopular = false;
      notifyListeners();
    }
  }

  Future<void> fetchTopRated() async {
    if (_isLoadingTopRated) return;
    _isLoadingTopRated = true;
    _error = null;
    notifyListeners();

    try {
      _topRated = await _service.getTopRated();
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoadingTopRated = false;
      notifyListeners();
    }
  }

  Future<void> fetchUpcoming() async {
    if (_isLoadingUpcoming) return;
    _isLoadingUpcoming = true;
    _error = null;
    notifyListeners();

    try {
      _upcoming = await _service.getUpcoming();
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoadingUpcoming = false;
      notifyListeners();
    }
  }

  Future<void> searchMovies(String query) async {
    _searchQuery = query;
    if (query.trim().isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    _isLoadingSearch = true;
    _error = null;
    notifyListeners();

    try {
      _searchResults = await _service.searchMovies(query);
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _searchResults = [];
    } finally {
      _isLoadingSearch = false;
      notifyListeners();
    }
  }

  void clearSearch() {
    _searchResults = [];
    _searchQuery = '';
    notifyListeners();
  }

  Future<void> fetchMovieDetail(int movieId) async {
    _isLoadingDetail = true;
    _selectedMovie = null;
    _error = null;
    notifyListeners();

    try {
      _selectedMovie = await _service.getMovieDetail(movieId);
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoadingDetail = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }
}
