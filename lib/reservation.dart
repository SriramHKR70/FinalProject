class Reservation {
  int? id;
  String name;
  int customerId;
  int flightId;

  Reservation({this.id, required this.name, required this.customerId, required this.flightId});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'customerId': customerId,
      'flightId': flightId,
    };
  }
}
