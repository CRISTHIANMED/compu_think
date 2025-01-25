import 'package:compu_think/controllers/unit_controller.dart';
import 'package:compu_think/models/repositories/unit_repository.dart';
import 'package:compu_think/models/repositories/user_unit_repository.dart';
import 'package:flutter/material.dart';
import 'package:compu_think/models/entities/unit_entity.dart';
import 'package:compu_think/utils/widgets/custom_bottom_navigation_bar.dart';

class UnitsPage extends StatefulWidget {
  const UnitsPage({super.key});

  @override
  _UnitsPageState createState() => _UnitsPageState();
}

class _UnitsPageState extends State<UnitsPage> {
  final UnitController _unitController = UnitController() ;
  List<UnitEntity> _unidades = [];
  bool _isLoading = true;
  String _errorMessage = '';
  bool isEnabled = true;

  @override
  void initState() {
    super.initState();
    // Cargar las unidades al iniciar la página
    fetchUnits();
  }

  Future<void> fetchUnits() async {
    try {
      final unidades = await _unitController.fetchUnits();
      setState(() {
        _unidades = unidades;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
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
                  child: CircularProgressIndicator(),
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
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isEnabled
                            ? Colors.white
                            : Colors.white.withOpacity(0.6),
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
                              child: Image.network(
                                convertGoogleDriveLink(unidad.urlImagen ?? ''),
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
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
                                    'Unidad ${unidad.orden}',
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
                                    unidad.nombre,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Opacity(
                                    opacity: isEnabled ? 1.0 : 0.5,
                                    child: Text(
                                      unidad
                                          .descripcion, // Muestra "Sin descripción" si es nula
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize:
                                            12, // Tamaño más pequeño para que sea sutil
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
                                              Navigator.pushReplacementNamed(
                                                  context, '/Tema');
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

  String convertGoogleDriveLink(String sharedLink) {
    final regex = RegExp(r'd/([a-zA-Z0-9_-]+)/');
    final match = regex.firstMatch(sharedLink);

    if (match != null && match.groupCount > 0) {
      final fileId = match.group(1);
      return 'https://drive.google.com/uc?export=view&id=$fileId';
    }

    throw Exception('Enlace de Google Drive no válido');
  }
}
