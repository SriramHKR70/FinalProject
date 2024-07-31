import 'package:flutter/material.dart';
import 'database_helper.dart';

class ReservationPage extends StatefulWidget {
  final int? flightId;
  final Map<String, dynamic>? reservation;

  ReservationPage({this.flightId, this.reservation});

  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _seatNumberController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.reservation?['name'] ?? '');
    _seatNumberController = TextEditingController(text: widget.reservation?['seat_number'] ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _seatNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.reservation == null ? 'Add Reservation' : 'Edit Reservation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _seatNumberController,
                decoration: InputDecoration(labelText: 'Seat Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the seat number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    Map<String, dynamic> reservation = {
                      'name': _nameController.text,
                      'flight_id': widget.flightId,
                      'seat_number': _seatNumberController.text,
                    };
                    if (widget.reservation == null) {
                      await DatabaseHelper().insertReservation(reservation);
                    } else {
                      reservation['id'] = widget.reservation!['id'];
                      await DatabaseHelper().updateReservation(reservation);
                    }
                    Navigator.pop(context);
                  }
                },
                child: Text(widget.reservation == null ? 'Add Reservation' : 'Update Reservation'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
