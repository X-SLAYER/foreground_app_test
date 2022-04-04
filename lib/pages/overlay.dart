import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_overlay_apps/flutter_overlay_apps.dart';
import 'package:forground_app/pages/controller.dart';

class OverLayWidget extends StatefulWidget {
  const OverLayWidget({Key? key}) : super(key: key);

  @override
  State<OverLayWidget> createState() => _OverLayWidgetState();
}

class _OverLayWidgetState extends State<OverLayWidget> {
  @override
  void initState() {
    super.initState();
    FlutterOverlayApps.overlayListener().listen((event) {
      log("$event");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 0.0,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                "https://www.bozemanhelpcenter.org/uploads/4/6/3/7/4637709/editor/faceitcommunity-4.png",
                width: 120.0,
                height: 120.0,
              ),
              const SizedBox(height: 20.0),
              TextButton(
                onPressed: () {
                  FlutterOverlayApps.closeOverlay();
                },
                child: const Text("Close me"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
