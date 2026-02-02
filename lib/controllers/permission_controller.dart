import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionController extends ChangeNotifier {
  Map<Permission, PermissionStatus> _statuses = {};

  PermissionStatus getStatus(Permission permission) {
    return _statuses[permission] ?? PermissionStatus.denied;
  }

  Future<void> checkAllPermissions() async {
    Map<Permission, PermissionStatus> newStatuses = {};
    List<Permission> permissionsToCheck = [
      Permission.camera,
      Permission.location,
      Permission.microphone,
      Permission.photos, // or storage depending on OS
      Permission.contacts,
    ];

    for (var permission in permissionsToCheck) {
      newStatuses[permission] = await permission.status;
    }
    _statuses = newStatuses;
    notifyListeners();
  }

  Future<void> requestPermission(Permission permission) async {
    final status = await permission.request();
    _statuses[permission] = status;
    notifyListeners();
  }

  Future<void> openSettings() async {
    await openAppSettings();
  }
}
