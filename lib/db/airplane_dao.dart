import 'package:sqflite/sqflite.dart';
import 'database_helper.dart';
import '../models/airplane.dart';

class AirplaneDao {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<List<Airplane>> getAirplanes() async {
    final Database db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('airplanes');
    return List.generate(maps.length, (i) {
      return Airplane(
        id: maps[i]['id'],
        type: maps[i]['type'],
        passengers: maps[i]['passengers'],
        speed: maps[i]['speed'],
        range: maps[i]['range'],
      );
    });
  }

  Future<void> insertAirplane(Airplane airplane) async {
    final Database db = await _databaseHelper.database;
    await db.insert(
      'airplanes',
      airplane.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
