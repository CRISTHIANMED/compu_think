import 'package:compu_think/models/entities/unit_entity.dart';
import 'package:compu_think/models/entities/view_detail_unit_entity.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UnitRepository {
  final supabase = Supabase.instance.client;

  // Método para obtener todas las unidades
  Future<List<UnitEntity>> fetchAll() async {
    try {
      // Realiza la consulta a la tabla 'unidad'
      final response = await supabase
          .from('unidad')
          .select()
          .order('orden', ascending: true);

      if (response.isEmpty) {
        return [];
      }

      return response.map((map) => UnitEntity.fromMap(map)).toList();
    } catch (e) {
      // Manejo de errores, si algo falla en la consulta o en el mapeo
      throw Exception(e);
    }
  }

  // Método para obtener solo los IDs de todas las unidades, ordenados por 'orden'
  Future<List<int>> fetchAllUnitIds() async {
    try {
      // Realiza la consulta a la tabla 'unidad' y selecciona solo el campo 'id'
      final response = await supabase
          .from('unidad')
          .select('id')
          .order('orden', ascending: true);

      if (response.isEmpty) {
        return [];
      }

      // Mapea los resultados y devuelve solo los IDs como una lista de enteros
      return (response as List).map((map) => map['id'] as int).toList();
    } catch (e) {
      // Manejo de errores
      throw Exception('Error al obtener los IDs de las unidades: $e');
    }
  }

  /// Obtiene una unidad específica por su ID
  Future<UnitEntity?> fetchUnitById(int id) async {
    try {
      final response =
          await supabase.from('unidad').select().eq('id', id).single();

      return UnitEntity.fromMap(response);
    } catch (e) {
      throw Exception('Error al obtener la unidad con id $id: $e');
    }
  }

  Future<List<ViewDetailUnitEntity>> fetchUnitsViewByPersonId(
      int personId) async {
    // Realiza la consulta a Supabase
    final response = await Supabase.instance.client
        .from('vista_detalles_unidad') // Nombre de tu vista
        .select()
        .eq('id_persona', personId)
        .order('unidad_orden', ascending: true);

    // Convertir los datos obtenidos a objetos ViewDetailUnitEntity
    List<ViewDetailUnitEntity> units = [];
    for (var unit in response) {
      units.add(ViewDetailUnitEntity.fromMap(unit));
    }

    // Asignar estado y colores según el tipo de estado
    for (var unit in units) {
      switch (unit.tipoEstadoDescripcion.toLowerCase()) {
        case 'pendiente':
          unit.isEnabled = true;
          unit.colorFondo = const Color.fromARGB(255, 235, 239, 115);
          break;
        case 'no_completado':
          unit.isEnabled = false;
          unit.colorFondo = const Color.fromARGB(255, 173, 171, 171);
          break;
        case 'completado':
          unit.isEnabled = true;
          unit.colorFondo = const Color.fromARGB(255, 71, 177, 74);
          break;
        default:
          unit.isEnabled = false;
          unit.colorFondo = const Color.fromARGB(255, 107, 106, 106);
      }
    }

    return units;
  }
}
