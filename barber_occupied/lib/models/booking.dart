class Booking{
  final String day;
  final String time;
  final String service;

  Booking({required this.day, required this.time, required this.service});

  //แปลง object booking เป็นข้อมูลรูปแบบ map

  Map<String, String> toMap(){
    return{
      'day': day,
      'time': time,
      'service': service
    };
  }
  //Constructur แปลง map booking เป็น object booking
  factory Booking.formMap(Map<String, String> map){
    return Booking(
      day: map['day']!, 
      time: map['time']!, 
      service: map['service']!);
  }
}