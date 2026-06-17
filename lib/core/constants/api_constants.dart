class ApiConstants {
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';
  static const String imageOriginalUrl = 'https://image.tmdb.org/t/p/original';

  // API KEY
  static const String apiKey = '32c5294162048cddaf4045095d33527d';
  static const String readAccessToken = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIzMmM1Mjk0MTYyMDQ4Y2RkYWY0MDQ1MDk1ZDMzNTI3ZCIsIm5iZiI6MTc4MTY3ODk0MS45NTcsInN1YiI6IjZhMzI0MzVkNDA2YjRiZDBlNGIxZmU4MCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.yqx6E7H4XWkHQlPTK4et2q2H2LFT-HJogsMnsDpw_2s';

  // Endpoints
  static const String nowPlaying = '/movie/now_playing';
  static const String popular = '/movie/popular';
  static const String topRated = '/movie/top_rated';
  static const String upcoming = '/movie/upcoming';
  static const String movieDetail = '/movie';
  static const String searchMovie = '/search/movie';
  static const String movieCredits = '/movie/{id}/credits';

  static Map<String, String> get headers => {
        'Authorization': 'Bearer $readAccessToken',
        'Content-Type': 'application/json',
      };
}
