import 'package:flutter/material.dart';
import '../db/database.dart';
import '../db/movie_model.dart';

class MovieForm extends StatefulWidget {
  final Movie? movie;

  const MovieForm({super.key, required this.movie});

  @override
  State<MovieForm> createState() => _MovieFormState();
}

class _MovieFormState extends State<MovieForm> {
  final _formKey = GlobalKey<FormState>();

  late String title;
  late String coverLink;
  late String desc;

  @override
  void initState() {
    super.initState();

    title = widget.movie?.title ?? '';
    coverLink = widget.movie?.coverLink ?? '';
    desc = widget.movie?.desc ?? '';
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [buildButton()],
        ),
        body: Form(
          key: _formKey,
          child: Column(
              children: [
                TextFormField(
                  maxLines: 1,
                  initialValue: title,
                  style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Title',
                    hintStyle: TextStyle(color: Colors.white70),
                  ),
                  validator: (title) => title != null && title.isEmpty
                      ? 'The title cannot be empty'
                      : null,
                  onChanged: (title) {
                    this.title = title;
                  },
                ),
                TextFormField(
                  maxLines: 2,
                  initialValue: coverLink,
                  style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Link of poster image',
                    hintStyle: TextStyle(color: Colors.white70),
                  ),
                  validator: (coverLink) => coverLink != null && coverLink.isEmpty
                      ? 'Must include an image link'
                      : null,
                  onChanged: (coverLink) {
                    this.coverLink = coverLink;
                  }
                ),
                TextFormField(
                  maxLines: 10,
                  initialValue: desc,
                  style: const TextStyle(color: Colors.white60, fontSize: 18),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Movie description',
                    hintStyle: TextStyle(color: Colors.white60),
                  ),
                  validator: (desc) => desc != null && desc.isEmpty
                      ? 'The description cannot be empty'
                      : null,
                    onChanged: (desc) {
                      this.desc = desc;
                    }
                ),
              ],
            ),
          ),
      );

  Widget buildButton() {
    final isFormValid = title.isNotEmpty && coverLink.isNotEmpty && desc.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.green,
          backgroundColor: isFormValid ? null : Colors.grey.shade700,
        ),
        onPressed: () => addOrUpdate(),
        child: const Text('Save'),
      ),
    );
  }

  void addOrUpdate() async {
    final bool isValid = _formKey.currentState!.validate();

    if (isValid) {
      final bool isUpdating = widget.movie != null;

      if (isUpdating) {
        await updateNote();
      } else {
        await addNote();
      }

      Navigator.of(context).pop();
    }
  }

  Future updateNote() async {
    final note = widget.movie!.copy(
        title: title,
        desc: desc,
        coverLink: coverLink);

    await MoviesDatabase.instance.update(note);
  }

  Future addNote() async {
    final note = Movie(
        title: title,
        desc: desc,
        coverLink: coverLink,
        dateAdded: DateTime.now());

    await MoviesDatabase.instance.create(note);
  }
}
