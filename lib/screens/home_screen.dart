import 'package:flutter/material.dart';
import 'package:flutter_permisos/controllers/permission_controller.dart';
import 'package:flutter_permisos/theme/app_theme.dart';
import 'package:flutter_permisos/widgets/permission_card.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_permisos/showcases/camera_showcase.dart';
import 'package:flutter_permisos/showcases/location_showcase.dart';
import 'package:flutter_permisos/showcases/audio_showcase.dart';
import 'package:flutter_permisos/showcases/photos_showcase.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final PermissionController _controller = PermissionController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller.checkAllPermissions();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _controller.checkAllPermissions();
    }
  }

  void _navigateToShowcase(String type) {
    if (type == 'Camera') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const CameraShowcase()),
      );
      return;
    }
    if (type == 'Location') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LocationShowcase()),
      );
      return;
    }
    if (type == 'Microphone') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AudioShowcase()),
      );
      return;
    }
    if (type == 'Photos') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const PhotosShowcase(mode: PhotoMode.gallery),
        ),
      );
      return;
    }
    if (type == 'Contacts') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const PhotosShowcase(mode: PhotoMode.contacts),
        ),
      );
      return;
    }

    // TODO: Navigate to other showcases
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Opening $type demo...")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Permission Showcase'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _controller.openSettings,
            tooltip: 'Open App Settings',
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                "System Permissions",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Explore how to request and handle permissions in Flutter with these interactive demos.",
              ),
              const SizedBox(height: 24),

              PermissionCard(
                title: "Camera",
                description:
                    "Required to take photos and video. Shows a live camera preview.",
                icon: FontAwesomeIcons.camera,
                status: _controller.getStatus(Permission.camera),
                onTap: () => _controller.requestPermission(Permission.camera),
                onTest: () => _navigateToShowcase('Camera'),
              ),

              PermissionCard(
                title: "Location",
                description:
                    "Required to display your current coordinates and speed.",
                icon: FontAwesomeIcons.locationDot,
                status: _controller.getStatus(Permission.location),
                onTap: () => _controller.requestPermission(Permission.location),
                onTest: () => _navigateToShowcase('Location'),
              ),

              PermissionCard(
                title: "Microphone",
                description:
                    "Required to record audio and visualize sound waves.",
                icon: FontAwesomeIcons.microphone,
                status: _controller.getStatus(Permission.microphone),
                onTap: () =>
                    _controller.requestPermission(Permission.microphone),
                onTest: () => _navigateToShowcase('Microphone'),
              ),

              PermissionCard(
                title: "Photos / Storage",
                description: "Required to pick images from your gallery.",
                icon: FontAwesomeIcons.image,
                status: _controller.getStatus(Permission.photos),
                onTap: () => _controller.requestPermission(Permission.photos),
                onTest: () => _navigateToShowcase('Photos'),
              ),

              PermissionCard(
                title: "Contacts",
                description:
                    "Required to list your contacts directly in the app.",
                icon: FontAwesomeIcons.addressBook,
                status: _controller.getStatus(Permission.contacts),
                onTap: () => _controller.requestPermission(Permission.contacts),
                onTest: () => _navigateToShowcase('Contacts'),
              ),
            ],
          );
        },
      ),
    );
  }
}
