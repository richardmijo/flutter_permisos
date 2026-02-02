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
    if (type == 'Cámara') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const CameraShowcase()),
      );
      return;
    }
    if (type == 'Ubicación') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LocationShowcase()),
      );
      return;
    }
    if (type == 'Micrófono') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AudioShowcase()),
      );
      return;
    }
    if (type == 'Fotos') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const PhotosShowcase(mode: PhotoMode.gallery),
        ),
      );
      return;
    }
    if (type == 'Contactos') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const PhotosShowcase(mode: PhotoMode.contacts),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Abriendo demo de $type...")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Permisos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _controller.openSettings,
            tooltip: 'Configuración de la App',
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Logo Header
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Image.asset('assets/images/uide_logo.png', height: 80),
                ),
              ),

              Text(
                "Permisos del Sistema",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.uideRed,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                "Demostración interactiva de permisos en Flutter para la UIDE.",
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 24),

              PermissionCard(
                title: "Cámara",
                description:
                    "Requerido para tomar fotos y video. Muestra una vista previa en tiempo real.",
                icon: FontAwesomeIcons.camera,
                status: _controller.getStatus(Permission.camera),
                onTap: () => _controller.requestPermission(Permission.camera),
                onTest: () => _navigateToShowcase('Camera'),
              ),

              PermissionCard(
                title: "Ubicación",
                description:
                    "Requerido para obtener coordenadas GPS y velocidad en tiempo real.",
                icon: FontAwesomeIcons.locationDot,
                status: _controller.getStatus(Permission.location),
                onTap: () => _controller.requestPermission(Permission.location),
                onTest: () => _navigateToShowcase('Location'),
              ),

              PermissionCard(
                title: "Micrófono",
                description:
                    "Requerido para grabar audio y visualizar ondas de sonido.",
                icon: FontAwesomeIcons.microphone,
                status: _controller.getStatus(Permission.microphone),
                onTap: () =>
                    _controller.requestPermission(Permission.microphone),
                onTest: () => _navigateToShowcase('Microphone'),
              ),

              PermissionCard(
                title: "Fotos / Galería",
                description:
                    "Requerido para seleccionar imágenes de la galería.",
                icon: FontAwesomeIcons.image,
                status: _controller.getStatus(Permission.photos),
                onTap: () => _controller.requestPermission(Permission.photos),
                onTest: () => _navigateToShowcase('Photos'),
              ),

              PermissionCard(
                title: "Contactos",
                description:
                    "Requerido para listar los contactos del dispositivo.",
                icon: FontAwesomeIcons.addressBook,
                status: _controller.getStatus(Permission.contacts),
                onTap: () => _controller.requestPermission(Permission.contacts),
                onTest: () => _navigateToShowcase('Contacts'),
              ),

              const SizedBox(height: 20),
              Center(
                child: Text(
                  "Powered by UIDE - ASU",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
