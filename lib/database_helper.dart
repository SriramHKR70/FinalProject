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
  }

  // CRUD methods

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
}
