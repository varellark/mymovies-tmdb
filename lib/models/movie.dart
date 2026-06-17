class Movie {
  final int id;
  final String title;
  final String? overview;
  final String? posterPath;
  final String? backdropPath;
  final double voteAverage;
  final int voteCount;
  final String? releaseDate;
  final List<int> genreIds;
  final double popularity;
  final bool adult;
  final String? originalLanguage;
  final String? originalTitle;

  final int? runtime;
  final List<Genre>? genres;
  final String? tagline;
  final String? status;
  final int? budget;
  final int? revenue;

  Movie({
    required this.id,
    required this.title,
    this.overview,
    this.posterPath,
    this.backdropPath,
    required this.voteAverage,
    required this.voteCount,
    this.releaseDate,
    this.genreIds = const [],
    this.popularity = 0.0,
    this.adult = false,
    this.originalLanguage,
    this.originalTitle,
    this.runtime,
    this.genres,
    this.tagline,
    this.status,
    this.budget,
    this.revenue,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Unknown',
      overview: json['overview'],
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      voteAverage: (json['vote_average'] ?? 0.0).toDouble(),
      voteCount: json['vote_count'] ?? 0,
      releaseDate: json['release_date'],
      genreIds: List<int>.from(json['genre_ids'] ?? []),
      popularity: (json['popularity'] ?? 0.0).toDouble(),
      adult: json['adult'] ?? false,
      originalLanguage: json['original_language'],
      originalTitle: json['original_title'],
      runtime: json['runtime'],
      genres: json['genres'] != null
          ? (json['genres'] as List).map((g) => Genre.fromJson(g)).toList()
          : null,
      tagline: json['tagline'],
      status: json['status'],
      budget: json['budget'],
      revenue: json['revenue'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'vote_average': voteAverage,
      'vote_count': voteCount,
      'release_date': releaseDate,
      'genre_ids': genreIds,
      'popularity': popularity,
      'adult': adult,
      'original_language': originalLanguage,
      'original_title': originalTitle,
    };
  }

  String get fullPosterUrl =>
      posterPath != null ? 'https://image.tmdb.org/t/p/w500$posterPath' : '';

  String get fullBackdropUrl =>
      backdropPath != null ? 'https://image.tmdb.org/t/p/original$backdropPath' : '';

  String get year {
    if (releaseDate == null || releaseDate!.isEmpty) return '-';
    return releaseDate!.split('-').first;
  }

  String get formattedRating => voteAverage.toStringAsFixed(1);

  String get runtimeFormatted {
    if (runtime == null) return '-';
    final h = runtime! ~/ 60;
    final m = runtime! % 60;
    return h > 0 ? '${h}j ${m}m' : '${m}m';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Movie && other.id == id);

  @override
  int get hashCode => id.hashCode;
}

class Genre {
  final int id;
  final String name;

  Genre({required this.id, required this.name});

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(id: json['id'], name: json['name']);
  }
}
