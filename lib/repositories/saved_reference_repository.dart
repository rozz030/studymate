import '../models/study_material.dart';
import '../services/saved_reference_service.dart';

class SavedReferenceRepository {
  SavedReferenceRepository(this.service);

  final SavedReferenceService service;

  Future<List<StudyMaterial>> getSavedReferences() {
    return service.getSavedReferences();
  }

  Future<void> saveReference(StudyMaterial material) {
    return service.saveReference(material);
  }

  Future<void> removeReference(String referenceId) {
    return service.removeReference(referenceId);
  }
}
