import 'package:barber_occupied/databases/booking_repository.dart';
import 'package:barber_occupied/models/booking.dart';
import 'package:barber_occupied/screens/booking_page.dart';
import 'package:flutter/material.dart';

class HandleBookingPage extends StatelessWidget {
  

  final BookingRepository repository = BookingRepository();

  //ประกาศตัวแปรรับค่า
  final Booking bookingDetails;

  //constuctor รับค่า

  HandleBookingPage({super.key, required this.bookingDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: const Text('รายละเอียดการจอง'),
          automaticallyImplyLeading: false, //ป้องกันการกดกลับไปหน้าก่อนหน้า
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle_outline, color: Colors.green, size: 80),
                const SizedBox(height: 16),
                const Text(
                  'ยืนยันการเลือกบริการ',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                //นำค่าทีรับมาแสดงผล
                Text(
                  'วัน: ${bookingDetails.day}',
                  style: const TextStyle(fontSize: 20, color: Colors.red),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'เวลา: ${bookingDetails.time}',
                  style: const TextStyle(fontSize: 20, color: Colors.blue),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'ชื่อบริการ: ${bookingDetails.service}',
                  style: const TextStyle(fontSize: 20, color: Colors.green),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text('กรุณาแสดงหน้าจอนี้ต่อหน้าพนักงานเมื่อถึงร้าน'),
                const SizedBox(
                  height: 30,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  ElevatedButton(
                      onPressed: () => handleBooking(context),
                      child: const Text('บันทึกการจอง')),
                  const SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('ยกเลิก'))
                ])
              ],
            ),
          ),
        ));
  }

  void handleBooking(BuildContext context) async {
    final result = await repository.createBooking(
        bookingDetails.day, bookingDetails.time, bookingDetails.service);

    if (result.contains('Success')) {
      Navigator.push(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => const BookingPage()));
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(result)));
    }
  }
}
