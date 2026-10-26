import 'package:flutter/material.dart';

import '../models/study_note.dart';

class NoteProvider extends ChangeNotifier {
  final List<StudyNote> _notes = [];

  List<StudyNote> get notes => List.unmodifiable(_notes);

  void addNote({
    required String title,
    required String content,
    required String category,
    required String priority,
  }) {
    final note = StudyNote(
      title: title,
      content: content,
      category: category,
      priority: priority,
      createdAt: DateTime.now(),
    );

    _notes.insert(0, note);
    notifyListeners();
  }

  void updateNote({
    required StudyNote note,
    required String title,
    required String content,
    required String category,
    required String priority,
  }) {
    final index = _notes.indexOf(note);

    if (index == -1) {
      return;
    }

    final updatedNote = StudyNote(
      id: note.id,
      title: title,
      content: content,
      category: category,
      priority: priority,
      createdAt: note.createdAt,
    );

    _notes[index] = updatedNote;
    notifyListeners();
  }

  void deleteNote(StudyNote note) {
    _notes.remove(note);
    notifyListeners();
  }
}
