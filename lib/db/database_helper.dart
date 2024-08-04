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
    String path = join(await getDatabasesPath(), 'airline_management.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      '''
      CREATE TABLE customers(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        firstName TEXT,
        lastName TEXT,
        address TEXT,
        birthday TEXT
      )
      ''',
    );
    await db.execute(
      '''
      CREATE TABLE airplanes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT,
        passengers INTEGER,
        speed INTEGER,
        range INTEGER
      )
      ''',
    );
    await db.execute(
      '''
      CREATE TABLE flights(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        departure TEXT,
        destination TEXT,
        departureTime TEXT,
        arrivalTime TEXT
      )
      ''',
    );
    await db.execute(
      '''
      CREATE TABLE reservations(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        customerId INTEGER,
        flightId INTEGER
      )
      ''',
    );
  }
}
