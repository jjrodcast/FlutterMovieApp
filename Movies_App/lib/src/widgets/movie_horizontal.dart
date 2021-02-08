import 'package:flutter/material.dart';

import 'package:three_movies_app/src/models/movie_model.dart';

class MovieHorizontal extends StatelessWidget {
  final List<Movie> movies;
  final Function loadNextPage;

  final _pageController = PageController(
    initialPage: 1,
    viewportFraction: 0.3,
  );

  MovieHorizontal({@required this.movies, @required this.loadNextPage});

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    _pageController.addListener(() {
      if (_pageController.position.pixels >=
          _pageController.position.maxScrollExtent - 200) {
        loadNextPage();
      }
    });

    return Container(
      height: _screenSize.height * 0.25,
      child: PageView.builder(
        itemCount: movies.length,
        controller: _pageController,
        itemBuilder: (context, index) {
          return _createCard(context, movies[index]);
        },
      ),
    );
  }

  Widget _createCard(BuildContext context, Movie movie) {
    movie.uniqueId = "${movie.id}-popular";
    final movieCard = Container(
      margin: EdgeInsets.only(right: 12.0),
      child: Column(
        children: [
          Hero(
            tag: movie.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                height: 160.0,
                width: double.infinity,
                image: NetworkImage(movie.getPoster()),
                placeholder: AssetImage('assets/img/no-image.jpg'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          SizedBox(height: 6.0),
          Text(
            movie.title,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );

    return GestureDetector(
      child: movieCard,
      onTap: () {
        Navigator.pushNamed(context, 'detail', arguments: movie);
      },
    );
  }
}
