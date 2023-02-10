import "package:http/http.dart" as http;

// Singleton service
class EmployeeService {
  static final EmployeeService _instance = EmployeeService._internal();

  factory EmployeeService() {
    return _instance;
  }
  EmployeeService._internal();

  final String host = "192.168.1.74:8000";

  void check(int id) async {
    var uri = Uri.http(host, "employee/check");
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      print(response.body);
    } else {
      print("error en conexion al servidor respuesta");
    }
  }
}
