import 'package:flutter/material.dart';
import 'package:driving_detection_app/pages/home.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:dart_vlc/dart_vlc.dart';

Future<void> main() async {
  await DartVLC.initialize(useFlutterNativeView: true);
  runApp(Portal(
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      routes: {
        '/home': (context) => Home(),
      },
    ),
  ));
}
