import 'dart:async';
import 'dart:developer';
import 'dart:isolate';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

class FirstTaskHandler extends TaskHandler {
  int updateCount = 0;
  int counter = 0;

  void startCameraStream() {}

  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
    Timer.periodic(const Duration(seconds: 5), (timer) {
      counter++;
      log("Counter: $counter");
      if (counter >= 5) {
        timer.cancel();
        FlutterOverlayWindow.showOverlay(
          height: 500,
          alignment: OverlayAlignment.center,
          enableDrag: true,
          overlayTitle: "Hello",
          overlayContent: "From the background",
        );
      }
    });
  }

  @override
  Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {}

  @override
  Future<void> onDestroy(DateTime timestamp, SendPort? sendPort) async {
    // You can use the clearAllData function to clear all the stored data.
    await FlutterForegroundTask.clearAllData();
  }

  @override
  void onButtonPressed(String id) {
    // Called when the notification button on the Android platform is pressed.
    log('onButtonPressed >> $id -- $updateCount');
  }
}
