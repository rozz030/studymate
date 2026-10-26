import 'package:flutter/material.dart';

import '../models/study_note.dart';
import '../repositories/study_note_repository.dart';

class NoteProvider extends ChangeNotifier {
  final StudyNoteRepository repository;

  NoteProvider(this.repository);

  final List<StudyNote> _notes = [];

  List<StudyNote> get notes => List.unmodifiable(_notes);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSaving = false;
  bool get isSaving => _isSaving;

  String? _error;
  String? get error => _error;

  Future<void> loadNotes() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final notes = await repository.getNotes();

      _notes
        ..clear()
        ..addAll(notes);
    } catch (e) {
      _error = 'Gagal memuat catatan: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addNote({
    required String title,
    required String content,
    required String category,
    required String priority,
  }) async {
    _isSaving = true;
    _error = null;
    notifyListeners();

    try {
      final note = StudyNote(
        title: title,
        content: content,
        category: category,
        priority: priority,
        createdAt: DateTime.now(),
      );

      final createdNote = await repository.createNote(note);

      _notes.insert(0, createdNote);
    } catch (e) {
      _error = 'Gagal menambahkan catatan: $e';
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<void> updateNote({
    required StudyNote note,
    required String title,
    required String content,
    required String category,
    required String priority,
  }) async {
    _isSaving = true;
    _error = null;
    notifyListeners();

    try {
      final updatedNote = StudyNote(
        id: note.id,
        title: title,
        content: content,
        category: category,
        priority: priority,
        createdAt: note.createdAt,
      );

      final result = await repository.updateNote(updatedNote);

      final index = _notes.indexOf(note);

      if (index != -1) {
        _notes[index] = result;
      }
    } catch (e) {
      _error = 'Gagal memperbarui catatan: $e';
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<void> deleteNote(StudyNote note) async {
    if (note.id == null) {
      return;
    }

    _error = null;

    try {
      await repository.deleteNote(note.id!);

      _notes.remove(note);
      notifyListeners();
    } catch (e) {
      _error = 'Gagal menghapus catatan: $e';
      notifyListeners();
    }
  }
}
