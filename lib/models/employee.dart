import 'dart:convert';



List<Employee> employeeFromJson(String str) => List<Employee>.from(json.decode(str)["data"].map((x) => Employee.fromJson(x)));

String employeeToJson(List<Employee> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));


class EmployeeResponse {
    EmployeeResponse ({
        required this.status,
        required this.data,
    });

    String status;
    Employee data;
    

    factory EmployeeResponse.fromJson(Map<String, dynamic> json) => EmployeeResponse(
        status: json["status"],
        data: Employee.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
    };
}








class Employee {
    Employee({
        required this.badge,
        required this.fullName,
        required this.location,
        
    });

    int badge;
    String fullName;
    String location;
    


    factory Employee.fromJson(Map<String, dynamic> json) => Employee(
        badge: int.parse(json["badge"]) ,
        fullName: json["full_name"],
        location: json["location"],
    );

    Map<String, dynamic> toJson() => {
        "badge": badge,
        "full_name": fullName,
        "location": location,
        
    };
}
