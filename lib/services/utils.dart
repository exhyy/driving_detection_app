import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;

Future<void> createDirectory(String path) async {
  var directory = Directory(path);
  if (!await directory.exists()) {
    await directory.create();
  }
}

Future<String> loadAssetAsString(String assetPath) async {
  return await rootBundle.loadString(assetPath);
}