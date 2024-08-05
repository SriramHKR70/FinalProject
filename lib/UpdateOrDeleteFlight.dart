import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Flight.dart';
class UpdateOrDeleteFlight extends StatelessWidget {
  final Flight selectedFlight;
  final Function(String, String, String, String) onUpdate;
  final VoidCallback onDelete;
  UpdateOrDeleteFlight({
    super.key,
    required this.selectedFlight,
    required this.onUpdate,
    required this.onDelete
  }) {_loadFlightData();}
  final _formKey = GlobalKey<FormState>();
  final _departureCityController = TextEditingController();
  final _destinationCityController = TextEditingController();
  final _departureTimeController = TextEditingController();
  final _arrivalTimeController = TextEditingController();
  void _loadFlightData() {
    _departureCityController.text = selectedFlight.departureCity;
    _destinationCityController.text = selectedFlight.destinationCity;
    _departureTimeController.text = selectedFlight.departureTime;
    _arrivalTimeController.text = selectedFlight.arrivalTime;
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
        title: const Text('Edit Flight'),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _saveSharedPreferences();
                      onUpdate(
                        _departureCityController.text,
                        _destinationCityController.text,
                        _departureTimeController.text,
                        _arrivalTimeController.text,
                      );
                    }
                  },
                  child: const Text('Update')
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _saveSharedPreferences();
                      onDelete();
                    }
                  },
                  child: const Text('Delete')
                )
              ]
            )
          ]
        )
      )
    );
  }
}