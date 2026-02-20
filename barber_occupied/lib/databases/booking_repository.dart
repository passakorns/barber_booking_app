
import 'package:barber_occupied/databases/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class BookingRepository {
  final dbHelper = DatabaseHelper.instanceDb;

  Future<String> createBooking(String date, String time, String service) async{

    final db = await dbHelper.conDb;

    try {
      //เพิ่มข้อมูลในตาราง
      await db.insert(
          'booking', 
          {'booking_date':date, 'booking_time':time, 'booking_service':service}, 
          conflictAlgorithm: ConflictAlgorithm.fail );
      return 'Success: จองคิวสำเร็จ';
    } catch (e) {
      return 'Error: เวลานี้มีคนจองแล้ว {$e}';
    }
  }

  Future<List<String>> getOccupiedSlots( String date) async {
    final db = await dbHelper.conDb;
    final result = await db.query(
                        'booking', 
                        columns: ['booking_time'],
                        where: 'booking_date = ?',
                        whereArgs: [date]
                        );
    return result.map((row)=>row['booking_time'] as String).toList();
  }
}