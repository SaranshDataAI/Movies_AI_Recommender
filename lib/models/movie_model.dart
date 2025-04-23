class MovieModel {
  final String title;
  final String posterUrl;
  final String overview;
  final String releaseDate;
  final double rating;

  MovieModel({
    required this.title,
    required this.posterUrl,
    required this.overview,
    required this.releaseDate,
    required this.rating,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      title: json['title'] ?? 'Unknown',
      posterUrl: json['poster_url'] ?? '',
      overview: json['overview'] ?? 'No description available.',
      releaseDate: json['release_date'] ?? 'Unknown',
      rating: (json['rating'] ?? 0).toDouble(),
    );
  }
}
