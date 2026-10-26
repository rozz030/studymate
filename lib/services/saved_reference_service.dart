import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/study_material.dart';

class SavedReferenceService {
  SavedReferenceService(this.supabase);

  final SupabaseClient supabase;

  // ============================================================
  // GET SAVED REFERENCES
  // ============================================================

  Future<List<StudyMaterial>> getSavedReferences() async {
    final response = await supabase
        .from('saved_references')
        .select()
        .order('created_at', ascending: false);

    return (response as List).map((json) {
      return StudyMaterial(
        id: json['reference_id']?.toString() ?? '',
        title: json['title']?.toString() ?? 'Untitled',
        author: json['author']?.toString() ?? 'Unknown Author',
        publishYear: json['publish_year'] is int
            ? json['publish_year'] as int
            : int.tryParse(json['publish_year']?.toString() ?? ''),
        coverUrl: json['cover_url']?.toString(),
        source: json['source']?.toString() ?? 'Open Library',
      );
    }).toList();
  }

  // ============================================================
  // SAVE REFERENCE
  // ============================================================

  Future<void> saveReference(StudyMaterial material) async {
    final existing = await supabase
        .from('saved_references')
        .select('id')
        .eq('reference_id', material.id)
        .maybeSingle();

    if (existing != null) {
      return;
    }

    await supabase.from('saved_references').insert({
      'reference_id': material.id,
      'title': material.title,
      'author': material.author,
      'publish_year': material.publishYear,
      'cover_url': material.coverUrl,
      'source': material.source,
    });
  }

  // ============================================================
  // REMOVE REFERENCE
  // ============================================================

  Future<void> removeReference(String referenceId) async {
    await supabase
        .from('saved_references')
        .delete()
        .eq('reference_id', referenceId);
  }
}
