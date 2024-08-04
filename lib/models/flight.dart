class Flight {
  int? id;
  String departure;
  String destination;
  String departureTime;
  String arrivalTime;

  Flight({this.id, required this.departure, required this.destination, required this.departureTime, required this.arrivalTime});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'departure': departure,
      'destination': destination,
      'departureTime': departureTime,
      'arrivalTime': arrivalTime,
    };
  }
}
