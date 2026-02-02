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
      statusText = "GRANTED";
      statusIcon = FontAwesomeIcons.check;
    } else if (status.isPermanentlyDenied) {
      statusColor = AppTheme.error;
      statusText = "DENIED PERMANENTLY";
      statusIcon = FontAwesomeIcons.ban;
    } else {
      statusColor = Colors.orange;
      statusText = "REQUEST NEEDED";
      statusIcon = FontAwesomeIcons.exclamation;
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
                      color: AppTheme.background,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: FaIcon(icon, color: AppTheme.primary, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 4),
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
                  ),
                  Icon(statusIcon, color: statusColor),
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
                  child: ElevatedButton.icon(
                    onPressed: onTest,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text("TEST FEATURE"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary.withOpacity(0.2),
                      foregroundColor: AppTheme.primary,
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
