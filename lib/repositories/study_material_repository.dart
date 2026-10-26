import '../models/study_material.dart';
import '../services/open_library_service.dart';

class StudyMaterialRepository {
  StudyMaterialRepository(this.service);

  final OpenLibraryService service;

  Future<List<StudyMaterial>> searchMaterials(String query) {
    return service.searchMaterials(query);
  }
}
