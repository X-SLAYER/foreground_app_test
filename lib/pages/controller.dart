import 'dart:developer';

import 'package:camera/camera.dart';

class CamController {
  CamController._();

  static Future<void> initCamera() async {
    final description = await availableCameras().then(
      (cameras) => cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
      ),
    );
    final _cameraController = CameraController(
      description,
      ResolutionPreset.low,
      enableAudio: false,
    );
    await _cameraController.initialize();
    await Future.delayed(const Duration(milliseconds: 500));
    _cameraController.startImageStream((img) async {
      log("Image captures: ${img.width} x ${img.height} -- ${img.format.raw}");
    });
  }
}
