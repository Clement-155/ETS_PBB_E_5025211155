import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../db/database.dart';
import '../db/movie_model.dart';
import './movie_form.dart';

class MovieDetailPage extends StatefulWidget {
  final int id;
  const MovieDetailPage({super.key, required this.id});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  late Movie movie;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refresh();
  }

  Future refresh() async {
    setState(() => isLoading = true);

    movie = await MoviesDatabase.instance.readMovie(widget.id);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      actions: [editButton(), deleteButton()],
    ),
    body: isLoading
        ? const Center(child: CircularProgressIndicator())
        : Padding(
      padding: const EdgeInsets.all(12),
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          Image.network(movie.coverLink),
          Text(
            movie.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            DateFormat.yMd().format(movie.dateAdded),
            style: const TextStyle(color: Colors.white38),
          ),
          const SizedBox(height: 8),
          Text(
            movie.desc,
            style:
            const TextStyle(color: Colors.white70, fontSize: 18),
          )
        ],
      ),
    ),
  );

  Widget editButton() => IconButton(
      icon: const Icon(Icons.edit_outlined),
      onPressed: () async {
        if (isLoading) return;

        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MovieForm(movie: movie),
        ));

        refresh();
      });

  Widget deleteButton() => IconButton(
    icon: const Icon(Icons.delete),
    onPressed: () async {
      await MoviesDatabase.instance.delete(widget.id);

      Navigator.of(context).pop();
    },
  );
}
