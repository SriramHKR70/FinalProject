import 'package:flutter/material.dart';
import 'database_helper.dart';

class ReservationFormPage extends StatefulWidget {
  final Map<String, dynamic> reservation;

  ReservationFormPage({this.reservation});

  @override
  _ReservationFormPageState createState() => _ReservationFormPageState();
}

class _ReservationFormPageState extends State<ReservationFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _name;
  int _customerId;
  int _flightId;
  String _date;
  final dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    if (widget.reservation != null) {
      _name = widget.reservation['name'];
      _customerId = widget.reservation['customerId'];
      _flightId = widget.reservation['flightId'];
      _date = widget.reservation['date'];
    }
  }

  void _saveReservation() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      final reservation = {
        'name': _name,
        'customerId': _customerId,
        'flightId': _flightId,
        'date': _date,
      };
      if (widget.reservation != null) {
        reservation['id'] = widget.reservation['id'];
        dbHelper.updateReservation(reservation);
      } else {
        dbHelper.insertReservation(reservation);
      }
      Navigator.pop(context, true);
    }
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
            children: <Widget>[
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) => value.isEmpty ? 'Please enter name' : null,
                onSaved: (value) => _name = value,
              ),
              TextFormField(
                initialValue: _customerId?.toString(),
                decoration: InputDecoration(labelText: 'Customer ID'),
                validator: (value) => value.isEmpty ? 'Please enter customer ID' : null,
                onSaved: (value) => _customerId = int.parse(value),
              ),
              TextFormField(
                initialValue: _flightId?.toString(),
                decoration: InputDecoration(labelText: 'Flight ID'),
                validator: (value) => value.isEmpty ? 'Please enter flight ID' : null,
                onSaved: (value) => _flightId = int.parse(value),
              ),
              TextFormField(
                initialValue: _date,
                decoration: InputDecoration(labelText: 'Date'),
                validator: (value) => value.isEmpty ? 'Please enter date' : null,
                onSaved: (value) => _date = value,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveReservation,
                child: Text('Save Reservation'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
