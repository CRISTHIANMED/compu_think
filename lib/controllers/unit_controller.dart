// ignore_for_file: avoid_print

import 'package:compu_think/models/entities/unit_entity.dart';
import 'package:compu_think/models/entities/view_detail_unit_entity.dart';
import 'package:compu_think/models/repositories/user_challenge_repository.dart';
import 'package:compu_think/models/repositories/user_unit_repository.dart';
import 'package:compu_think/models/repositories/unit_repository.dart';

class UnitController {
  final UnitRepository _unitRepository = UnitRepository();
  final UserUnitRepository _userUnitRepository = UserUnitRepository();
  final UserChallengeRepository _userChallengeRepository =
      UserChallengeRepository();

  // Método para obtener las unidades
  Future<List<UnitEntity>> fetchUnits() {
    try {
      return _unitRepository.fetchAll();
    } catch (e) {
      // Manejar el error (se puede lanzar una excepción o devolver una lista vacía)
      throw Exception('Error al obtener las unidades: $e');
    }
  }

  // Método para obtener las ids unidades
  Future<List<int>> fetchAllUnitIds() {
    try {
      return _unitRepository.fetchAllUnitIds();
    } catch (e) {
      // Manejar el error (se puede lanzar una excepción o devolver una lista vacía)
      throw Exception('Error al obtener las ids de unidades: $e');
    }
  }

  Future<void> initializeUserUnits(int idPersona, List<int> idUnidades,
      List<Map<String, dynamic>> idsRetos) async {
    try {
      // Verificar si la tabla 'persona_unidad' ya tiene registros para este usuario
      final existingRecordsUserUnit =
          await _userUnitRepository.fetchUserUnitsByPersonaId(idPersona);

      final existingRecordsChallenge =
          await _userChallengeRepository.fetchByPersonaId(idPersona);

      if (existingRecordsUserUnit.isEmpty && existingRecordsChallenge.isEmpty) {
        print(
            'Datos insertados correctamente para el usuario con id $idPersona.');
        insertarRegistrosUnidadPersona(idPersona, idUnidades);
        insertarRegistrosRetoPersona(idPersona, idsRetos);
        return;
      }

      if (existingRecordsUserUnit.isEmpty &&
          existingRecordsChallenge.isNotEmpty) {
        print(
            'Datos insertados correctamente para el usuario con id $idPersona.');
        insertarRegistrosUnidadPersona(idPersona, idUnidades);
        return;
      }

      if (existingRecordsUserUnit.isNotEmpty &&
          existingRecordsChallenge.isEmpty) {
        print(
            'Datos insertados correctamente para el usuario con id $idPersona.');
        insertarRegistrosRetoPersona(idPersona, idsRetos);
        return;
      }

      print(
          'La tabla ya tiene registros para el usuario con id $idPersona. No se realizará ninguna inserción.');
    } catch (e) {
      // Manejo de errores
      throw Exception(
          'Ocurrió un error al inicializar las unidades del usuario: $e');
    }
  }

  Future<void> insertarRegistrosUnidadPersona(
      int idPersona, List<int> idUnidades) async {
    try {
      // Verificar que la lista no esté vacía
      if (idUnidades.isEmpty) {
        print("Error: La lista de unidades está vacía.");
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
              : 3, // Primera unidad en progreso, las demás pendientes
          'fecha_inicio': i == 0
              ? DateTime.now()
                  .toUtc()
                  .toIso8601String() // Solo para la primera unidad
              : null,
        });
      }

      // Intentar insertar los registros en la base de datos
      await _userUnitRepository.insertUserUnit(registros);
      print("Registros insertados correctamente.");
    } catch (e) {
      throw Exception("Error al insertar registros en la base de datos: $e");
    }
  }

  Future<void> insertarRegistrosRetoPersona(
      int idPersona, List<Map<String, dynamic>> idsRetos) async {
    try {
      final List<Map<String, dynamic>> registros = [];

      for (var reto in idsRetos) {
        if (reto.containsKey('id') && reto.containsKey('id_tipo_reto')) {
          registros.add({
            'id_persona': idPersona,
            'id_reto': reto['id'],
            'id_tipo_estado': (reto['id_tipo_reto'] == 1) ? 2 : 3,
          });
        } else {
          print("Error: Datos de reto incompletos: $reto");
        }
      }

      if (registros.isNotEmpty) {
        await _userChallengeRepository.insert(registros);
        print("Registros insertados correctamente.");
      } else {
        print("No hay registros válidos para insertar.");
      }
    } catch (e) {
      throw Exception("Error al insertar registros en la base de datos: $e");
    }
  }

  Future<List<ViewDetailUnitEntity>> fetchUnitsViewByPersonId(
      int personId) async {
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
