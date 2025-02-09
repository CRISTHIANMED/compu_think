import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final LatLng _currentLocation = const LatLng(1.214356, -77.278370); // Bogotá por defecto
  final List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    _determinePosition();
    _markers.addAll([
      _createMarker(const LatLng(1.213339, -77.282552), 'Pregunta 1', '¿Cuál es la capital de Colombia?'),
      _createMarker(const LatLng(1.214990, -77.276283), 'Pregunta 2', '¿Cuál es la moneda oficial de Colombia?'),
    ]);
  }

  Future<void> _determinePosition() async {
    // Aquí podrías obtener la ubicación actual con `geolocator`
  }

  Marker _createMarker(LatLng position, String title, String question) {
    return Marker(
      point: position,
      width: 50.0,
      height: 50.0,
      child: GestureDetector(
        onTap: () => _showQuestionDialog(question),
        child: const Icon(Icons.location_pin, color: Colors.red, size: 40),
      ),
    );
  }

  void _showQuestionDialog(String question) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pregunta'),
        content: Text(question),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mapa con Preguntas')),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: _currentLocation,
          initialZoom: 12.0,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            userAgentPackageName: 'com.example.app', // Asegura que este parámetro esté presente
          ),
          MarkerLayer(
            markers: _markers, // Aquí agregamos los marcadores
          ),
        ],
      ),
    );
  }
}
