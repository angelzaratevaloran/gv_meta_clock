import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gv_meta_clock/models/record_employee.dart';
import 'package:gv_meta_clock/services/employee.service.dart';
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

  @override
  void initState() {
    super.initState();
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
    );
  }
}
