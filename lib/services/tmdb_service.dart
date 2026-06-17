import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/api_constants.dart';
import '../models/movie.dart';

class TmdbService {
  final http.Client _client;

  TmdbService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    return _fetchMovieList(ApiConstants.nowPlaying, page: page);
  }

  Future<List<Movie>> getPopular({int page = 1}) async {
    return _fetchMovieList(ApiConstants.popular, page: page);
  }

  Future<List<Movie>> getTopRated({int page = 1}) async {
    return _fetchMovieList(ApiConstants.topRated, page: page);
  }

  Future<List<Movie>> getUpcoming({int page = 1}) async {
    return _fetchMovieList(ApiConstants.upcoming, page: page);
  }

  Future<List<Movie>> searchMovies(String query, {int page = 1}) async {
    if (query.trim().isEmpty) return [];

    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.searchMovie}')
        .replace(queryParameters: {
      'query': query,
      'page': page.toString(),
      'language': 'id-ID',
    });

    final response = await _client.get(uri, headers: ApiConstants.headers);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'] as List;
      return results.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mencari movie: ${response.statusCode}');
    }
  }

  Future<Movie> getMovieDetail(int movieId) async {
    final uri = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.movieDetail}/$movieId?language=id-ID&append_to_response=credits');

    final response = await _client.get(uri, headers: ApiConstants.headers);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Movie.fromJson(data);
    } else {
      throw Exception('Gagal mengambil detail movie: ${response.statusCode}');
    }
  }

  Future<List<Movie>> _fetchMovieList(String endpoint, {int page = 1}) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint')
        .replace(queryParameters: {
      'page': page.toString(),
      'language': 'id-ID',
      'region': 'ID',
    });

    final response = await _client.get(uri, headers: ApiConstants.headers);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'] as List;
      return results.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mengambil movie dari $endpoint: ${response.statusCode}');
    }
  }

  void dispose() {
    _client.close();
  }
}
