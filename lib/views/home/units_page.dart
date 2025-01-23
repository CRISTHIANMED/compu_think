import 'package:compu_think/core/widgets/custom_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

class UnitsPage extends StatefulWidget {
  const UnitsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UnitsPageState createState() => _UnitsPageState();
}

class _UnitsPageState extends State<UnitsPage> {
  final List<Map<String, dynamic>> unidades = [
    {
      'imageUrl':
          'https://drive.google.com/file/d/1_1-eiXG7K_tE9m7wJuIzCdhyC3DXibTc/view?usp=sharing',
      'title': 'Unidad 1',
      'description': 'Descripción de la Unidad 1',
      'isEnabled': true,
    },
    {
      'imageUrl':
          'https://drive.google.com/file/d/1BbIS7gri7H7Q68EAJbFNRxSnhO9Jbwi5/view?usp=sharing',
      'title': 'Unidad 2',
      'description': 'Descripción de la Unidad 2',
      'isEnabled': true,
    },
    {
      'imageUrl':
          'https://drive.google.com/file/d/1BbIS7gri7H7Q68EAJbFNRxSnhO9Jbwi5/view?usp=sharing',
      'title': 'Unidad 3',
      'description': 'Descripción de la Unidad 3',
      'isEnabled': false,
    },
  ];

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
            Expanded(
              child: ListView.builder(
                itemCount: unidades.length,
                itemBuilder: (ctx, index) {
                  final unidad = unidades[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: unidad['isEnabled']
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
                          opacity: unidad['isEnabled'] ? 1.0 : 0.5,
                          child: ClipOval(
                            child: Image.network(
                              convertGoogleDriveLink(unidad['imageUrl']),
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
                                opacity: unidad['isEnabled'] ? 1.0 : 0.5,
                                child: Text(
                                  unidad['title'],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Opacity(
                                opacity: unidad['isEnabled'] ? 1.0 : 0.5,
                                child: Text(
                                  unidad['description'],
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Center(
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50),
                                  child: ElevatedButton(
                                    onPressed: unidad['isEnabled'] ? () {Navigator.pushReplacementNamed(context, '/Tema');} : null,
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
      )
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
