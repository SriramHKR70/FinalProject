import 'package:flutter/material.dart';
import 'database_helper.dart';

class CustomerFormPage extends StatefulWidget {
  final Map<String, dynamic> customer;

  CustomerFormPage({this.customer});

  @override
  _CustomerFormPageState createState() => _CustomerFormPageState();
}

class _CustomerFormPageState extends State<CustomerFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _firstName;
  String _lastName;
  String _address;
  String _birthday;
  final dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    if (widget.customer != null) {
      _firstName = widget.customer['firstName'];
      _lastName = widget.customer['lastName'];
      _address = widget.customer['address'];
      _birthday = widget.customer['birthday'];
    }
  }

  void _saveCustomer() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      final customer = {
        'firstName': _firstName,
        'lastName': _lastName,
        'address': _address,
        'birthday': _birthday,
      };
      if (widget.customer != null) {
        customer['id'] = widget.customer['id'];
        dbHelper.updateCustomer(customer);
      } else {
        dbHelper.insertCustomer(customer);
      }
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.customer == null ? 'Add Customer' : 'Edit Customer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: _firstName,
                decoration: InputDecoration(labelText: 'First Name'),
                validator: (value) => value.isEmpty ? 'Please enter first name' : null,
                onSaved: (value) => _firstName = value,
              ),
              TextFormField(
                initialValue: _lastName,
                decoration: InputDecoration(labelText: 'Last Name'),
                validator: (value) => value.isEmpty ? 'Please enter last name' : null,
                onSaved: (value) => _lastName = value,
              ),
              TextFormField(
                initialValue: _address,
                decoration: InputDecoration(labelText: 'Address'),
                validator: (value) => value.isEmpty ? 'Please enter address' : null,
                onSaved: (value) => _address = value,
              ),
              TextFormField(
                initialValue: _birthday,
                decoration: InputDecoration(labelText: 'Birthday'),
                validator: (value) => value.isEmpty ? 'Please enter birthday' : null,
                onSaved: (value) => _birthday = value,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveCustomer,
                child: Text('Save Customer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
