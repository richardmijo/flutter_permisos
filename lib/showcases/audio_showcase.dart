import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_permisos/theme/app_theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AudioShowcase extends StatefulWidget {
  const AudioShowcase({super.key});

  @override
  State<AudioShowcase> createState() => _AudioShowcaseState();
}

class _AudioShowcaseState extends State<AudioShowcase> {
  late final AudioRecorder _audioRecorder;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isRecording = false;
  bool _isPlaying = false;
  String? _audioPath;

  @override
  void initState() {
    super.initState();
    _audioRecorder = AudioRecorder();
    _audioPlayer.onPlayerComplete.listen((event) {
      if (mounted) setState(() => _isPlaying = false);
    });
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _toggleRecording() async {
    try {
      if (_isRecording) {
        final path = await _audioRecorder.stop();
        setState(() {
          _isRecording = false;
          _audioPath = path;
        });
      } else {
        if (await Permission.microphone.request().isGranted) {
          final tempDir = await getTemporaryDirectory();
          final path = '${tempDir.path}/audio_test.m4a';

          if (await _audioRecorder.hasPermission()) {
            await _audioRecorder.start(const RecordConfig(), path: path);
            setState(() {
              _isRecording = true;
              _audioPath = null;
            });
          }
        }
      }
    } catch (e) {
      debugPrint("Error grabadora: $e");
    }
  }

  Future<void> _playRecording() async {
    try {
      if (_isPlaying) {
        await _audioPlayer.stop();
        setState(() => _isPlaying = false);
      } else {
        if (_audioPath != null) {
          await _audioPlayer.play(DeviceFileSource(_audioPath!));
          setState(() => _isPlaying = true);
        }
      }
    } catch (e) {
      debugPrint("Error reproductor: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Grabadora de Voz')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Visualizer Area
            Container(
              height: 200,
              width: double.infinity,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(10, (index) {
                  return AnimatedContainer(
                        duration: Duration(milliseconds: 100 + (index * 50)),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 15,
                        height: _isRecording || _isPlaying
                            ? (30 + (index % 5) * 20 + (index % 3) * 10)
                                  .toDouble()
                            : 10,
                        decoration: BoxDecoration(
                          color: _isRecording
                              ? AppTheme.uideRed
                              : AppTheme.textSecondary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      )
                      .animate(
                        target: _isRecording || _isPlaying ? 1 : 0,
                        onPlay: (c) => c.repeat(reverse: true),
                      )
                      .scaleY(begin: 0.5, end: 1.5, duration: 600.ms);
                }),
              ),
            ),

            const SizedBox(height: 20),
            Text(
              _isRecording
                  ? "Grabando..."
                  : (_audioPath != null
                        ? "Audio listo"
                        : "Presiona el micro para grabar"),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),

            const SizedBox(height: 60),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Record Button
                GestureDetector(
                  onTap: _toggleRecording,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: _isRecording ? AppTheme.uideRed : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppTheme.uideRed, width: 2),
                      boxShadow: [
                        if (_isRecording)
                          BoxShadow(
                            color: AppTheme.uideRed.withOpacity(0.4),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                      ],
                    ),
                    child: Icon(
                      _isRecording
                          ? FontAwesomeIcons.stop
                          : FontAwesomeIcons.microphone,
                      color: _isRecording ? Colors.white : AppTheme.uideRed,
                      size: 32,
                    ),
                  ),
                ),

                if (_audioPath != null && !_isRecording) ...[
                  const SizedBox(width: 40),
                  // Play Button
                  GestureDetector(
                    onTap: _playRecording,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppTheme.uideGold,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.uideGold.withOpacity(0.4),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        _isPlaying
                            ? FontAwesomeIcons.pause
                            : FontAwesomeIcons.play,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ).animate().scale(duration: 300.ms),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
