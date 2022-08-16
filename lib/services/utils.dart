import 'dart:io';

Future<void> createDirectory(String path) async {
  var directory = Directory(path);
  if (!await directory.exists()) {
    await directory.create();
  }
}
