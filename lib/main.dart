import 'package:flutter/material.dart';
import 'package:driving_detection_app/pages/home.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:dart_vlc/dart_vlc.dart';
import 'package:driving_detection_app/services/utils.dart';
import 'package:yaml/yaml.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DartVLC.initialize(useFlutterNativeView: true);
  await createDirectory('./download');
  String appConfigData = await loadAssetAsString('app_config.yaml');
  Global.appConfig = loadYaml(appConfigData);

  runApp(Portal(
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      routes: {
        '/home': (context) => const Home(),
      },
    ),
  ));
}
