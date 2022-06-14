import 'dart:async';
import 'dart:developer';
import 'dart:isolate';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:notification_listener_service/notification_listener_service.dart';

class FirstTaskHandler extends TaskHandler {
  int updateCount = 0;
  int counter = 0;

  void startCameraStream() {}

  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
    NotificationListenerService.notificationsStream.listen((event) {
      log("Current notification: $event");
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
