import 'package:flutter/material.dart';
import 'database_helper.dart';

class AirplaneFormPage extends StatefulWidget {
  final Map<String, dynamic> airplane;

  AirplaneFormPage({this.airplane});

  @override
  _AirplaneFormPageState createState() => _AirplaneFormPageState();
}

class _AirplaneFormPageState extends State<AirplaneFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _type;
  int _passengers;
  int _maxSpeed;
  int _range;
  final dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    if (widget.airplane != null) {
      _type = widget.airplane['type'];
      _passengers = widget.airplane['passengers'];
      _maxSpeed = widget.airplane['maxSpeed'];
      _range = widget.airplane['range'];
    }
  }

  void _saveAirplane() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      final airplane = {
        'type': _type,
        'passengers': _passengers,
        'maxSpeed': _maxSpeed,
        'range': _range,
      };
      if (widget.airplane != null) {
        airplane['id'] = widget.airplane['id'];
        dbHelper.updateAirplane(airplane);
      } else {
        dbHelper.insertAirplane(airplane);
      }
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.airplane == null ? 'Add Airplane' : 'Edit Airplane'),
        ),
        body: Padding(
        padding: const EdgeInsets.all(16.0),
    child: Form(
    key: _formKey,
    child: Column(
    children: <Widget>[
    TextFormField(
    initialValue: _type,
    decoration: InputDecoration(labelText: 'Type'),
    validator: (value) => value.isEmpty ? 'Please enter airplane type' : null,
    onSaved: (value) => _type = value,
    ),
    TextFormField(
    initialValue: _passengers?.toString(),
    decoration: InputDecoration(labelText: 'Passengers'),
    validator: (value) => value.isEmpty ? 'Please enter number of passengers' : null,
    onSaved: (value) => _passengers = int.parse(value),
    ),
    TextFormField(
    initialValue: _maxSpeed?.toString(),
    decoration: InputDecoration(labelText: 'Max Speed'),
    validator: (value) => value.isEmpty ? 'Please enter max speed' : null,
    onSaved: (value
