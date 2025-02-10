// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MapPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  LatLng currentLocation = const LatLng(1.2136, -77.2811);
  late final MapController _mapController;
  int mapMode = 1; // 1: gps_fixed, 3: gps_not_fixed

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return;
    }
  }

  void _toggleGpsMode() async {
    if (mapMode == 1) {
      setState(() {
        mapMode = 3; // Permite mover manualmente
      });
    } else {
      _setMode1();
    }
  }

  void _setMode1() async {
    Position position = await Geolocator.getCurrentPosition();
    LatLng newLocation = LatLng(position.latitude, position.longitude);
    setState(() {
      mapMode = 1;
    });
    _mapController.rotate(0);
    _mapController.move(newLocation, 18.0);
  }

  Stream<LocationMarkerPosition?> _positionStream() {
    return Geolocator.getPositionStream().map((Position position) {
      return LocationMarkerPosition(
        latitude: position.latitude,
        longitude: position.longitude,
        accuracy: position.accuracy,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mapa de Preguntas"),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: const LatLng(1.2136, -77.2811),
              initialZoom: 18.0,
              onPositionChanged: (position, hasGesture) {
                if (hasGesture) {
                  setState(() {
                    mapMode =
                        3; // Activa modo manual cuando el usuario mueve el mapa
                  });
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              ),
              CurrentLocationLayer(
                positionStream: _positionStream(),
                alignPositionOnUpdate:
                    mapMode == 1 ? AlignOnUpdate.always : AlignOnUpdate.never,
                alignDirectionOnUpdate:
                    AlignOnUpdate.never, // No forzar alineación de dirección
                style: const LocationMarkerStyle(
                  marker: DefaultLocationMarker(color: Colors.blue),
                  showAccuracyCircle: true,
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleGpsMode,
        child: Icon(
          mapMode == 1 ? Icons.gps_fixed : Icons.gps_not_fixed,
        ),
      ),
    );
  }
}
