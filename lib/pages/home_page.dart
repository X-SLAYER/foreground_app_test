import 'dart:async';
import 'dart:developer';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_accessibility_service/flutter_accessibility_service.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_overlay_apps/flutter_overlay_apps.dart';
import 'package:forground_app/pages/first_task_handler.dart';
import 'package:notification_listener_service/notification_listener_service.dart';
import 'package:system_alert_window/system_alert_window.dart';

// The callback function should always be a top-level function.

void startCallback() {
  FlutterForegroundTask.setTaskHandler(FirstTaskHandler());
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ReceivePort? _receivePort;

  Future<void> _initForegroundTask() async {
    await FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'notification_channel_id',
        channelName: 'Foreground Notification',
        channelDescription:
            'This notification appears when the foreground service is running.',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
        iconData: const NotificationIconData(
          resType: ResourceType.mipmap,
          resPrefix: ResourcePrefix.ic,
          name: 'launcher',
        ),
        buttons: [
          const NotificationButton(id: 'sendButton', text: 'Send'),
          const NotificationButton(id: 'testButton', text: 'Test'),
        ],
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: const ForegroundTaskOptions(
        interval: 5000,
        autoRunOnBoot: true,
        allowWifiLock: true,
      ),
      printDevLog: true,
    );
  }

  Future<bool> _startForegroundTask() async {
    // You can save data using the saveData function.
    await initliszeSystemALert();
    await FlutterForegroundTask.saveData(key: 'customData', value: 'hello');

    ReceivePort? receivePort;
    if (await FlutterForegroundTask.isRunningService) {
      receivePort = await FlutterForegroundTask.restartService();
    } else {
      receivePort = await FlutterForegroundTask.startService(
        notificationTitle: 'Foreground Service is running',
        notificationText: 'Tap to return to the app',
        callback: startCallback,
      );
    }

    if (receivePort != null) {
      _receivePort = receivePort;
      _receivePort?.listen((message) {
        log("$message");

        log("message recieved: $message");
        if (message is DateTime) {
          log('receive timestamp: $message');
        } else if (message is int) {
          log('receive updateCount: $message');
        }
      });
      // initCamera();
      FlutterOverlayApps.showOverlay(
        height: 500,
        alignment: OverlayAlignment.center,
      );
      return true;
    }

    return false;
  }

  Future<bool> _stopForegroundTask() async {
    SystemAlertWindow.closeSystemWindow();
    return await FlutterForegroundTask.stopService();
  }

  @override
  void initState() {
    super.initState();
    _initForegroundTask();
    NotificationListenerService.requestPermission();
  }

  @override
  void dispose() {
    _receivePort?.close();
    super.dispose();
  }

  Future<void> initliszeSystemALert() async {
    await SystemAlertWindow.requestPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // A widget that prevents the app from closing when the foreground service is running.
      // This widget must be declared above the [Scaffold] widget.
      home: WithForegroundTask(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Flutter Foreground Task'),
            centerTitle: true,
          ),
          body: _buildContentView(),
        ),
      ),
    );
  }

  Widget _buildContentView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildTestButton('requestPermission', onPressed: () async {
            await FlutterAccessibilityService.requestAccessibilityPermission();
          }),
          _buildTestButton('start', onPressed: _startForegroundTask),
          _buildTestButton('stop', onPressed: _stopForegroundTask),
          _buildTestButton('Open popout', onPressed: () {
            SystemAlertWindow.showSystemWindow(
              height: 200,
              header: header,
              body: body,
              footer: footer,
              margin: SystemWindowMargin(
                left: 8,
                right: 8,
                top: 100,
                bottom: 0,
              ),
              gravity: SystemWindowGravity.BOTTOM,
              notificationTitle: "Hello",
              notificationBody: "How are you",
              prefMode: SystemWindowPrefMode.DEFAULT,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTestButton(String text, {VoidCallback? onPressed}) {
    return SizedBox(
      width: 200,
      child: ElevatedButton(
        child: Text(text),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(primary: const Color(0xFF587C8F)),
      ),
    );
  }
}
