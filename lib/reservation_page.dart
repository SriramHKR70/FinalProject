import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'reservation_form_page.dart';

class ReservationPage extends StatefulWidget {
  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  final dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> reservationsList = [];

  @override
  void initState() {
    super.initState();
    _fetchReservations();
  }

  void _fetchReservations() async {
    final allRows = await dbHelper.queryAllReservations();
    setState(() {
      reservationsList = allRows;
    });
  }

  void _addReservation() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ReservationFormPage()),
    ).then((value) {
      if (value != null) {
        _fetchReservations();
      }
    });
  }

  void _updateReservation(Map<String, dynamic> reservation) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ReservationFormPage(reservation: reservation)),
    ).then((value) {
      if (value != null) {
        _fetchReservations();
      }
    });
  }

  void _deleteReservation(int id) async {
    await dbHelper.deleteReservation(id);
    _fetchReservations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservations'),
      ),
      body: ListView.builder(
        itemCount: reservationsList.length,
        itemBuilder: (context, index) {
          final reservation = reservationsList[index];
          return ListTile(
            title: Text(reservation['name']),
            subtitle: Text('Customer ID: ${reservation['customerId']}, Flight ID: ${reservation['flightId']}, Date: ${reservation['date']}'),
            onTap: () => _updateReservation(reservation),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _deleteReservation(reservation['id']),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addReservation,
        tooltip: 'Add Reservation',
        child: Icon(Icons.add),
      ),
    );
  }
}
