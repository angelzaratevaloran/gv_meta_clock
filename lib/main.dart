import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gv_meta_clock/services/employee.service.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:gv_meta_clock/screens/clock_screen.dart';
import 'package:kiosk_mode/kiosk_mode.dart';
import 'package:wakelock/wakelock.dart';
import "dart:io";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // init  spanish lang
  initializeDateFormatting("es_MX", null);
  // orientation
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft]);
  // fullscreen
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // camera frontal
  final cameras = await availableCameras();

  // kiosk mode
  await startKioskMode();
  // disable turn off screen
  Wakelock.enable();

  HttpOverrides.global = MyHttpOverrides();

  await (EmployeeService()).checkBadge(1288);
  var appName =
      const String.fromEnvironment("APP_NAME", defaultValue: "META-Reloj");

  runApp(MaterialApp(
      title: appName,
      home: ClockScreen(appTitle: appName, cam: cameras.last),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      )));
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
