class Movie {
  final String movie;
  final String description;
  Movie({
    required this.movie,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'movie': movie,
      'description': description,
    };
  }

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      movie: map['movie'] as String,
      description: map['description'] as String,
    );
  }
}
