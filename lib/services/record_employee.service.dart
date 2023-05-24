import 'dart:convert';
import 'dart:io';


import 'package:gv_meta_clock/models/notify.dart';
import 'package:gv_meta_clock/models/record_employee.dart';
import 'package:gv_meta_clock/services/database.service.dart';
import 'package:gv_meta_clock/services/http_api.service.dart';
import 'package:sqflite/sqflite.dart';
import "package:http/http.dart" as http;



class RecordEmployeeService {

  static final RecordEmployeeService _instance = RecordEmployeeService._internal();

  final HttpApi api = HttpApi();

  factory RecordEmployeeService () {
    return _instance;
  }

  RecordEmployeeService._internal();



  Future<Notify> register(RecordEmployee record) async {

    final db = await  DatabaseService().db();  
    await db.insert("attendances", record.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    final r = await sync();
    return r;
  }




  Future<Notify> sync() async  {
    var notify = Notify(status: 300, message: "Procesando en la nube...");
    final pendings = await getRecordsPendings();
    try {
      final response  = await http.post(api.getURI("attendances"), body:  jsonEncode(pendings), headers: {
        "Content-Type": "application/json",
      });
      if(response.statusCode == 200) {                  
        notify.message = "Registro exitoso!";
        notify.status = 200;
        final inArgs = List.generate(pendings.length, (i) => pendings[i]["id"]);
        final db = await  DatabaseService().db();
        db.update( "attendances", {"sended": 1}, where: "id in (${List.filled(inArgs.length, '?').join(',')})", whereArgs: inArgs );
        // db.close();
      }
    }
    on HttpException {
      notify.message = "Error al conectar con el servidor";
      notify.status  = 500;
    }
    on SocketException {
      notify.message = "Error al conectar con el servidor";
      notify.status  = 500;
    }

    return notify;    
  }







  Future<List<dynamic>> getRecordsPendings() async {

    final db = await  DatabaseService().db();
    final List<Map<String, dynamic>> maps = await db.query("attendances", where: "sended = ?", whereArgs: [0]);
    // db.close();

    return List.generate(maps.length, (i) {

      return {
        "id": maps[i]["id"],
        "badge": maps[i]["badge"], 
        "datetime": maps[i]["date_time"], 
        "state": maps[i]["state"] == 1 ? true : false, 
        "photo":  maps[i]["photo"], 
        "location": maps[i]["location"]
      };
    });
  }
}