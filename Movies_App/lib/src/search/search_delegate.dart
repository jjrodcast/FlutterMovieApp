import 'package:flutter/material.dart';

import 'package:three_movies_app/src/models/movie_model.dart';
import 'package:three_movies_app/src/providers/movies_providers.dart';

class MovieSearch extends SearchDelegate {
  String selection = '';

  final moviesProvider = MoviesProvider();

  final movies = [
    "Movie 1",
    "Movie 2",
    "Movie 3",
    "Movie 4",
    "Movie 5",
    "Movie 6",
  ];

  final recentMovies = [
    'Movie 4',
    'Movie 3',
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    // Acciones de nuestro appbar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda del appbar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Builder que crea los resultados a mostrar
    return Center(
      child: Container(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Sugerencias que aparecen al escribir.
    /*
    // Temporal
    final suggestedList = (query.isEmpty)
        ? recentMovies
        : movies
            .where(
                (movie) => movie.toLowerCase().startsWith(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemCount: suggestedList.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.movie),
          title: Text(suggestedList[index]),
          onTap: () {
            selection = suggestedList[index];
            showResults(context);
          },
        );
      },
    );*/

    if (query.isEmpty) {
      return Container();
    }
    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
        if (snapshot.hasData) {
          final movies = snapshot.data;
          return ListView(
            children: movies.map((movie) {
              return ListTile(
                leading: FadeInImage(
                  fit: BoxFit.cover,
                  width: 50.0,
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  image: NetworkImage(movie.getPoster()),
                ),
                title: Text(movie.title),
                subtitle: Text(movie.originalTitle),
                onTap: () {
                  close(context, null);
                  movie.uniqueId = '';
                  Navigator.pushNamed(context, 'detail', arguments: movie);
                },
              );
            }).toList(),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
      future: moviesProvider.searchMovies(query),
    );
  }
}
