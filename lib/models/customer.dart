class Customer {
  int? id;
  String firstName;
  String lastName;
  String address;
  String birthday;

  Customer({this.id, required this.firstName, required this.lastName, required this.address, required this.birthday});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'address': address,
      'birthday': birthday,
    };
  }
}
