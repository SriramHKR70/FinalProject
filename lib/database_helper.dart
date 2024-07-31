import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'final_project.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(
      '''
      CREATE TABLE flights (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        source TEXT,
        destination TEXT
      )
      ''',
    );
    await db.execute(
      '''
      CREATE TABLE reservations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        flight_id INTEGER,
        seat_number TEXT,
        FOREIGN KEY (flight_id) REFERENCES flights (id)
      )
      ''',
    );
  }

  // CRUD methods for Flights
  Future<int> insertFlight(Map<String, dynamic> flight) async {
    Database db = await database;
    return await db.insert('flights', flight);
  }

  Future<List<Map<String, dynamic>>> getFlights() async {
    Database db = await database;
    return await db.query('flights');
  }

  Future<int> updateFlight(Map<String, dynamic> flight) async {
    Database db = await database;
    int id = flight['id'];
    return await db.update('flights', flight, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteFlight(int id) async {
    Database db = await database;
    return await db.delete('flights', where: 'id = ?', whereArgs: [id]);
  }

  // CRUD methods for Reservations
  Future<int> insertReservation(Map<String, dynamic> reservation) async {
    Database db = await database;
    return await db.insert('reservations', reservation);
  }

  Future<List<Map<String, dynamic>>> getReservations() async {
    Database db = await database;
    return await db.query('reservations');
  }

  Future<int> updateReservation(Map<String, dynamic> reservation) async {
    Database db = await database;
    int id = reservation['id'];
    return await db.update('reservations', reservation, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteReservation(int id) async {
    Database db = await database;
    return await db.delete('reservations', where: 'id = ?', whereArgs: [id]);
  }
}
