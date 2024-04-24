const String tableMovie = 'movies';

class MovieFields {
  static final List<String> values = [
    /// Add all fields
    id, title, dateAdded, coverLink, desc
  ];

  static const String id = '_id';
  static const String title = 'title';
  static const String dateAdded = 'date_added';
  static const String coverLink = 'cover_link';
  static const String desc = 'description';
}

class Movie {
  final int? id;
  final String title;
  final DateTime dateAdded;
  final String coverLink;
  final String desc;

  const Movie({
    this.id,
    required this.title,
    required this.dateAdded,
    required this.coverLink,
    required this.desc,
  });

  Movie copy({
    int? id,
    String? title,
    DateTime? dateAdded,
    String? coverLink,
    String? desc
  }) =>
      Movie(
          id: id ?? this.id,
          title: title ?? this.title,
          dateAdded: dateAdded ?? this.dateAdded,
          coverLink: coverLink ?? this.coverLink,
          desc: desc ?? this.desc
      );

  static Movie fromJson(Map<String, Object?> json) => Movie(
      id: json[MovieFields.id] as int?,
      title: json[MovieFields.title] as String,
      dateAdded: DateTime.parse(json[MovieFields.dateAdded] as String),
      coverLink: json[MovieFields.coverLink] as String,
      desc: json[MovieFields.desc] as String
  );

  Map<String, Object?> toJson() => {
    MovieFields.id: id,
    MovieFields.title: title,
    MovieFields.dateAdded: dateAdded.toIso8601String(),
    MovieFields.coverLink: coverLink,
    MovieFields.desc: desc
  };
}