import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

/// Construye el widget para el contenido de audio con controles de reproducción
Widget buildAudioContent(
  Map<String, dynamic> content, // Datos del audio (título y URL)
  AudioPlayer audioPlayer, // Instancia del reproductor de audio
  String? currentAudio, // URL del audio que se está reproduciendo actualmente
  Function(String?) onAudioStateChange, // Función para cambiar el estado del audio actual
  BuildContext context, // Contexto para mostrar mensajes o manejar errores
) {
  return Padding(
    padding: const EdgeInsets.all(15.0), // Espaciado externo
    child: Container(
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1), // Fondo semitransparente
        borderRadius: BorderRadius.circular(12), // Bordes redondeados
        border: Border.all(color: Colors.blue), // Borde azul
      ),
      padding: const EdgeInsets.all(16.0), // Espaciado interno
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Alineación del texto a la izquierda
        children: [
          // Título del audio
          Text(
            content['title']!, // Muestra el título proporcionado
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12), // Espaciado entre el título y los controles

          // Controles de reproducción
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Espaciado uniforme entre los botones
            children: [
              // Botón de retroceder 10 segundos
              IconButton(
                icon: const Icon(Icons.replay_10, color: Colors.blue),
                onPressed: () async {
                  final currentPosition = audioPlayer.position; // Posición actual
                  final newPosition = currentPosition - const Duration(seconds: 10); // Calcula la nueva posición
                  if (newPosition >= Duration.zero) {
                    await audioPlayer.seek(newPosition); // Retrocede solo si no excede el límite inferior
                  } else {
                    await audioPlayer.seek(Duration.zero); // Ajusta a 0 si el cálculo excede
                  }
                },
              ),
              // Botón de reproducción/pausa
              StreamBuilder<PlayerState>(
                stream: audioPlayer.playerStateStream, // Escucha el estado del reproductor
                builder: (context, snapshot) {
                  final playerState = snapshot.data;
                  final isPlaying = playerState?.playing ?? false; // Verifica si está reproduciendo
                  final isBuffering = playerState?.processingState == ProcessingState.buffering;

                  return IconButton(
                    icon: isBuffering
                        ? const CircularProgressIndicator(strokeWidth: 2.0, color: Colors.blue)
                        : Icon(
                            isPlaying && currentAudio == content['url'] // Verifica el estado y el audio actual
                                ? Icons.pause_circle
                                : Icons.play_circle,
                            color: Colors.blue,
                            size: 32,
                          ),
                    onPressed: () async {
                      if (currentAudio == content['url'] && isPlaying) {
                        // Si ya está reproduciendo este audio, pausa
                        await audioPlayer.pause();
                        onAudioStateChange(null); // Limpia el estado actual
                      } else {
                        // Si es un nuevo audio o estaba pausado
                        try {
                          if (currentAudio != content['url']) {
                            await audioPlayer.setUrl(content['url']!); // Carga la URL del nuevo audio
                          }
                          await audioPlayer.play(); // Reproduce el audio
                          onAudioStateChange(content['url']); // Actualiza el estado con la URL actual
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Error al reproducir el audio'), // Mensaje de error
                              ),
                            );
                          }
                        }
                      }
                    },
                  );
                },
              ),
              // Botón de avanzar 10 segundos
              IconButton(
                icon: const Icon(Icons.forward_10, color: Colors.blue),
                onPressed: () async {
                  final currentPosition = audioPlayer.position; // Posición actual
                  final totalDuration = audioPlayer.duration ?? Duration.zero; // Duración total del audio
                  final newPosition = currentPosition + const Duration(seconds: 10); // Calcula la nueva posición
                  if (newPosition <= totalDuration) {
                    await audioPlayer.seek(newPosition); // Avanza solo si no excede la duración total
                  } else {
                    await audioPlayer.seek(totalDuration); // Ajusta al final si el cálculo excede
                  }
                },
              ),
            ],
          ),

          // Barra de progreso y tiempo del audio
          StreamBuilder<Duration>(
            stream: audioPlayer.positionStream, // Escucha los cambios en la posición del audio
            builder: (context, snapshot) {
              final currentPosition = snapshot.data ?? Duration.zero; // Posición actual
              final totalDuration = audioPlayer.duration ?? Duration.zero; // Duración total
              return Column(
                children: [
                  // Barra deslizante para controlar la posición del audio
                  Slider(
                    value: currentPosition.inSeconds.toDouble(), // Posición actual en segundos
                    max: totalDuration.inSeconds.toDouble(), // Duración máxima en segundos
                    onChanged: (value) async {
                      final newPosition = Duration(seconds: value.toInt()); // Calcula la nueva posición
                      if (newPosition <= totalDuration) {
                        await audioPlayer.seek(newPosition); // Cambia la posición dentro de los límites
                      }
                    },
                  ),
                  // Muestra la posición actual y la duración total
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Alinea los textos a ambos lados
                    children: [
                      Text(_formatDuration(currentPosition)), // Tiempo actual
                      Text(_formatDuration(totalDuration)), // Tiempo total
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    ),
  );
}

/// Formatea la duración para mostrarla en formato mm:ss
String _formatDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0'); // Asegura 2 dígitos
  final minutes = twoDigits(duration.inMinutes.remainder(60)); // Minutos
  final seconds = twoDigits(duration.inSeconds.remainder(60)); // Segundos
  return '$minutes:$seconds'; // Retorna el formato mm:ss
}
