import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io' show Platform;

class PermissionReq extends StatefulWidget {
  const PermissionReq({super.key});

  @override
  State<PermissionReq> createState() => _PermissionReqState();
}

Future<void> requestAllPermissionsAndroid() async {
  // Solicite permissões básicas
  await Permission.camera.request();
  await Permission.storage.request();

  // Solicite permissão de gerenciamento de armazenamento se necessário
  if (await Permission.camera.isDenied || await Permission.storage.isDenied) {
    await Permission.manageExternalStorage.request();
  }
}

Future<void> requestAllPermissionsIOS() async {
  // Solicite permissões de câmera e fotos
  await Permission.camera.request();
  await Permission.photos.request();
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
    bool granted;
    try {
      if (Platform.isAndroid) {
        await requestAllPermissionsAndroid();
        granted = await _areAllPermissionsGrantedAndroid();
      } else if (Platform.isIOS) {
        await requestAllPermissionsIOS();
        granted = await _areAllPermissionsGrantedIOS();
      } else {
        granted = false;
      }

      setState(() {
        _isPermissionGranted = granted;
        _permissionStatus =
            granted ? 'Permissions granted!' : 'Permissions denied.';
      });
    } catch (e) {
      setState(() {
        _isPermissionGranted = false;
        _permissionStatus = 'Failed to check permissions: ${e.toString()}';
      });
    }
  }

  Future<void> _ensurePermissions() async {
    bool granted = false;
    try {
      while (!granted) {
        if (Platform.isAndroid) {
          await requestAllPermissionsAndroid();
          granted = await _areAllPermissionsGrantedAndroid();
        } else if (Platform.isIOS) {
          await requestAllPermissionsIOS();
          granted = await _areAllPermissionsGrantedIOS();
        } else {
          granted = false;
        }

        if (granted) {
          setState(() {
            _isPermissionGranted = true;
            _permissionStatus = 'Permissions granted!';
          });
          return;
        } else {
          setState(() {
            _isPermissionGranted = false;
            _permissionStatus = 'Permissions denied. Please try again.';
          });
          await Future.delayed(
              const Duration(seconds: 2)); // Delay before retry
        }
      }
    } catch (e) {
      setState(() {
        _isPermissionGranted = false;
        _permissionStatus = 'Failed to ensure permissions: ${e.toString()}';
      });
    }
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
            ElevatedButton(
              onPressed: _checkAndRequestPermissions,
              child: const Text('Check Permissions'),
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
              onPressed: _ensurePermissions,
              child: const Text('Ensure Permissions'),
            ),
          ],
        ),
      ),
    );
  }
}
