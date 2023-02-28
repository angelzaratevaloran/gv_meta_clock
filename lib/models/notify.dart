class Notify {

  int status; 
  String message;


  Notify({
    required this.status, 
    required this.message
  });


  @override
  String toString() {

    return '{status: $status,  message: $message}';

  }

}