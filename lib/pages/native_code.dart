import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NativeChannel extends StatefulWidget {
  const NativeChannel({Key? key}) : super(key: key);

  @override
  State<NativeChannel> createState() => _NativeChannelState();
}

class _NativeChannelState extends State<NativeChannel> {
  final MethodChannel _methodeChannel = const MethodChannel('x.slayer/tests');
  final EventChannel _eventChannel = const EventChannel('event.accessibility');

  Stream<dynamic> _stream = const Stream.empty();

  Stream get accessStream {
    _stream =
        _eventChannel.receiveBroadcastStream().map<dynamic>((event) => event);
    return _stream;
  }

  Future<void> enableAdministrative() async {
    try {
      final isEnabled = await _methodeChannel.invokeMethod('enable');
      log("Enabled:  $isEnabled");
    } on PlatformException catch (error) {
      log("$error");
    }
  }

  Future<void> requestAccessibilityPermission() async {
    try {
      await _methodeChannel.invokeMethod('requestAccessibilityPermission');
    } on PlatformException catch (error) {
      log("$error");
    }
  }

  Future<bool> isAccessibilityPermissionEnabled() async {
    try {
      return await _methodeChannel
          .invokeMethod('isAccessibilityPermissionEnabled');
    } on PlatformException catch (error) {
      log("$error");
      return false;
    }
  }

  Future<void> disable() async {
    try {
      await _methodeChannel.invokeMethod('disable');
    } on PlatformException catch (error) {
      log("$error");
    }
  }

  Future<void> lockScreen() async {
    try {
      final list = await _methodeChannel.invokeMethod('lockScreen');
      log("Running apps:  $list");
    } on PlatformException catch (error) {
      log("$error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () async {
                    final res = await isAccessibilityPermissionEnabled();
                    log("ENabled: $res");
                  },
                  child: const Text("Check accessiblity service"),
                ),
                const SizedBox(height: 20.0),
                TextButton(
                  onPressed: () async {},
                  child: const Text("Request accessiblity service"),
                ),
                const SizedBox(height: 20.0),
                TextButton(
                  onPressed: () async {},
                  child: const Text("Listen to stream"),
                ),
                const SizedBox(height: 20.0),
                // TextButton(
                //   onPressed: () async {
                //     await _enableAdministrative();
                //   },
                //   child: const Text("Enable administrative"),
                // ),
                // const SizedBox(height: 20.0),
                // TextButton(
                //   onPressed: () async {
                //     await _disable();
                //   },
                //   child: const Text("Disable administrative"),
                // ),
                // const SizedBox(height: 20.0),
                // TextButton.icon(
                //   onPressed: () async {
                //     await lockScreen();
                //   },
                //   icon: const Icon(Icons.lock),
                //   label: const Text("Lock Screen"),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
