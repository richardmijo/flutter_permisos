import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_permisos/theme/app_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AudioShowcase extends StatefulWidget {
  const AudioShowcase({super.key});

  @override
  State<AudioShowcase> createState() => _AudioShowcaseState();
}

class _AudioShowcaseState extends State<AudioShowcase> {
  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool _isRecording = false;
  bool _isPlaying = false;
  String? _filePath;

  @override
  void dispose() {
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final directory = await getTemporaryDirectory();
        _filePath = '${directory.path}/temp_audio.m4a';

        // Configurar para grabar
        await _audioRecorder.start(const RecordConfig(), path: _filePath!);

        setState(() => _isRecording = true);
      }
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      setState(() {
        _isRecording = false;
        _filePath = path;
      });
    } catch (e) {
      debugPrint("Stop recording error: $e");
    }
  }

  Future<void> _playRecording() async {
    try {
      if (_filePath != null) {
        Source urlSource = UrlSource(_filePath!);
        await _audioPlayer.play(urlSource);
        setState(() => _isPlaying = true);

        _audioPlayer.onPlayerComplete.listen((event) {
          if (mounted) setState(() => _isPlaying = false);
        });
      }
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error playing: $e")));
    }
  }

  Future<void> _stopPlayback() async {
    await _audioPlayer.stop();
    setState(() => _isPlaying = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Audio Showcase')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Visualizer
            SizedBox(
              height: 150,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(10, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child:
                        AnimatedContainer(
                              duration: Duration(
                                milliseconds: 300 + (index * 50),
                              ),
                              width: 10,
                              height: _isRecording || _isPlaying
                                  ? (index % 2 == 0 ? 100 : 50) + (index * 5.0)
                                  : 10,
                              decoration: BoxDecoration(
                                color: _isRecording
                                    ? AppTheme.error
                                    : AppTheme.primary,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            )
                            .animate(target: _isRecording || _isPlaying ? 1 : 0)
                            .shimmer(duration: 1.seconds),
                  );
                }),
              ),
            ),

            const SizedBox(height: 60),

            // Rec Button
            GestureDetector(
              onTap: _isRecording ? _stopRecording : _startRecording,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isRecording
                      ? AppTheme.error.withOpacity(0.2)
                      : AppTheme.surface,
                  border: Border.all(
                    color: _isRecording ? AppTheme.error : Colors.grey,
                    width: 3,
                  ),
                ),
                child: Center(
                  child: Icon(
                    _isRecording
                        ? FontAwesomeIcons.stop
                        : FontAwesomeIcons.microphone,
                    color: _isRecording ? AppTheme.error : Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(_isRecording ? "RECORDING..." : "TAP TO RECORD"),

            const SizedBox(height: 40),

            if (_filePath != null && !_isRecording)
              ElevatedButton.icon(
                onPressed: _isPlaying ? _stopPlayback : _playRecording,
                icon: Icon(_isPlaying ? Icons.stop : Icons.play_arrow),
                label: Text(_isPlaying ? "STOP PLAYBACK" : "PLAY RECORDING"),
              ),
          ],
        ),
      ),
    );
  }
}
