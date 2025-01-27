import 'dart:io';

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

  // Lista de contenidos multimedia
  final List<Map<String, dynamic>> multimediaContent = [
    {
      'type': 'video',
      'url': 'https://www.youtube.com/watch?v=dQw4w9WgXcQl',
      'name': 'Video de Ejemplo 1'
    },
    {
      'type': 'audio',
      'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
      'name': 'Audio de Ejemplo 1'
    },
    {
      'type': 'audio',
      'url':
          'https://drive.google.com/uc?export=view&id=1Q6ZYn6Nj5XF-GsRs_X81w3rzPiu-GjZv',
      'name': 'Audio de Ejemplo 15'
    },
    {
      'type': 'video',
      'url': 'https://www.youtube.com/watch?v=kZfuJvkdcHU&t=10s',
      'name': 'Video de Ejemplo 2'
    },
    {
      'type': 'pdf',
      'name': 'Tema 1',
      'url':
          'https://departamento.us.es/edan/php/asig/LICFIS/LFIPC/Tema2FISPC0809.pdf'
    },
    {
      'type': 'pdf',
      'name': 'Tema 2',
      'url':
          'https://departamento.us.es/edan/php/asig/LICFIS/LFIPC/Tema2FISPC0809.pdf'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Número de pestañas
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Text(subtemaNombre),
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
              itemCount: multimediaContent.length,
              itemBuilder: (context, index) {
                final content = multimediaContent[index];
                // Validar si 'url' es null o vacío
                if (content['url'] == null || content['url']!.isEmpty) {
                  return const SizedBox.shrink();
                }
                if (content['type'] == 'video' || content['type'] == 'audio') {
                  return MediaItem(
                    name: content['name'] ?? '',
                    type: content['type'],
                    pageRoute: (context) {
                      if (content['type'] == 'video') {
                        // Si es video, devuelve la ruta para el reproductor de video
                        return VideoViewerPage(
                          videoUrl: content['url'],
                          nombre: content['name'] ?? '',
                        );
                      } else if (content['type'] == 'audio') {
                        // Si es audio, devuelve la ruta para el reproductor de audio
                        return AudioViewerPage(
                          audioUrl: content['url'],
                          nombre: content['name'] ?? '',
                        );
                      }
                      return Container(); // No debería llegar aquí si se valida correctamente el tipo
                    },
                  );
                }
                return null; // Si no es video ni audio, no retorna nada
              },
            ),
            // Pestaña de PDF
            ListView.builder(
              itemCount: multimediaContent.length,
              itemBuilder: (context, index) {
                final content = multimediaContent[index];
                // Asegúrate de validar que el contenido tenga el nombre y la URL
                if (content['url'] == null || content['url']!.isEmpty) {
                  return const SizedBox.shrink();
                }
                return MediaItem(
                  name: content['name'] ?? '',
                  type: content['type'],
                  pageRoute: (context) => PdfViewerPage(pdfUrl: content['url']),
                );
              },
            )
          ],
        ),
        bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 0),
      ),
    );
  }
}
