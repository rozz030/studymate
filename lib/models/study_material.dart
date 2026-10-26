class StudyMaterial {
  final String id;
  final String title;
  final String author;
  final int? publishYear;
  final String? coverUrl;
  final String source;

  const StudyMaterial({
    required this.id,
    required this.title,
    required this.author,
    this.publishYear,
    this.coverUrl,
    required this.source,
  });

  factory StudyMaterial.fromJson(Map<String, dynamic> json) {
    final authors = json['author_name'];

    String author = 'Unknown Author';

    if (authors is List && authors.isNotEmpty) {
      author = authors.first.toString();
    }

    final coverId = json['cover_i'];

    return StudyMaterial(
      id: json['key']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Untitled',
      author: author,
      publishYear: json['first_publish_year'] is int
          ? json['first_publish_year'] as int
          : int.tryParse(json['first_publish_year']?.toString() ?? ''),
      coverUrl: coverId != null
          ? 'https://covers.openlibrary.org/b/id/$coverId-M.jpg'
          : null,
      source: 'Open Library',
    );
  }
}
