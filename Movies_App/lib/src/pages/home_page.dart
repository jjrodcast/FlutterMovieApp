import 'package:flutter/material.dart';

import 'package:three_movies_app/src/models/movie_model.dart';
import 'package:three_movies_app/src/providers/movies_providers.dart';
import 'package:three_movies_app/src/search/search_delegate.dart';
import 'package:three_movies_app/src/widgets/card_swiper_widget.dart';
import 'package:three_movies_app/src/widgets/movie_horizontal.dart';

class HomePage extends StatelessWidget {
  final moviesProvider = MoviesProvider();

  @override
  Widget build(BuildContext context) {
    moviesProvider.getPopularMovies();
    return Scaffold(
      appBar: AppBar(
        title: Text('Cinema Movies'),
        backgroundColor: Colors.indigoAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: MovieSearch(),
              );
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _createSwipeCards(),
            _footer(context),
          ],
        ),
      ),
    );
  }

  Widget _createSwipeCards() {
    return FutureBuilder(
        future: moviesProvider.getMoviesNowPlaying(),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if (snapshot.hasData) {
            return CardSwiper(movies: snapshot.data.cast<Movie>());
          } else {
            return Container(
              height: 500.0,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }

  Widget _footer(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 24.0),
            child:
                Text('Populares', style: Theme.of(context).textTheme.subtitle1),
          ),
          SizedBox(height: 10.0),
          StreamBuilder(
              stream: moviesProvider.popularMoviesStream,
              builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                if (snapshot.hasData) {
                  return MovieHorizontal(
                    movies: snapshot.data.cast<Movie>(),
                    loadNextPage: moviesProvider.getPopularMovies,
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ],
      ),
    );
  }
}
