import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_permisos/theme/app_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LocationShowcase extends StatefulWidget {
  const LocationShowcase({super.key});

  @override
  State<LocationShowcase> createState() => _LocationShowcaseState();
}

class _LocationShowcaseState extends State<LocationShowcase> {
  StreamSubscription<Position>? _positionStream;
  Position? _currentPosition;
  bool _isTracking = false;

  void _toggleTracking() async {
    if (_isTracking) {
      _positionStream?.cancel();
      setState(() => _isTracking = false);
    } else {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted)
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location services are disabled.')),
          );
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted)
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Location permission denied.')),
            );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted)
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Location permission denied forever.'),
            ),
          );
        return;
      }

      const LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 0,
      );

      _positionStream =
          Geolocator.getPositionStream(
            locationSettings: locationSettings,
          ).listen((Position? position) {
            setState(() {
              _currentPosition = position;
            });
          });

      setState(() => _isTracking = true);
    }
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Location Showcase')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Radar Animation
            Stack(
              alignment: Alignment.center,
              children: [
                if (_isTracking) ...[
                  Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppTheme.primary.withOpacity(0.3),
                            width: 2,
                          ),
                          shape: BoxShape.circle,
                        ),
                      )
                      .animate(onPlay: (c) => c.repeat())
                      .scale(
                        duration: 2.seconds,
                        begin: const Offset(0.5, 0.5),
                        end: const Offset(1.5, 1.5),
                      )
                      .fadeOut(duration: 2.seconds),

                  Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppTheme.primary.withOpacity(0.5),
                            width: 2,
                          ),
                          shape: BoxShape.circle,
                        ),
                      )
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .scale(
                        duration: 1.5.seconds,
                        begin: const Offset(0.9, 0.9),
                      ),
                ],

                Icon(
                      FontAwesomeIcons.locationArrow,
                      size: 50,
                      color: _isTracking ? AppTheme.secondary : Colors.grey,
                    )
                    .animate(target: _isTracking ? 1 : 0)
                    .shimmer(duration: 1.seconds),
              ],
            ),

            const SizedBox(height: 40),

            // Data Display
            if (_currentPosition != null) ...[
              _buildDataCard(
                "LATITUDE",
                _currentPosition!.latitude.toStringAsFixed(6),
              ),
              const SizedBox(height: 10),
              _buildDataCard(
                "LONGITUDE",
                _currentPosition!.longitude.toStringAsFixed(6),
              ),
              const SizedBox(height: 10),
              _buildDataCard(
                "SPEED",
                "${_currentPosition!.speed.toStringAsFixed(2)} m/s",
              ),
            ] else if (_isTracking)
              const Text(
                "Waiting for GPS signal...",
                style: TextStyle(color: Colors.grey),
              )
            else
              const Text(
                "Tracking currently inactive",
                style: TextStyle(color: Colors.grey),
              ),

            const SizedBox(height: 40),

            ElevatedButton.icon(
              onPressed: _toggleTracking,
              icon: Icon(_isTracking ? Icons.stop : Icons.play_arrow),
              label: Text(_isTracking ? "STOP TRACKING" : "START TRACKING"),
              style: _isTracking
                  ? ElevatedButton.styleFrom(backgroundColor: AppTheme.error)
                  : ElevatedButton.styleFrom(backgroundColor: AppTheme.primary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataCard(String label, String value) {
    return Container(
      width: 300,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              letterSpacing: 1.5,
              fontSize: 12,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.5);
  }
}
