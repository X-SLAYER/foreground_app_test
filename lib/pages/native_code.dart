import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NativeChannel extends StatefulWidget {
  const NativeChannel({Key? key}) : super(key: key);

  @override
  State<NativeChannel> createState() => _NativeChannelState();
}

class _NativeChannelState extends State<NativeChannel> {
  final MethodChannel _methodeChannel =
      const MethodChannel('x.slayer/running_apps');

  Future<void> _getRunningApps() async {
    try {
      final list = await _methodeChannel.invokeMethod('getApps');
      log("Running apps:  $list");
    } on PlatformException catch (error) {
      log("$error");
    }
  }

  Future<void> _enableAdministrative() async {
    try {
      final list = await _methodeChannel.invokeMethod('enable');
      log("Running apps:  $list");
    } on PlatformException catch (error) {
      log("$error");
    }
  }

  Future<void> _disable() async {
    try {
      final list = await _methodeChannel.invokeMethod('disable');
      log("Running apps:  $list");
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
                    await _getRunningApps();
                  },
                  child: const Text("Get Process apps"),
                ),
                const SizedBox(height: 20.0),
                TextButton(
                  onPressed: () async {
                    await _enableAdministrative();
                  },
                  child: const Text("Enable administrative"),
                ),
                const SizedBox(height: 20.0),
                TextButton(
                  onPressed: () async {
                    await _disable();
                  },
                  child: const Text("Disable administrative"),
                ),
                const SizedBox(height: 20.0),
                TextButton.icon(
                  onPressed: () async {
                    await lockScreen();
                  },
                  icon: const Icon(Icons.lock),
                  label: const Text("Lock Screen"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
