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
  List<CameraDescription> _cameras = [];
  bool _isInitialized = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        setState(() => _error = "No cameras found");
        return;
      }

      _controller = CameraController(
        _cameras.first,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _controller!.initialize();
      if (mounted) {
        setState(() => _isInitialized = true);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _error = "Error initializing camera: $e");
      }
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
      appBar: AppBar(title: const Text('Camera Showcase')),
      body: _buildBody(),
      floatingActionButton: _isInitialized
          ? FloatingActionButton(
              onPressed: () async {
                try {
                  final image = await _controller!.takePicture();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Picture taken: ${image.path}')),
                    );
                  }
                } catch (e) {
                  debugPrint('Error taking picture: $e');
                }
              },
              backgroundColor: AppTheme.primary,
              child: const Icon(Icons.camera_alt),
            ).animate().scale(delay: 500.ms)
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildBody() {
    if (_error != null) {
      return Center(
        child: Text(
          _error!,
          style: TextStyle(color: AppTheme.error),
          textAlign: TextAlign.center,
        ),
      );
    }

    if (!_isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        // Camera Preview
        SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: CameraPreview(_controller!),
        ),

        // Overlay UI
        Positioned(
          top: 20,
          left: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(Icons.circle, color: Colors.red, size: 12),
                SizedBox(width: 8),
                Text(
                  "LIVE FEED",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn().slideX(),
        ),

        // Corner brackets for "Tech" look
        ..._buildCorners(),
      ],
    );
  }

  List<Widget> _buildCorners() {
    double length = 40;
    double thickness = 3;
    Color color = AppTheme.primary.withOpacity(0.7);

    return [
      // Top Left
      Positioned(
        top: 40,
        left: 20,
        child: Container(width: length, height: thickness, color: color),
      ),
      Positioned(
        top: 40,
        left: 20,
        child: Container(width: thickness, height: length, color: color),
      ),

      // Top Right
      Positioned(
        top: 40,
        right: 20,
        child: Container(width: length, height: thickness, color: color),
      ),
      Positioned(
        top: 40,
        right: 20,
        child: Container(width: thickness, height: length, color: color),
      ),

      // Bottom Left
      Positioned(
        bottom: 100,
        left: 20,
        child: Container(width: length, height: thickness, color: color),
      ),
      Positioned(
        bottom: 100 - length + 3,
        left: 20,
        child: Container(width: thickness, height: length, color: color),
      ),

      // Bottom Right
      Positioned(
        bottom: 100,
        right: 20,
        child: Container(width: length, height: thickness, color: color),
      ),
      Positioned(
        bottom: 100 - length + 3,
        right: 20,
        child: Container(width: thickness, height: length, color: color),
      ),
    ];
  }
}
