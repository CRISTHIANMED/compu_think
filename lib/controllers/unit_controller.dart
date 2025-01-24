import 'package:compu_think/models/entities/unit_entity.dart';
import 'package:compu_think/models/repositories/unit_repository.dart';

class UnitController {
  final UnitRepository _unitRepository;

  UnitController(this._unitRepository);

  // Método para obtener las unidades
  Future<List<UnitEntity>> fetchUnits() {
    try {
      return _unitRepository.fetchAll();
    } catch (e) {
      // Manejar el error (se puede lanzar una excepción o devolver una lista vacía)
      throw Exception('Error al obtener las unidades: $e');
    }
  }
}
