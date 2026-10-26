import 'package:flutter/foundation.dart';

import '../models/study_material.dart';
import '../repositories/study_material_repository.dart';
import '../repositories/saved_reference_repository.dart';

class StudyProvider extends ChangeNotifier {
  StudyProvider(this.repository, this.savedRepository) {
    loadSavedReferences();
  }

  final StudyMaterialRepository repository;
  final SavedReferenceRepository savedRepository;

  // ============================================================
  // SEARCH MATERIALS
  // ============================================================

  List<StudyMaterial> _materials = [];

  bool _isLoading = false;

  String? _error;

  String _query = '';

  List<StudyMaterial> get materials => _materials;

  bool get isLoading => _isLoading;

  String? get error => _error;

  String get query => _query;

  // ============================================================
  // SAVED MATERIALS
  // ============================================================

  List<StudyMaterial> _savedMaterials = [];

  bool _isSavedLoading = false;

  List<StudyMaterial> get savedMaterials => _savedMaterials;

  bool get isSavedLoading => _isSavedLoading;

  bool isSaved(StudyMaterial material) {
    return _savedMaterials.any((item) => item.id == material.id);
  }

  // ============================================================
  // LOAD SAVED REFERENCES
  // ============================================================

  Future<void> loadSavedReferences() async {
    _isSavedLoading = true;
    _error = null;

    notifyListeners();

    try {
      _savedMaterials = await savedRepository.getSavedReferences();
    } catch (e) {
      _savedMaterials = [];
      _error = 'Failed to load saved references: $e';

      debugPrint('LOAD SAVED REFERENCES ERROR: $e');
    } finally {
      _isSavedLoading = false;
      notifyListeners();
    }
  }

  // ============================================================
  // SAVE / REMOVE REFERENCE
  // ============================================================

  Future<void> toggleSaved(StudyMaterial material) async {
    _error = null;

    final currentlySaved = isSaved(material);

    try {
      // ========================================================
      // REMOVE REFERENCE
      // ========================================================

      if (currentlySaved) {
        debugPrint('REMOVE SAVED REFERENCE: ${material.id}');

        await savedRepository.removeReference(material.id);

        _savedMaterials.removeWhere((item) => item.id == material.id);

        debugPrint('REMOVE SUCCESS: ${material.id}');
      }
      // ========================================================
      // SAVE REFERENCE
      // ========================================================
      else {
        debugPrint('SAVE REFERENCE: ${material.id}');

        await savedRepository.saveReference(material);

        _savedMaterials.add(material);

        debugPrint('SAVE SUCCESS: ${material.id}');
      }

      notifyListeners();
    } catch (e) {
      _error = 'Failed to update saved reference: $e';

      debugPrint('TOGGLE SAVED ERROR: $e');

      notifyListeners();

      rethrow;
    }
  }

  // ============================================================
  // SEARCH
  // ============================================================

  Future<void> searchMaterials(String query) async {
    final trimmedQuery = query.trim();

    if (trimmedQuery.isEmpty) {
      _materials = [];
      _query = '';
      _error = null;

      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    _query = trimmedQuery;

    notifyListeners();

    try {
      _materials = await repository.searchMaterials(trimmedQuery);
    } catch (e) {
      _materials = [];
      _error = 'Failed to load study materials: $e';

      debugPrint('SEARCH ERROR: $e');
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

  // ============================================================
  // CLEAR SEARCH
  // ============================================================

  void clearSearch() {
    _materials = [];
    _query = '';
    _error = null;

    notifyListeners();
  }
}
