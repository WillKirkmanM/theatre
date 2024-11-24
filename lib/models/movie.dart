class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final String releaseDate;
  final double voteAverage;
  final int voteCount;
  final double popularity;
  final String originalTitle;
  final String originalLanguage;
  final bool adult;
  final List<int> genreIds;
  final bool video;
  final int? budget;
  final int? revenue;
  final int? runtime;
  final String? tagline;
  final String? status;
  final List<Map<String, dynamic>>? cast;
  final List<Map<String, dynamic>>? videos;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.releaseDate,
    required this.voteAverage,
    required this.voteCount,
    required this.popularity,
    required this.originalTitle,
    required this.originalLanguage,
    required this.adult,
    required this.genreIds,
    required this.video,
    this.budget,
    this.revenue,
    this.runtime,
    this.tagline,
    this.status,
    this.cast,
    this.videos,
  });
}