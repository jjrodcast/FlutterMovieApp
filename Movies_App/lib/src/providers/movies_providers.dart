import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:three_movies_app/src/models/actor_model.dart';
import 'package:three_movies_app/src/models/movie_model.dart';

class MoviesProvider {
  String _apiKey = 'api_key'; //Api key from https://www.themoviedb.org/
  String _nowPlayingPath = '3/movie/now_playing';
  String _popularMoviesPath = '3/movie/popular';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';

  int _popularsPage = 0;
  bool _isLoadingData = false;

  List<Movie> _popularMovies = [];

  final _popularMoviesStreamController =
      StreamController<List<Movie>>.broadcast();

  Function(List<Movie>) get popularMoviesSink =>
      _popularMoviesStreamController.sink.add;

  Stream<List<Movie>> get popularMoviesStream =>
      _popularMoviesStreamController.stream;

  void dispose() {
    _popularMoviesStreamController?.close();
  }

  Future<List<Movie>> _getMoviesResponse(Uri url) async {
    final response = await http.get(url);
    final decodedData = json.decode(response.body);
    return MovieResponse.fromJsonList(decodedData['results']).movies;
  }

  Future<List<Movie>> getMoviesNowPlaying() async {
    final url = Uri.https(
        _url, _nowPlayingPath, {'api_key': _apiKey, 'language': _language});
    return await _getMoviesResponse(url);
  }

  Future<List<Movie>> getPopularMovies() async {
    if (_isLoadingData) return [];

    _isLoadingData = true;

    _popularsPage++;
    final url = Uri.https(_url, _popularMoviesPath, {
      'api_key': _apiKey,
      'language': _language,
      'page': _popularsPage.toString(),
    });

    final response = await _getMoviesResponse(url);

    _popularMovies.addAll(response);
    popularMoviesSink(_popularMovies);
    _isLoadingData = false;

    return response;
  }

  Future<List<Actor>> getCasts(String movieId) async {
    final path = '3/movie/$movieId/credits';
    final uri = Uri.https(_url, path, {
      'api_key': _apiKey,
      'langugage': _language,
    });

    final response = await http.get(uri);
    final decodedData = json.decode(response.body);
    return ActorResponse.fromJsonList(decodedData['cast']).casts;
  }

  Future<List<Movie>> searchMovies(String query) async {
    final uri = Uri.https(
      _url,
      '3/search/movie',
      {
        'api_key': _apiKey,
        'language': _language,
        'query': query,
      },
    );
    return await _getMoviesResponse(uri);
  }
}
