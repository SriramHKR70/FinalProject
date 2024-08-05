import 'package:floor/floor.dart';
@entity
class Flight {
  @primaryKey
  final int id;
  final String departureCity;
  final String destinationCity;
  final String departureTime;
  final String arrivalTime;
  static int ID = 0;
  Flight(this.id, this.departureCity, this.destinationCity, this.departureTime, this.arrivalTime) {
    if (id >= ID) {
      ID = id + 1;
    }
  }
}