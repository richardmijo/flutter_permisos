import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_permisos/theme/app_theme.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LocationShowcase extends StatefulWidget {
  const LocationShowcase({super.key});

  @override
  State<LocationShowcase> createState() => _LocationShowcaseState();
}

class _LocationShowcaseState extends State<LocationShowcase> {
  Position? _currentPosition;
  bool _isTracking = false;
  StreamSubscription<Position>? _positionStream;

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }

  void _toggleTracking() async {
    if (_isTracking) {
      _positionStream?.cancel();
      setState(() => _isTracking = false);
      return;
    }

    final status = await Permission.location.status;
    if (!status.isGranted) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Permiso de ubicación requerido")),
        );
      return;
    }

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Servicios de ubicación desactivados")),
        );
      return;
    }

    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 0,
    );

    _positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
          (Position? position) {
            setState(() {
              _currentPosition = position;
            });
          },
          onError: (e) {
            debugPrint("Error: $e");
          },
        );

    setState(() => _isTracking = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ubicación en Tiempo Real')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Radar Animation
            Stack(
              alignment: Alignment.center,
              children: [
                _buildRipple(150, delay: 0),
                _buildRipple(250, delay: 1000),
                _buildRipple(350, delay: 2000),

                Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppTheme.uideRed,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.uideRed.withOpacity(0.5),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: const Icon(
                        FontAwesomeIcons.locationArrow,
                        color: Colors.white,
                        size: 30,
                      ),
                    )
                    .animate(target: _isTracking ? 1 : 0)
                    .shimmer(duration: 1.seconds),
              ],
            ),

            const SizedBox(height: 60),

            _buildDataCard(
              "Latitud",
              _currentPosition?.latitude.toStringAsFixed(6) ?? "---",
              Icons.explore,
            ),
            const SizedBox(height: 12),
            _buildDataCard(
              "Longitud",
              _currentPosition?.longitude.toStringAsFixed(6) ?? "---",
              Icons.explore,
            ),
            const SizedBox(height: 12),
            _buildDataCard(
              "Velocidad",
              "${_currentPosition?.speed.toStringAsFixed(1) ?? "0.0"} m/s",
              Icons.speed,
            ),

            const SizedBox(height: 40),

            ElevatedButton.icon(
              onPressed: _toggleTracking,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isTracking
                    ? AppTheme.uideRed
                    : AppTheme.uideGold,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              icon: Icon(_isTracking ? Icons.stop : Icons.play_arrow),
              label: Text(_isTracking ? "DETENER RASTREO" : "INICIAR RASTREO"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRipple(double size, {required int delay}) {
    if (!_isTracking) return const SizedBox.shrink();

    return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppTheme.uideRed.withOpacity(0.3),
              width: 2,
            ),
          ),
        )
        .animate(onPlay: (c) => c.repeat())
        .scale(
          begin: const Offset(0.5, 0.5),
          end: const Offset(1, 1),
          duration: 3.seconds,
          delay: Duration(milliseconds: delay),
        )
        .fadeOut(
          duration: 3.seconds,
          delay: Duration(milliseconds: delay),
        );
  }

  Widget _buildDataCard(String label, String value, IconData icon) {
    return Container(
      width: 250,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppTheme.textSecondary),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Courier New', // Monospace for numbers
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
