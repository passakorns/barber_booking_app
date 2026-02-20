import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {

  static final DatabaseHelper instanceDb = DatabaseHelper._init();
  static Database? _conDb; //ตัวแปรการเชื่อมต่อ

  //Constructur name แบบ private
  DatabaseHelper._init();

  //เรียกใช้ฐานข้อมูล
  Future<Database> get conDb async{
    if (_conDb != null) return _conDb!; //กรณีมีการสร้างก่อนแล้ว
    _conDb = await _initDb('barber_booking.db'); //กรณีเปิดใช้งานครั้งแรก
    return _conDb ?? await _initDb('barber_booking.db');
  }
  Future<Database> _initDb(String filePath) async{
    var dbPath = await getDatabasesPath();
    var path = join(dbPath, filePath);

    return await openDatabase(
      path, 
      version: 1, 
      onCreate: _createDB);
  }

  //สร้างตาราง
  Future _createDB(Database db, int version) async {
    var sql = '''
              CREATE TABLE booking (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              booking_date TEXT NOT NULL,
              booking_time TEXT NOT NULL,
              booking_service TEXT NOT NULL,
              UNIQUE(booking_date, booking_time)
              )
              ''';
    await db.execute(sql);
  }
}