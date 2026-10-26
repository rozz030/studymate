import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/study_material.dart';

class OpenLibraryService {
  OpenLibraryService();

  static const String _baseUrl = 'https://openlibrary.org/search.json';

  Future<List<StudyMaterial>> searchMaterials(String query) async {
    final uri = Uri.parse(
      '$_baseUrl?q=${Uri.encodeQueryComponent(query)}&limit=20',
    );

    try {
      final response = await http
          .get(uri, headers: const {'Accept': 'application/json'})
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
          .map((json) => StudyMaterial.fromJson(json as Map<String, dynamic>))
          .toList();
    } on http.ClientException catch (e) {
      throw Exception('Unable to connect to Open Library: $e');
    } on FormatException {
      throw Exception('Invalid response from Open Library.');
    } catch (e) {
      throw Exception('Failed to load study materials: $e');
    }
  }
}
