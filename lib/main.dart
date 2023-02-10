import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:gv_meta_clock/screens/clock_screen.dart';

void main() {
  // init  spanish lang
  initializeDateFormatting("es_MX", null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ClockScreen(),
    );
  }
}
