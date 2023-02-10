import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:gv_meta_clock/services/employee.service.dart';
import 'package:gv_meta_clock/widgets/clock_widget.dart';

class ClockScreen extends StatefulWidget {
  const ClockScreen({super.key});

  @override
  State<ClockScreen> createState() => _ClockScreenState();
}

class _ClockScreenState extends State<ClockScreen> {
  final EmployeeService _employeeService = EmployeeService();
  final String title = "GV META - Reloj Checador";
  @override
  void initState() {
    super.initState();
  }

  Future<String> scanBarCode() async {
    var badge = "";

    try {
      badge = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancelar", true, ScanMode.BARCODE);
    } on PlatformException {
      badge = "error";
    }
    return badge;
  }

  void checkEmployee(bool entrada) async {
    var badge = await scanBarCode();
    print("Code Scanned => " + badge);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const ClockWidget(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.only(
                      left: 75, top: 20, right: 75, bottom: 20),
                ),
                onPressed: () => checkEmployee(true),
                child: const Text(
                  "Registrar Entrada",
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.only(
                      left: 75, top: 20, right: 75, bottom: 20),
                ),
                onPressed: () => checkEmployee(false),
                child: const Text(
                  "Registrar Salida",
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ],
          )
        ]),
      ),
    );
  }
}
