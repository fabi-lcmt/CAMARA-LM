import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'presentation/pages/camera_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;

  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: CameraPage(
        camera: firstCamera,
      ),
    ),
  );
}
