// ignore_for_file: unused_field

import 'package:compu_think/controllers/content_controller.dart';
import 'package:compu_think/models/entities/view_detail_content_entity.dart';
import 'package:compu_think/utils/helper/convert_google_drive_link.dart';
import 'package:compu_think/utils/widgets/audio_viewer_page.dart';
import 'package:compu_think/utils/widgets/custom_bottom_navigation_bar.dart';
import 'package:compu_think/utils/widgets/media_item.dart';
import 'package:compu_think/utils/widgets/pdf_viewer_page.dart';
import 'package:compu_think/utils/widgets/video_viewer_page.dart';
import 'package:flutter/material.dart';

class ContentsPage extends StatefulWidget {
  const ContentsPage({super.key});

  @override
  State<ContentsPage> createState() => _ContentsPageState();
}

class _ContentsPageState extends State<ContentsPage> {
  final String subtemaNombre = 'Titulo Subtema';
  final ContentController _contentController = ContentController();
  List<ViewDetailContentEntity> _contenidos = [];
  bool _isLoading = true;
  String? _errorMessage;

  late int idTema;
  late int idUnidad;
  late String titulo;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadArguments();
    _fetchContents();
  }

  // Cargar los argumentos de la navegación
  void _loadArguments() {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      idUnidad = args['idUnidad'] as int;
      idTema = args['idTema'] as int;
      titulo = args['titulo'] as String;
    } else {
      idUnidad = 0;
      idTema = 0;
      titulo = 'Título no disponible';
    }
  }

  // Cargar los subtemas desde el controlador
  Future<void> _fetchContents() async {
    try {
      final contenidos =
          await _contentController.getViewContenidoDetalleByTemaId(idTema);
      if (mounted) {
        setState(() {
          _contenidos = contenidos;
          _isLoading = false;
          _errorMessage = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error al cargar los subtemas: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Número de pestañas
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Text(titulo),
            ],
          ),
          backgroundColor: Colors.blue,
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.play_circle), text: "Multimedia"),
              Tab(icon: Icon(Icons.picture_as_pdf), text: "PDF"),
            ],
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // Regresar a la pantalla anterior
            },
          ),
        ),
        body: TabBarView(
          children: [
            // Pestaña de multimedia
            ListView.builder(
              itemCount: _contenidos.length,
              itemBuilder: (context, index) {
                final content = _contenidos[index];

                String url = content.contenidoUrl;
                String nombre = content.contenidoNombre;
                String tipoContenido = content.tipoContenidoNombre;

                // Validar si 'url' es null o vacío
                if (url.isEmpty) {
                  return const SizedBox.shrink();
                }
                if (tipoContenido == 'video' || tipoContenido == 'audio') {
                  return MediaItem(
                    name: nombre,
                    type: tipoContenido,
                    pageRoute: (context) {
                      if (tipoContenido == 'video') {
                        // Si es video, devuelve la ruta para el reproductor de video
                        return VideoViewerPage(
                          videoUrl: url,
                          nombre: nombre,
                        );
                      } else if (tipoContenido == 'audio') {
                        // Si es audio, devuelve la ruta para el reproductor de audio
                        // Validar si la URL es válida usando convertGoogleDriveLink
                        try {
                          url = convertGoogleDriveLink(
                              url); // Intenta convertir la URL
                        } catch (e) {
                          return const Text(
                            'URL no válida',
                            style: TextStyle(color: Colors.red),
                          );
                        }
                        return AudioViewerPage(
                          audioUrl: url,
                          nombre: nombre,
                        );
                      }
                      return Container(); // No debería llegar aquí si se valida correctamente el tipo
                    },
                  );
                }
                return Container(); // Si no es video ni audio, no retorna nada
              },
            ),
            // Pestaña de PDF
            ListView.builder(
              itemCount: _contenidos.length,
              itemBuilder: (context, index) {
                final content = _contenidos[index];
                String tipoContenido = content.tipoContenidoNombre;
                String url = content.contenidoUrl;
                String nombre = content.contenidoNombre;
                // Asegúrate de validar que el contenido tenga el nombre y la URL
                if (url.isEmpty) {
                  return const SizedBox.shrink();
                }
                if (tipoContenido == 'pdf') {
                  // Validar si la URL es válida usando convertGoogleDriveLink
                try {
                  url = convertGoogleDriveLink(url); // Intenta convertir la URL
                } catch (e) {
                  return const Text(
                    'URL no válida',
                    style: TextStyle(color: Colors.red),
                  );
                }
                  return MediaItem(
                    name: nombre,
                    type: tipoContenido,
                    pageRoute: (context) =>
                        PdfViewerPage(pdfUrl: url, nombre: nombre, tema:content.temaTitulo),
                  );
                }
                return Container();
              },
            )
          ],
        ),
        bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 0),
      ),
    );
  }
}
