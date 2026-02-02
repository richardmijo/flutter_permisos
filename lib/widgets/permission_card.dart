import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_permisos/theme/app_theme.dart';

class PermissionCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final PermissionStatus status;
  final VoidCallback onTap;
  final VoidCallback onTest;

  const PermissionCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.status,
    required this.onTap,
    required this.onTest,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusText;
    IconData statusIcon;

    if (status.isGranted) {
      statusColor = AppTheme.success;
      statusText = "ACTIVO";
      statusIcon = FontAwesomeIcons.circleCheck;
    } else if (status.isPermanentlyDenied) {
      statusColor = AppTheme.error;
      statusText = "DENEGADO (Permanente)";
      statusIcon = FontAwesomeIcons.circleXmark;
    } else {
      statusColor = AppTheme.warning;
      statusText = "REQUERIDO";
      statusIcon = FontAwesomeIcons.circleExclamation;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.uideRed.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: FaIcon(icon, color: AppTheme.uideRed, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(statusIcon, color: statusColor, size: 14),
                            const SizedBox(width: 6),
                            Text(
                              statusText,
                              style: TextStyle(
                                color: statusColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                description,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary),
              ),
              if (status.isGranted) ...[
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: onTest,
                    icon: const Icon(Icons.touch_app),
                    label: const Text("PROBAR FUNCIONALIDAD"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.uideRed,
                      side: const BorderSide(color: AppTheme.uideRed),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
