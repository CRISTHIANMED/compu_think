// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class AudioViewerPage extends StatefulWidget {
  final String audioUrl;
  final String nombre;

  const AudioViewerPage({super.key, required this.audioUrl, required this.nombre});

  @override
  State<AudioViewerPage> createState() => _AudioViewerPageState();
}

class _AudioViewerPageState extends State<AudioViewerPage> {
  late AudioPlayer _audioPlayer;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    _audioPlayer.setUrl(widget.audioUrl).then((_) {
      setState(() {
        isLoading = false;
      });
    }).catchError((error) {
      // Manejo de errores de carga
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading audio: $error')),
      );
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Stream<Duration?> get _durationStream => _audioPlayer.durationStream;

  Stream<Duration> get _positionStream => _audioPlayer.positionStream;

  Stream<double> get _volumeStream => _audioPlayer.volumeStream;

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration?, Duration, double, PositionData>(
        _durationStream,
        _positionStream,
        _audioPlayer.volumeStream,
        (duration, position, volume) => PositionData(
          duration: duration ?? Duration.zero,
          position: position,
          volume: volume,
        ),
      );

  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nombre),
        backgroundColor: Colors.blue.shade700,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Indicador de carga
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StreamBuilder<PositionData>(
                    stream: _positionDataStream,
                    builder: (context, snapshot) {
                      final positionData = snapshot.data;
                      final duration = positionData?.duration ?? Duration.zero;
                      final position = positionData?.position ?? Duration.zero;

                      return Column(
                        children: [
                          Slider(
                            value: (duration.inSeconds > 0)
                                ? position.inSeconds
                                    .toDouble()
                                    .clamp(0.0, duration.inSeconds.toDouble())
                                : 0.0,
                            max: (duration.inSeconds > 0)
                                ? duration.inSeconds.toDouble()
                                : 1.0, // Evitar max = 0
                            onChanged: (value) {
                              if (duration.inSeconds > 0) {
                                _audioPlayer.seek(Duration(seconds: value.toInt()));
                              }
                            },
                            activeColor: Colors.blue.shade600,
                            inactiveColor: Colors.blue.shade100,
                          ),
                          Text(
                            '${_formatDuration(position)} / ${_formatDuration(duration)}',
                            style: const TextStyle(fontSize: 16, color: Colors.blue),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          final newPosition =
                              _audioPlayer.position - const Duration(seconds: 10);
                          _audioPlayer.seek(newPosition < Duration.zero
                              ? Duration.zero
                              : newPosition);
                        },
                        icon: Icon(Icons.replay_10,
                            color: Colors.blue.shade700, size: 32),
                      ),
                      IconButton(
                        onPressed: () {
                          if (isPlaying) {
                            _audioPlayer.pause();
                          } else {
                            _audioPlayer.play();
                          }
                          setState(() {
                            isPlaying = !isPlaying;
                          });
                        },
                        icon: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.blue.shade700,
                          size: 40,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          final newPosition =
                              _audioPlayer.position + const Duration(seconds: 10);
                          final duration = _audioPlayer.duration ?? Duration.zero;
                          _audioPlayer
                              .seek(newPosition > duration ? duration : newPosition);
                        },
                        icon: Icon(Icons.forward_10,
                            color: Colors.blue.shade700, size: 32),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  StreamBuilder<double>(
                    stream: _volumeStream,
                    builder: (context, snapshot) {
                      final volume = snapshot.data ?? 1.0;
                      return Column(
                        children: [
                          const Text('Volume',
                              style: TextStyle(fontSize: 16, color: Colors.blue)),
                          Slider(
                            value: volume,
                            onChanged: (value) {
                              _audioPlayer.setVolume(value);
                            },
                            activeColor: Colors.blue.shade600,
                            inactiveColor: Colors.blue.shade100,
                            min: 0.0,
                            max: 1.0,
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

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}

class PositionData {
  final Duration duration;
  final Duration position;
  final double volume;

  PositionData(
      {required this.duration, required this.position, required this.volume});
}
