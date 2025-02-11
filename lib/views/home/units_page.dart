import 'package:cached_network_image/cached_network_image.dart';
import 'package:compu_think/controllers/unit_controller.dart';
import 'package:compu_think/models/entities/view_detail_unit_entity.dart';
import 'package:compu_think/utils/helper/convert_google_drive_link.dart';
import 'package:flutter/material.dart';
import 'package:compu_think/utils/widgets/custom_bottom_navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UnitsPage extends StatefulWidget {
  const UnitsPage({super.key});

  @override
  UnitsPageState createState() => UnitsPageState();
}

class UnitsPageState extends State<UnitsPage> {
  final UnitController _unitController = UnitController();
  List<ViewDetailUnitEntity> _unidades = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchUnits();
  }

  Future<void> fetchUnits() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final idString = prefs.getString('id');
      final int idPersona = idString != null ? int.parse(idString) : 0;

      final unidades =
          await _unitController.fetchUnitsViewByPersonId(idPersona);
      if (mounted) {
        setState(() {
          _unidades = unidades;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Unidades'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 15),
            if (_isLoading)
              const Expanded(
                child: Center(
                  child: Text('Cargando unidades...'),
                ),
              )
            else if (_errorMessage.isNotEmpty)
              Text('Error: $_errorMessage',
                  style: const TextStyle(color: Colors.red))
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _unidades.length,
                  itemBuilder: (ctx, index) {
                    final unidad = _unidades[index];
                    bool? isEnabled = unidad.isEnabled;
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isEnabled!
                            ? unidad.colorFondo
                            : unidad.colorFondo.withAlpha(153),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(color: Colors.black26, blurRadius: 5),
                        ],
                      ),
                      child: Row(
                        children: [
                          Opacity(
                            opacity: isEnabled ? 1.0 : 0.5,
                            child: ClipOval(
                              child: _buildImage(unidad.unidadUrlImagen),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Opacity(
                                  opacity: isEnabled ? 1.0 : 0.5,
                                  child: Text(
                                    'Unidad ${unidad.unidadOrden}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Opacity(
                                  opacity: isEnabled ? 1.0 : 0.5,
                                  child: Text(
                                    unidad.unidadNombre,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Opacity(
                                    opacity: isEnabled ? 1.0 : 0.5,
                                    child: Text(
                                      unidad.unidadDescripcion,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    )),
                                const SizedBox(height: 8),
                                Center(
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 50),
                                    child: ElevatedButton(
                                      onPressed: isEnabled
                                          ? () {
                                              Navigator.pushNamed(
                                                context,
                                                '/Tema',
                                                arguments: {
                                                  'id_persona':
                                                      unidad.idPersona,
                                                  'id_unidad': unidad.idUnidad,
                                                  'tituloUnidad':
                                                      'Unidad ${unidad.unidadOrden}',
                                                  'nombre': unidad.unidadNombre,
                                                  'descripcion':
                                                      unidad.unidadDescripcion,
                                                },
                                              );
                                            }
                                          : null,
                                      child: const Text('Ver'),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(
        currentIndex: 0,
      ),
    );
  }

  Widget _buildImage(String imageUrl) {
    try {
      final convertedUrl = convertGoogleDriveLink(imageUrl);
      return CachedNetworkImage(
        imageUrl: convertedUrl,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
        placeholder: (context, url) =>
            Image.asset('assets/images/placeholder.png', width: 100, height: 100), // Imagen por defecto
        errorWidget: (context, url, error) =>
            const Icon(Icons.broken_image, size: 50, color: Colors.grey), // Icono en caso de error
      );
    } catch (e) {
      return Image.asset('assets/images/placeholder.png', width: 100, height: 100);
    }
  }
}
