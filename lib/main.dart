import 'package:flutter/material.dart';
import 'package:driving_detection_app/pages/home.dart';
import 'package:flutter_portal/flutter_portal.dart';

void main() {
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
