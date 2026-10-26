import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/study_note.dart';

class StudyNoteService {
  final SupabaseClient supabase;

  StudyNoteService(this.supabase);

  Future<List<StudyNote>> getNotes() async {
    final response = await supabase
        .from('study_notes')
        .select()
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => StudyNote.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  Future<StudyNote> createNote(StudyNote note) async {
    final response = await supabase
        .from('study_notes')
        .insert(note.toJson())
        .select()
        .single();

    return StudyNote.fromJson(Map<String, dynamic>.from(response));
  }

  Future<StudyNote> updateNote(StudyNote note) async {
    if (note.id == null) {
      throw Exception('ID catatan tidak ditemukan');
    }

    final response = await supabase
        .from('study_notes')
        .update(note.toJson())
        .eq('id', note.id!)
        .select()
        .single();

    return StudyNote.fromJson(Map<String, dynamic>.from(response));
  }

  Future<void> deleteNote(int id) async {
    await supabase.from('study_notes').delete().eq('id', id);
  }
}
