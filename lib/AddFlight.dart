import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class AddFlight extends StatelessWidget {
  final Function(String, String, String, String) onSubmit;
  AddFlight({super.key, required this.onSubmit}) {_loadSharedPreferences();}
  final _formKey = GlobalKey<FormState>();
  final _departureCityController = TextEditingController();
  final _destinationCityController = TextEditingController();
  final _departureTimeController = TextEditingController();
  final _arrivalTimeController = TextEditingController();
  Future<void> _loadSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _departureCityController.text = prefs.getString('departureCity') ?? '';
    _destinationCityController.text = prefs.getString('destinationCity') ?? '';
    _departureTimeController.text = prefs.getString('departureTime') ?? '';
    _arrivalTimeController.text = prefs.getString('arrivalTime') ?? '';
  }
  Future<void> _saveSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('departureCity', _departureCityController.text);
    prefs.setString('destinationCity', _destinationCityController.text);
    prefs.setString('departureTime', _departureTimeController.text);
    prefs.setString('arrivalTime', _arrivalTimeController.text);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Flight'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _departureCityController,
                    decoration: const InputDecoration(labelText: 'Departure City'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a departure city';
                      }
                      return null;
                    }
                  )
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: _destinationCityController,
                    decoration: const InputDecoration(labelText: 'Destination City'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a destination city';
                      }
                      return null;
                    }
                  )
                )
              ]
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _departureTimeController,
                    decoration: const InputDecoration(labelText: 'Departure Time'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a departure time';
                      }
                      return null;
                    }
                  )
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: _arrivalTimeController,
                    decoration: const InputDecoration(labelText: 'Arrival Time'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an arrival time';
                      }
                      return null;
                    },
                  )
                )
              ]
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _saveSharedPreferences();
                  onSubmit(
                    _departureCityController.text,
                    _destinationCityController.text,
                    _departureTimeController.text,
                    _arrivalTimeController.text,
                  );
                }
              },
              child: const Text('Submit'),
            )
          ]
        )
      )
    );
  }
}