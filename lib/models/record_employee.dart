class RecordEmployee {
    
    int? id;
    int badge;
    String photo;
    String dateTime;
    bool state; // entrada o salida
    String location = const String.fromEnvironment("CLOCK_LOCATION", defaultValue: "Default" );
    // const SOME_VAR = String.fromEnvironment('SOME_VAR', defaultValue: 'SOME_DEFAULT_VALUE');

    bool sended = false;


    RecordEmployee({
      id,
      required this.badge, 
      required this.photo,      
      required this.dateTime, 
      required this.state
    });


  Map<String, dynamic> toMap() {
    return {
      'badge': badge,
      'date_time': dateTime,
      'photo': photo,
      'sended': sended ? 1 : 0,
      'state': state == true ? 1 : 0,
      'location': location
    };
  }

  @override
  String toString() {
    return 'RecordEmployee{badge: $badge, date_time: $dateTime, photo: $photo, sended: $sended}';
  }
}