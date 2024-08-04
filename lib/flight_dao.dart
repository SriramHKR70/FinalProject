import 'package:sqflite/sqflite.dart';
import 'database_helper.dart';
import '../models/flight.dart';

class FlightDao {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<List<Flight>> getFlights() async {
    final Database db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('flights');
    return List.generate(maps.length, (i) {
      return Flight(
        id: maps[i]['id'],
        departure: maps[i]['departure'],
        destination: maps[i]['destination'],
        departureTime: maps[i]['departureTime'],
        arrivalTime: maps[i]['arrivalTime'],
      );
    });
  }

  Future<void> insertFlight(Flight flight) async {
    final Database db = await _databaseHelper.database;
    await db.insert(
      'flights',
      flight.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
