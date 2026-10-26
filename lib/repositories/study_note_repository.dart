import '../models/study_note.dart';
import '../services/study_note_service.dart';

class StudyNoteRepository {
  final StudyNoteService service;

  StudyNoteRepository(this.service);

  Future<List<StudyNote>> getNotes() {
    return service.getNotes();
  }

  Future<StudyNote> createNote(StudyNote note) {
    return service.createNote(note);
  }

  Future<StudyNote> updateNote(StudyNote note) {
    return service.updateNote(note);
  }

  Future<void> deleteNote(int id) {
    return service.deleteNote(id);
  }
}
