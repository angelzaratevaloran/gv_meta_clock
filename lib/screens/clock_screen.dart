import 'dart:async';

import 'package:camera/camera.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gv_meta_clock/models/record_employee.dart';
import 'package:gv_meta_clock/services/employee.service.dart';
import 'package:gv_meta_clock/services/record_employee.service.dart';
import 'package:gv_meta_clock/widgets/cam_widget.dart';
import 'package:gv_meta_clock/widgets/clock_widget.dart';
import 'package:intl/intl.dart';



class ClockScreen extends StatefulWidget {
  final CameraDescription cam;
  final String appTitle; 
  const ClockScreen({super.key, required this.appTitle, required this.cam});

  @override
  State<ClockScreen> createState() => _ClockScreenState();
}

class _ClockScreenState extends State<ClockScreen> {
  final EmployeeService _employeeService = EmployeeService();  
  final _txtField = TextEditingController();
  var _buttonDisabled = true;  


  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _subscription;
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final serviceRecordEmployee = RecordEmployeeService();

  final FocusNode _focusNode = FocusNode();





  @override
  void initState() {
    super.initState();
    initConnectivity();
    _subscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  


  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }





 // Connectivitty
 Future<void> initConnectivity() async {
  late ConnectivityResult result;
  try {
    result = await _connectivity.checkConnectivity();

  }
  on PlatformException {
    return;
  }
  if(!mounted) {
    return Future.value(null);
  }
  
    return _updateConnectionStatus(result);
 }

 Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;

      if(result.name == "wifi") { 
        RecordEmployeeService().sync();
      }
    });
  }


 





  void checkEmployee(BuildContext context, bool entrada) async {
    if (_txtField.text.isEmpty) {
      return;
    }
    final badge = _txtField.text;
    if (badge.isNotEmpty && badge != "-1") {
      final numberBadge = int.parse(badge);
      final employee = await _employeeService.checkBadge(numberBadge);
      var dateTime = DateFormat("yyyy-MM-ddTHH:mm:ss").format(DateTime.now());
      var record = RecordEmployee(badge: numberBadge, photo: "", dateTime: dateTime, state: entrada);
      _txtField.clear();    
      _focusNode.requestFocus();  
      Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) => CamWidget(
                cam: widget.cam,
                record: record,
                employee: employee,
              )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.appTitle)),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const ClockWidget(),
          const Padding(padding: EdgeInsets.only(bottom: 20)),
          SizedBox(
            width: 600,
            child: TextFormField(
              onChanged: (value) {
                setState(() {
                  _buttonDisabled = value.isEmpty;                
                });
              },
              autofocus: true,
              controller: _txtField,
              focusNode: _focusNode,
              maxLength: 6,
              style: const TextStyle(fontSize: 18),
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Número de Nomina',
                suffixIcon: IconButton(
                  onPressed: () {
                    _txtField.clear();
                  },
                  icon: const Icon(Icons.clear),
                ),
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.only(bottom: 20)),
          SizedBox(
            width: 600,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Color.fromARGB(_buttonDisabled ? 128 : 255, 73, 179, 77),
                    padding: const EdgeInsets.only(
                        left: 25, top: 10, right: 25, bottom: 10),
                  ),
                  onPressed: () => checkEmployee(context, true),
                  child: const Text(
                    "Registrar Entrada",
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Color.fromARGB(
                        _buttonDisabled ? 128 : 255, 231, 41, 28),
                    padding: const EdgeInsets.only(
                        left: 25, top: 10, right: 25, bottom: 10),
                  ),
                  onPressed: () => checkEmployee(context, false),
                  child: const Text(
                    "Registrar Salida",
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
              ],
            ),
          )
        ]),
      ),
    
      bottomSheet: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        color: Colors.blue,
        height: 30,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          
          children: [
            Text('Estado De Red: ${_connectionStatus.name}', style: const TextStyle(color: Colors.white, fontSize: 24)), 
            // Text('Asistencias Recolectadas:1    |    Por Sincronizar : $_totalAttendancesToday', style: const TextStyle(color: Colors.white, fontSize: 24)),             
          ]
          
        ),


      ) //  const Text("Hola mundo", style: TextStyle(color: Colors.purpleAccent, fontSize: 24),),
    
      // footer: new Footer(child: child)

    );
  }
}
