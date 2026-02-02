import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_permisos/theme/app_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CameraShowcase extends StatefulWidget {
  const CameraShowcase({super.key});

  @override
  State<CameraShowcase> createState() => _CameraShowcaseState();
}

class _CameraShowcaseState extends State<CameraShowcase> {
  CameraController? _controller;
  bool _isInitialized = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() => _errorMessage = "No se encontraron cámaras");
        return;
      }

      _controller = CameraController(
        cameras[0],
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _controller!.initialize();
      if (mounted) setState(() => _isInitialized = true);
    } catch (e) {
      if (mounted) setState(() => _errorMessage = "Error iniciando cámara: $e");
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Camera preview looks best on black
      appBar: AppBar(
        title: const Text('Cámara'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      extendBodyBehindAppBar: true,
      body: _buildBody(),
      floatingActionButton: _isInitialized
          ? FloatingActionButton(
              onPressed: () async {
                try {
                  final image = await _controller!.takePicture();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Foto guardada en: ${image.path}'),
                        backgroundColor: AppTheme.success,
                      ),
                    );
                  }
                } catch (e) {
                  debugPrint('Error tomando foto: $e');
                }
              },
              backgroundColor: Colors.white,
              foregroundColor: AppTheme.uideRed,
              child: const Icon(Icons.camera_alt),
            ).animate().scale(delay: 500.ms)
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildBody() {
    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error, color: AppTheme.error, size: 48),
            const SizedBox(height: 16),
            Text(_errorMessage!, style: const TextStyle(color: Colors.white)),
          ],
        ),
      );
    }

    if (!_isInitialized) {
      return const Center(
        child: CircularProgressIndicator(color: AppTheme.uideGold),
      );
    }

    return Stack(
      children: [
        // Camera Preview
        SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: CameraPreview(_controller!),
        ),

        // Institutional/Tech Overlay
        IgnorePointer(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: AppTheme.uideGold.withOpacity(0.3),
                width: 2,
              ),
            ),
            margin: const EdgeInsets.all(20),
          ),
        ),

        // Corners
        ..._buildCorners(),

        // Labels
        Positioned(
          top: 100,
          right: 30,
          child:
              Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.uideRed,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      "EN VIVO",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  )
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .fade(duration: 800.ms),
        ),
      ],
    );
  }

  List<Widget> _buildCorners() {
    const double size = 40;
    const double thickness = 4;
    const Color color = AppTheme.uideGold;

    return [
      // Top Left
      Positioned(
        top: 20,
        left: 20,
        child: Container(width: size, height: thickness, color: color),
      ),
      Positioned(
        top: 20,
        left: 20,
        child: Container(width: thickness, height: size, color: color),
      ),
      // Top Right
      Positioned(
        top: 20,
        right: 20,
        child: Container(width: size, height: thickness, color: color),
      ),
      Positioned(
        top: 20,
        right: 20,
        child: Container(width: thickness, height: size, color: color),
      ),
      // Bottom Left
      Positioned(
        bottom: 20,
        left: 20,
        child: Container(width: size, height: thickness, color: color),
      ),
      Positioned(
        bottom: 20,
        left: 20,
        child: Container(width: thickness, height: size, color: color),
      ),
      // Bottom Right
      Positioned(
        bottom: 20,
        right: 20,
        child: Container(width: size, height: thickness, color: color),
      ),
      Positioned(
        bottom: 20,
        right: 20,
        child: Container(width: thickness, height: size, color: color),
      ),
    ];
  }
}
