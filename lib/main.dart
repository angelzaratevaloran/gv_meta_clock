import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gv_meta_clock/services/employee.service.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:gv_meta_clock/screens/clock_screen.dart';
import 'package:kiosk_mode/kiosk_mode.dart';
import 'package:wakelock/wakelock.dart';

void main() async {

  

  WidgetsFlutterBinding.ensureInitialized();
  // init  spanish lang
  initializeDateFormatting("es_MX", null);
  // orientation
  await SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
  // fullscreen
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // camare frontals
  final cameras  = await availableCameras();

  // kiosk mode
  await startKioskMode();
  // disable turn off screen
  Wakelock.enable();
  
  await( EmployeeService()).checkBadge(1288);
  var appName =  const String.fromEnvironment("APP_NAME", defaultValue: "META-Reloj");


  runApp(
    MaterialApp(
      title: appName,
      home: ClockScreen( appTitle: appName, cam: cameras.last),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      )
    )      
  );  
}