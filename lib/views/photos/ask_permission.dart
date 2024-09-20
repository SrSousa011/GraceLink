import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io' show Platform;

class PermissionReq extends StatefulWidget {
  const PermissionReq({super.key});

  @override
  State<PermissionReq> createState() => _PermissionReqState();
}

class _PermissionReqState extends State<PermissionReq> {
  bool _isPermissionGranted = false;
  String _permissionStatus = '';

  @override
  void initState() {
    super.initState();
    _checkAndRequestPermissions();
  }

  Future<void> _checkAndRequestPermissions() async {
    try {
      bool granted = false;

      if (Platform.isAndroid) {
        await _requestAndroidPermissions();
        granted = await _areAllPermissionsGrantedAndroid();
      } else if (Platform.isIOS) {
        await _requestIOSPermissions();
        granted = await _areAllPermissionsGrantedIOS();
      }

      _updatePermissionStatus(granted);
    } catch (e) {
      _updatePermissionStatus(false, errorMessage: e.toString());
    }
  }

  Future<void> _requestAndroidPermissions() async {
    await Permission.camera.request();
    await Permission.storage.request();

    if (await Permission.camera.isDenied || await Permission.storage.isDenied) {
      await Permission.manageExternalStorage.request();
    }
  }

  Future<void> _requestIOSPermissions() async {
    await Permission.camera.request();
    await Permission.photos.request();
  }

  Future<void> _updatePermissionStatus(bool granted,
      {String? errorMessage}) async {
    setState(() {
      _isPermissionGranted = granted;
      _permissionStatus = granted
          ? 'Permissions granted!'
          : errorMessage ?? 'Permissions denied.';
    });
  }

  Future<bool> _areAllPermissionsGrantedAndroid() async {
    return (await Permission.camera.isGranted &&
        await Permission.storage.isGranted &&
        (await Permission.manageExternalStorage.status).isGranted);
  }

  Future<bool> _areAllPermissionsGrantedIOS() async {
    return (await Permission.camera.isGranted &&
        await Permission.photos.isGranted);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Storage Permission')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Tooltip(
              message:
                  'Precisamos de acesso à câmera e armazenamento para salvar suas fotos.',
              child: ElevatedButton(
                onPressed: _checkAndRequestPermissions,
                child: const Text('Check Permissions'),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _permissionStatus,
              style: TextStyle(
                fontSize: 16,
                color: _isPermissionGranted ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isPermissionGranted
                  ? null
                  : () {
                      openAppSettings();
                    },
              child: const Text('Open App Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
