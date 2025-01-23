import 'package:flutter/material.dart';
import 'package:compu_think/core/widgets/custom_bottom_navigation_bar.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class ContentsPage extends StatelessWidget {
  final String unidadTitulo;
  final String subtemaNombre;
  final String pdfUrl;

  const ContentsPage({
    super.key,
    required this.unidadTitulo,
    required this.subtemaNombre,
    required this.pdfUrl,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Número de pestañas
      child: Scaffold(
        appBar: AppBar(
          title: Text(subtemaNombre),
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
                        const SnackBar(content: Text("Reproduciendo video o audio...")),
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

class PDFViewerPage extends StatelessWidget {
  final String pdfUrl;

  const PDFViewerPage({super.key, required this.pdfUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vista de PDF"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Regresar a la pantalla anterior
          },
        ),
      ),
      body: PDFView(
        filePath: pdfUrl,
        enableSwipe: true,
        swipeHorizontal: false,
      ),
    );
  }
}
