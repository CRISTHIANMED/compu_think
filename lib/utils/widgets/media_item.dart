import 'package:flutter/material.dart';

class MediaItem extends StatelessWidget {
  final String name; // Nombre del archivo o título
  final String type; // Tipo de archivo (pdf, video, audio)
  final Widget Function(BuildContext) pageRoute; // Ruta de la página a navegar

  const MediaItem({
    super.key,
    required this.name,
    required this.type,
    required this.pageRoute,
  });

  @override
  Widget build(BuildContext context) {
    // Determina el ícono según el tipo de archivo
    IconData getIconByType(String type) {
      switch (type) {
        case 'pdf':
          return Icons.picture_as_pdf;
        case 'video':
          return Icons.videocam;
        case 'audio':
          return Icons.audiotrack;
        default:
          return Icons.insert_drive_file;
      }
    }

    // Determina el color del ícono según el tipo de archivo
    Color getColorByType(String type) {
      switch (type) {
        case 'pdf':
          return Colors.red;
        case 'video':
          return Colors.blue;
        case 'audio':
          return Colors.green;
        default:
          return Colors.grey;
      }
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: ListTile(
        leading: Icon(
          getIconByType(type),
          color: getColorByType(type),
          size: 36,
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: pageRoute),
          );
        },
      ),
    );
  }
}
