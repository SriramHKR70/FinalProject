import 'package:flutter/material.dart';
import 'database_helper.dart';

class FlightFormPage extends StatefulWidget {
  final Map<String, dynamic>? flight;

  FlightFormPage({this.flight});

  @override
  _FlightFormPageState createState() => _FlightFormPageState();
}

class _FlightFormPageState extends State<FlightFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _sourceController;
  late TextEditingController _destinationController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.flight?['name'] ?? '');
    _sourceController = TextEditingController(text: widget.flight?['source'] ?? '');
    _destinationController = TextEditingController(text: widget.flight?['destination'] ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _sourceController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.flight == null ? 'Add Flight' : 'Edit Flight'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Flight Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a flight name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _sourceController,
                decoration: InputDecoration(labelText: 'Source'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the source';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _destinationController,
                decoration: InputDecoration(labelText: 'Destination'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the destination';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    Map<String, dynamic> flight = {
                      'name': _nameController.text,
                      'source': _sourceController.text,
                      'destination': _destinationController.text,
                    };
                    if (widget.flight == null) {
                      await DatabaseHelper().insertFlight(flight);
                    } else {
                      flight['id'] = widget.flight!['id'];
                      await DatabaseHelper().updateFlight(flight);
                    }
                    Navigator.pop(context);
                  }
                },
                child: Text(widget.flight == null ? 'Add Flight' : 'Update Flight'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
