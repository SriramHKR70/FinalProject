import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'reservation.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE reservations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        customerName TEXT,
        flight TEXT,
        departureCity TEXT,
        destinationCity TEXT,
        departureTime TEXT,
        arrivalTime TEXT
      )
    ''');
  }

  Future<List<Map<String, dynamic>>> getReservations() async {
    Database db = await database;
    return await db.query('reservations');
  }

  Future<void> insertReservation(Map<String, dynamic> reservation) async {
    Database db = await database;
    await db.insert('reservations', reservation);
  }
}