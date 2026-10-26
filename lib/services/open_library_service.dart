import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/study_material.dart';

class OpenLibraryService {
  OpenLibraryService();

  static const String _baseUrl = 'https://openlibrary.org/search.json';

  Future<List<StudyMaterial>> searchMaterials(String query) async {
    final uri = Uri.parse(
      '$_baseUrl?q=${Uri.encodeQueryComponent(query)}'
      '&limit=20'
      '&fields=key,title,author_name,first_publish_year,cover_i,editions',
    );

    try {
      final response = await http
          .get(
            uri,
            headers: const {
              'Accept': 'application/json',
              'User-Agent': 'StudyMate/1.0',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception(
          'Open Library API returned status ${response.statusCode}',
        );
      }

      final Map<String, dynamic> data =
          jsonDecode(response.body) as Map<String, dynamic>;

      final List<dynamic> docs = data['docs'] as List<dynamic>? ?? [];

      return docs
          .map((json) => _convertToStudyMaterial(json as Map<String, dynamic>))
          .toList();
    } on http.ClientException catch (e) {
      throw Exception('Unable to connect to Open Library: $e');
    } on FormatException {
      throw Exception('Invalid response from Open Library.');
    } catch (e) {
      throw Exception('Failed to load study materials: $e');
    }
  }

  StudyMaterial _convertToStudyMaterial(Map<String, dynamic> json) {
    final authors = json['author_name'];

    String author = 'Unknown Author';

    if (authors is List && authors.isNotEmpty) {
      author = authors.first.toString();
    }

    final coverId = json['cover_i'];

    String id = json['key']?.toString() ?? '';

    final editions = json['editions'];

    if (editions is Map<String, dynamic>) {
      final editionDocs = editions['docs'];

      if (editionDocs is List && editionDocs.isNotEmpty) {
        final firstEdition = editionDocs.first;

        if (firstEdition is Map<String, dynamic>) {
          final editionKey = firstEdition['key'];

          if (editionKey != null) {
            id = editionKey.toString();
          }
        }
      }
    }

    return StudyMaterial(
      id: id,
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
