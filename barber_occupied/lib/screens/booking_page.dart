import 'package:barber_occupied/databases/booking_repository.dart';
import 'package:barber_occupied/models/booking.dart';
import 'package:barber_occupied/screens/handle_booking_page.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  DateTime selectedDay = DateTime.now()
      .add(const Duration(days: 1)); //วันที่ถูกเลือกเป็นวันพรุ่งนี้
  DateTime focusedDay =
      DateTime.now().add(const Duration(days: 1)); //วันที่เลือกเป็นวันพรุ่งนี้

  String selectedDate="";
  String selectedTime=""; //เวลาที่ถูกเลือก
  String selectedService=""; //รูปแบบการทำผมที่เลือก

  List<String> occupiedSlots = [];

  //รายการบริการของร้านทำผม
  List<String> service = [
    'ตัดผมชาย',
    'ตัดผมหญิง',
    'สระไดร์',
    'ทำสีผม',
    'โกนหนวด',
  ];

  //รายการเวลาที่รับจอง
  List<String> allTimeSlot = [
    '09:00',
    '10:00',
    '11:00',
    '13:00',
    '14:00',
    '15:00',
    '16:00',
    '17:00',
  ];
  final BookingRepository repository = BookingRepository();

  Future<void> loadOccupiedSlot() async {
    selectedDate = selectedDay.toIso8601String().split('T')[0];
    var occupied = await repository.getOccupiedSlots(selectedDate);

    setState(() {
      occupiedSlots = occupied;
      selectedTime = ""; //รีเซ็ตเวลาที่เลือกเมื่อเปลี่ยนวัน
    });
  }

  @override
  void initState() {
    super.initState();
    loadOccupiedSlot();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('จองคิวทำผม')),
      body: SingleChildScrollView(
        //ป้องกันหน้าจนล้น
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //1. ส่วนของวันที่ calendar
            TableCalendar(
              focusedDay: focusedDay,
              firstDay: DateTime.now().add(const Duration(days: 1)),
              lastDay: DateTime.now().add(const Duration(days: 30)),
              selectedDayPredicate: (day) {
                //ตรวจสอบวันที่ day ในปฏิทิน กับวันที่ถูกเลือกมาก่อน selectedDay
                return isSameDay(selectedDay, day);
              },
              onDaySelected: (stdDay, fcsDay) {
                setState(() {
                  selectedDay = stdDay;
                  focusedDay = fcsDay;
                });
                loadOccupiedSlot();
              },
            ),
            //2. ส่วนของเลือกรูปแบบการบริการ
            //Text('วันที่เลือก $selectedDate'),
            //Text(DateTime.now().toIso8601String()),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'เลือกรูปแบบบริการ: ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Wrap(
                  spacing: 8.0,
                  children: service.map((serve) {
                    return ChoiceChip(
                      label: Text(serve),
                      selected: selectedService == serve,
                      onSelected: (selected) {
                        setState(() {
                          selectedService = selected ? serve : "";
                        });
                      },
                      selectedColor: Colors.blue,
                      labelStyle: TextStyle(
                        color: selectedService == serve
                            ? Colors.white
                            : Colors.black,
                      ),
                    );
                  }).toList()),
            ),
            //3. ส่วนเลือกเวลา
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Text(
                'เลือกเวลาที่ว่าง: ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            GridView.builder(
                shrinkWrap:
                    true, //เพื่อให้ GridView อยู่ใน SinglechildScrollView

                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, //จำนวน 4 คอลัมน์ ต่อ 1 แถว
                    childAspectRatio: 2, //ความกว้าง 2 เท่าของความสูง
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),
                itemCount: allTimeSlot.length,
                itemBuilder: (context, index) {
                  var time = allTimeSlot[index];
                  var isFull = occupiedSlots.contains(
                      time); //ตรวจสอบเวลา time อยู่ในรายการที่จองหรือไม่
                  var isSelected = selectedTime == time;

                  return GestureDetector(
                    onTap: () {
                      if (isFull) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('ขออภัย เวลานี้มีผู้จองเต็มแล้ว'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      } else {
                        setState(() {
                          selectedTime = time;
                        });
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: isFull
                              ? Colors.grey
                              : (isSelected ? Colors.blue : Colors.white),
                          border: Border.all(
                              color: isSelected ? Colors.blue : Colors.white),
                          borderRadius: BorderRadius.circular(8)),
                      alignment: Alignment.center,
                      child: Text(time),
                    ),
                  );
                }),
            //4. ปุ่มยืนยันการจอง
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () {
                        checkData(context);
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      child: const Text('ยืนยันการจอง'))),
            )
          ],
        ),
      ),
    );
  }

  void checkData(BuildContext context) {
    selectedDate = selectedDay.toIso8601String().split('T')[0];
    String text = "";
    if (selectedDate.isEmpty) {
      text = "กรุณาเลือกวันที่ ที่ต้องการจอง";
    } else if (selectedTime.isEmpty) {
      text = "กรุณาเลือกเวลาที่สะดวก";
    } else if (selectedService.isEmpty) {
      text = "กรณาเลือกรูปแกบบบริการ";
    }

    if (text.isEmpty) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HandleBookingPage(
                    bookingDetails: Booking(
                        day: selectedDate,
                        time: selectedTime,
                        service: selectedService),
                  )));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(text),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ));
    }
  }
}
