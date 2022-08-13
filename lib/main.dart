import 'package:flutter/material.dart';
import 'package:driving_detection_app/pages/home.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/home',
    routes: {
      '/home': (context) => Home(),
    },
  ));
}
