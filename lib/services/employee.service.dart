import "dart:io";

import "package:gv_meta_clock/models/employee.dart";
import "package:gv_meta_clock/services/http_api.service.dart";
import "package:http/http.dart" as http;

// Singleton service
class EmployeeService {

  static final EmployeeService _instance = EmployeeService._internal();
  
  final HttpApi api = HttpApi();

  List<Employee> employees = List.empty();
  
  factory EmployeeService() {    
    
    return _instance;    
  }
  
  EmployeeService._internal();


  Future<void> getEmployees() async {

    try {
      final response = await http.get( api.getURI("employees"));            
      if(response.statusCode == 200) {
          final temp = employeeFromJson(response.body);
          employees = [...temp];
      }
    }
    on SocketException {
      employees = [...employees];      
    }
    on HttpException {
      employees = [...employees];
    }
  }



  /* P*/
  Future<Employee> findEmployee(int badge) async {
    Employee result = Employee(badge: badge, fullName: "Pendiente ...", location: "SODA");
    try {
      final response = await http.get(api.getURI("employees/$badge"));
      if (response.statusCode == 200 ) {
        
      }
    }

    on HttpException { 
      result.badge = badge;      
    }
    return result;
  }
  
  Future<Employee>  checkBadge(int badge) async {
    Employee result;        
    if(employees.isEmpty || employees.where((emp) => emp.badge == badge ).isEmpty ) {
      await getEmployees();
    }    
    try {
      result = employees.where((emp) => emp.badge == badge).first;
    }
    on StateError {            
      result = Employee(badge: badge, fullName: "Pendiente ...", location: "SODA");
    }
    return result;    
  }




    

}
