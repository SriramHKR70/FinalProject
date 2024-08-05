import 'package:floor/floor.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'Flight.dart';
import 'FlightDAO.dart';
part 'FlightDatabase.g.dart';
@Database(version: 1, entities: [Flight])
abstract class FlightDatabase extends FloorDatabase {
  FlightDAO get flightDAO;
}