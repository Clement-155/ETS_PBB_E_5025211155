import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../db/database.dart';
import '../db/movie_model.dart';
import 'movie_detail.dart';
import 'movie_form.dart';

class MovieList extends StatefulWidget {
  const MovieList({super.key});

  @override
  State<MovieList> createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  late List<Movie> movies;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refresh();
  }

  @override
  void dispose() {
    MoviesDatabase.instance.close();

    super.dispose();
  }

  Future refresh() async {
    setState(() => isLoading = true);

    movies = await MoviesDatabase.instance.readAllNotes();
    print(movies.toString());
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text(
        'Movie Database - 5025211155',
        style: TextStyle(fontSize: 24, color: Colors.white),
      ),
      actions: const [Icon(Icons.search), SizedBox(width: 12)],
    ),
    body: Center(
      child: isLoading
          ? const CircularProgressIndicator()
          : movies.isEmpty
          ? const Text(
        'No Movies',
        style: TextStyle(color: Colors.white, fontSize: 24),
      )
          : buildList(),
    ),
    floatingActionButton: FloatingActionButton(
      backgroundColor: Colors.black,
      child: const Icon(Icons.add),
      onPressed: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const MovieForm(movie: null)),
        );

        refresh();
      },
    ),
  );

  Widget buildList() => ListView.builder(
      itemCount: movies.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(movies[index].title,
              style: TextStyle(
                color: Colors.white
              )

          ),
          subtitle: Text(DateFormat.yMd().format(movies[index].dateAdded)),
          leading: Image.network(movies[index].coverLink),
          onTap: () async {
            await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => MovieDetailPage(id: movies[index].id!),
            ));

            refresh();
          },
        );
      });


}
