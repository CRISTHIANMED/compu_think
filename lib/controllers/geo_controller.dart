import 'package:compu_think/models/repositories/georeference_repository.dart';
import 'package:latlong2/latlong.dart';

class GeoController {
  final GeoreferenceRepository _georeferenceRepository = GeoreferenceRepository();

  Future<Map<int, LatLng>> fetchGeoreferencesByTipoReto(int idTipoReto) async {
  try {
    final georeferences = await _georeferenceRepository.getAllbyIdUnidad(idTipoReto);

    // Creamos un Map para almacenar el resultado final
    final Map<int, LatLng> result = {};

    // Iteramos sobre cada entidad y agregamos la entrada en el mapa.
    // Usamos geo.idRetoPregunta como llave y un objeto LatLng como valor.
    for (var geo in georeferences) {
      result[geo.idRetoPregunta] = LatLng(geo.latitud, geo.longitud);
    }

    return result;
  } catch (e) {
    // Se propaga la excepción con un mensaje descriptivo en caso de error.
    throw Exception('Error al obtener georeferencias: $e');
  }
}
}