import 'package:flutter/material.dart';
import 'package:forground_app/pages/home_page.dart';
import 'package:forground_app/pages/overlay.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await CamController.initCamera();
  runApp(const MyApp());
}

// overlay entry point
@pragma("vm:entry-point")
void showOverlay() {
  runApp(
    const MaterialApp(
      color: Colors.transparent,
      debugShowCheckedModeBanner: false,
      home: OverLayWidget(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Foreground servive starter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
