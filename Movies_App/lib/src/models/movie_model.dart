import 'dart:convert';

class MovieResponse {
  List<Movie> movies = List();

  MovieResponse();

  MovieResponse.fromJsonList(List<dynamic> jsonList) {
    if (json == null) return;

    for (var item in jsonList) {
      final movie = Movie.fromJsonMap(item);
      movies.add(movie);
    }
  }
}

class Movie {
  String uniqueId;
  int id;
  String title;
  bool adult;
  String backdropPath;
  List<int> genreIds;
  String originalLanguage;
  String originalTitle;
  String overview;
  double popularity;
  String posterPath;
  String relaseDate;
  bool video;
  double voteAverage;
  int voteCount;

  Movie(
      {this.id,
      this.title,
      this.adult,
      this.backdropPath,
      this.genreIds,
      this.originalLanguage,
      this.originalTitle,
      this.overview,
      this.popularity,
      this.posterPath,
      this.relaseDate,
      this.video,
      this.voteAverage,
      this.voteCount});

  Movie.fromJsonMap(Map<String, dynamic> json) {
    this.id = json['id'];
    this.title = json['title'];
    this.adult = json['adult'];
    this.backdropPath = json['backdrop_path'];
    this.genreIds = json['genre_ids'].cast<int>();
    this.originalLanguage = json['original_language'];
    this.originalTitle = json['original_title'];
    this.overview = json['overview'];
    this.popularity = json['popularity'] / 1;
    this.posterPath = json['poster_path'];
    this.relaseDate = json['release_date'];
    this.video = json['video'];
    this.voteAverage = json['vote_average'] / 1;
    this.voteCount = json['vote_count'];
  }

  String getPoster() {
    if (posterPath == null) {
      return 'https://artgalleryofballarat.com.au/wp-content/uploads/2020/06/placeholder-image.png';
    }
    return 'https://image.tmdb.org/t/p/w500/$posterPath';
  }

  String getBackgroundImage() {
    if (backdropPath == null) {
      return 'https://artgalleryofballarat.com.au/wp-content/uploads/2020/06/placeholder-image.png';
    }
    return 'https://image.tmdb.org/t/p/w500/$backdropPath';
  }
}
