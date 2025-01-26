// ignore_for_file: library_private_types_in_public_api

import 'package:compu_think/utils/widgets/custom_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class ContentsPage extends StatefulWidget {

  const ContentsPage({super.key});

  @override
  State<ContentsPage> createState() => _ContentsPageState();
}

class _ContentsPageState extends State<ContentsPage> {
  final String unidadTitulo = 'unidad';

  final String subtemaNombre = 'subtema';

  final String pdfUrl =
      'https://departamento.us.es/edan/php/asig/LICFIS/LFIPC/Tema2FISPC0809.pdf';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Número de pestañas
      child: Scaffold(
        appBar: AppBar(
          title: Text(subtemaNombre),
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
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Contenido Multimedia",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Acción para reproducir un video o audio
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Reproduciendo video o audio...")),
                      );
                    },
                    child: const Text("Reproducir Video/Audio"),
                  ),
                ],
              ),
            ),

            // Pestaña de PDF
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PDFViewerPage(pdfUrl: pdfUrl),
                    ),
                  );
                },
                child: const Text("Abrir PDF"),
              ),
            ),
          ],
        ),
        bottomNavigationBar: const CustomBottomNavigationBar(
          currentIndex: 0,
        ),
      ),
    );
  }
}

class PDFViewerPage extends StatefulWidget {
  final String pdfUrl;

  const PDFViewerPage({super.key, required this.pdfUrl});

  @override
  PDFViewerPageState createState() => PDFViewerPageState();
}

class PDFViewerPageState extends State<PDFViewerPage> {
  String? localPath;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _downloadAndSavePdf();
  }

  Future<void> _downloadAndSavePdf() async {
    try {
      final response = await http.get(Uri.parse(widget.pdfUrl));
      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/temp.pdf');
        await file.writeAsBytes(response.bodyBytes);
        setState(() {
          localPath = file.path;
          isLoading = false;
        });
      } else {
        throw Exception("Error al descargar el PDF");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showErrorDialog(e.toString());
    }
  }

  Future<void> _savePdfToDownloads() async {
    try {
      if (localPath != null) {
        final directory = await getExternalStorageDirectory();
        final downloadsDir = Directory('${directory?.path}/Descargas');
        if (!await downloadsDir.exists()) {
          await downloadsDir.create(recursive: true);
        }
        const fileName = 'documento_descargado.pdf';
        final newFile = File('${downloadsDir.path}/$fileName');
        await File(localPath!).copy(newFile.path);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Archivo guardado en ${newFile.path}')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar el archivo: $e')),
        );
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vista de PDF"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _savePdfToDownloads,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : localPath != null
              ? PDFView(
                  filePath: localPath,
                  enableSwipe: true,
                  swipeHorizontal: true,
                  autoSpacing: true,
                  pageSnap: true,
                  fitPolicy: FitPolicy.BOTH,
                )
              : const Center(
                  child: Text("No se pudo cargar el PDF"),
                ),
    );
  }
}