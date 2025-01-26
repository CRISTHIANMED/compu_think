// ignore_for_file: avoid_print

import 'package:compu_think/models/entities/unit_entity.dart';
import 'package:compu_think/models/entities/view_detail_unit_entity.dart';
import 'package:compu_think/models/repositories/user_unit_repository.dart';
import 'package:compu_think/models/repositories/unit_repository.dart';

class UnitController {
  final UnitRepository _unitRepository = UnitRepository();
  final UserUnitRepository _userUnitRepository = UserUnitRepository();

  // Método para obtener las unidades
  Future<List<UnitEntity>> fetchUnits() {
    try {
      return _unitRepository.fetchAll();
    } catch (e) {
      // Manejar el error (se puede lanzar una excepción o devolver una lista vacía)
      throw Exception('Error al obtener las unidades: $e');
    }
  }

  // Método para obtener las unidades
  Future<List<int>> fetchAllUnitIds() {
    try {
      return _unitRepository.fetchAllUnitIds();
    } catch (e) {
      // Manejar el error (se puede lanzar una excepción o devolver una lista vacía)
      throw Exception('Error al obtener las ids de unidades: $e');
    }
  }

  Future<void> initializeUserUnits(int idPersona, List<int> idUnidades) async {
    try {
      // Verificar si la tabla `persona_unidad` ya tiene registros para este usuario
      final existingRecords =
          await _userUnitRepository.fetchUserUnitsByPersonaId(idPersona);

      // Si ya existen registros, no hacer nada
      if (existingRecords.isNotEmpty) {
        print(
            'La tabla ya tiene registros para el usuario con id $idPersona. No se realizará ninguna inserción.');
        return;
      }

      // Crear lista de registros para insertar
      final List<Map<String, dynamic>> registros = [];
      for (int i = 0; i < idUnidades.length; i++) {
        registros.add({
          'id_persona': idPersona,
          'id_unidad': idUnidades[i],
          'id_tipo_estado': i == 0
              ? 2
              : 3, // Primera unidad pendiente, las demás no completadas
          'fecha_inicio': i == 0
              ? DateTime.now()
                  .toUtc()
                  .toIso8601String() // Solo para la primera unidad
              : null, // O asigna otro valor si es necesario para las demás unidades
        });
      }

      // Insertar registros en la tabla
      await _userUnitRepository.insertUserUnit(registros);

      print(
          'Datos insertados correctamente para el usuario con id $idPersona.');
    } catch (e) {
      // Manejo de errores
      throw Exception(
          'Ocurrió un error al inicializar las unidades del usuario: $e');
    }
  }

  Future<List<ViewDetailUnitEntity>> fetchUnitsViewByPersonId(int personId) async {
    try {
      // Llama al método del repositorio para obtener las unidades
      final units = await _unitRepository.fetchUnitsViewByPersonId(personId);

      // Si necesitas realizar lógica adicional en el controlador, la agregas aquí
      return units;
    } catch (e) {
      // Manejo del error
      throw Exception('Ocurrió un error al obtener las unidades: $e');
    }
  }
}
