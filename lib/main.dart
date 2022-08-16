import 'dart:io';

import 'package:flutter/material.dart';
import 'package:driving_detection_app/pages/home.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:dart_vlc/dart_vlc.dart';
import 'package:driving_detection_app/services/utils.dart';

Future<void> main() async {
  await DartVLC.initialize(useFlutterNativeView: true);
  await createDirectory('./download');
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
