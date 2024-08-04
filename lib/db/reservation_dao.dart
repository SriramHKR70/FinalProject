import 'package:sqflite/sqflite.dart';
import 'database_helper.dart';
import '../models/reservation.dart';

class ReservationDao {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<List<Reservation>> getReservations() async {
    final Database db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('reservations');
    return List.generate(maps.length, (i) {
      return Reservation(
        id: maps[i]['id'],
        name: maps[i]['name'],
        customerId: maps[i]['customerId'],
        flightId: maps[i]['flightId'],
      );
    });
  }

  Future<void> insertReservation(Reservation reservation) async {
    final Database db = await _databaseHelper.database;
    await db.insert(
      'reservations',
      reservation.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
