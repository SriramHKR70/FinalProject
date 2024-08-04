import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'database_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reservation App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ReservationPage(),
    );
  }
}

class ReservationPage extends StatefulWidget {
  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _flightController = TextEditingController();
  final TextEditingController _departureCityController = TextEditingController();
  final TextEditingController _destinationCityController = TextEditingController();
  DateTime _departureTime = DateTime.now();
  DateTime _arrivalTime = DateTime.now().add(Duration(hours: 2));
  Locale _locale = Locale('en');
  List<Map<String, dynamic>> reservations = [];

  @override
  void initState() {
    super.initState();
    _loadReservations();
  }

  void _loadReservations() async {
    DatabaseHelper helper = DatabaseHelper();
    List<Map<String, dynamic>> data = await helper.getReservations();
    setState(() {
      reservations = data;
    });
  }

  void _addReservation(Map<String, dynamic> reservation) async {
    DatabaseHelper helper = DatabaseHelper();
    await helper.insertReservation(reservation);
    _loadReservations();
  }

  void _changeLanguage() {
    setState(() {
      _locale = _locale.languageCode == 'en' ? Locale('fr') : Locale('en');
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final reservation = {
        'title': _titleController.text,
        'customerName': _customerNameController.text,
        'flight': _flightController.text,
        'departureCity': _departureCityController.text,
        'destinationCity': _destinationCityController.text,
        'departureTime': _departureTime.toIso8601String(),
        'arrivalTime': _arrivalTime.toIso8601String(),
      };

      _addReservation(reservation);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_locale.languageCode == 'en' ? 'Reservations' : 'Réservations'),
        actions: [
          IconButton(
            icon: Icon(Icons.language),
            onPressed: _changeLanguage,
          ),
        ],
      ),
      body: reservations.isEmpty
          ? Center(child: Text(_locale.languageCode == 'en' ? 'No Reservations' : 'Aucune réservation'))
          : ListView.builder(
        itemCount: reservations.length,
        itemBuilder: (context, index) {
          final reservation = reservations[index];
          return Card(
            child: ListTile(
              leading: Icon(Icons.flight),
              title: Text(reservation['title']),
              subtitle: Text('${reservation['customerName']} - ${reservation['flight']}'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReservationDetailPage(reservation: reservation),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddReservationPage(onReservationAdded: _addReservation),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class ReservationDetailPage extends StatelessWidget {
  final Map<String, dynamic> reservation;

  ReservationDetailPage({required this.reservation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(reservation['title']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Customer Name: ${reservation['customerName']}'),
            SizedBox(height: 8.0),
            Text('Flight: ${reservation['flight']}'),
            SizedBox(height: 8.0),
            Text('Departure: ${reservation['departureCity']}'),
            SizedBox(height: 8.0),
            Text('Destination: ${reservation['destinationCity']}'),
            SizedBox(height: 8.0),
            Text('Departure Time: ${DateFormat.jm().format(DateTime.parse(reservation['departureTime']))}'),
            SizedBox(height: 8.0),
            Text('Arrival Time: ${DateFormat.jm().format(DateTime.parse(reservation['arrivalTime']))}'),
          ],
        ),
      ),
    );
  }
}

class AddReservationPage extends StatefulWidget {
  final Function(Map<String, dynamic>) onReservationAdded;

  AddReservationPage({required this.onReservationAdded});

  @override
  _AddReservationPageState createState() => _AddReservationPageState();
}

class _AddReservationPageState extends State<AddReservationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _flightController = TextEditingController();
  final TextEditingController _departureCityController = TextEditingController();
  final TextEditingController _destinationCityController = TextEditingController();
  DateTime _departureTime = DateTime.now();
  DateTime _arrivalTime = DateTime.now().add(Duration(hours: 2));
  Locale _locale = Locale('en');

  void _changeLanguage() {
    setState(() {
      _locale = _locale.languageCode == 'en' ? Locale('fr') : Locale('en');
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final reservation = {
        'title': _titleController.text,
        'customerName': _customerNameController.text,
        'flight': _flightController.text,
        'departureCity': _departureCityController.text,
        'destinationCity': _destinationCityController.text,
        'departureTime': _departureTime.toIso8601String(),
        'arrivalTime': _arrivalTime.toIso8601String(),
      };

      widget.onReservationAdded(reservation);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _locale.languageCode == 'en' ? 'Add Reservation' : 'Ajouter Réservation',
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.language),
            onPressed: _changeLanguage,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    'images/11.png',
                    height: 150,
                  ),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: _locale.languageCode == 'en' ? 'Title' : 'Titre',
                    prefixIcon: Icon(Icons.title),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return _locale.languageCode == 'en'
                          ? 'Please enter a title'
                          : 'Veuillez entrer un titre';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _customerNameController,
                  decoration: InputDecoration(
                    labelText: _locale.languageCode == 'en' ? 'Customer Name' : 'Nom du client',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return _locale.languageCode == 'en'
                          ? 'Please enter the customer name'
                          : 'Veuillez entrer le nom du client';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _flightController,
                  decoration: InputDecoration(
                    labelText: _locale.languageCode == 'en' ? 'Flight' : 'Vol',
                    prefixIcon: Icon(Icons.flight_takeoff),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return _locale.languageCode == 'en'
                          ? 'Please enter the flight'
                          : 'Veuillez entrer le vol';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _departureCityController,
                  decoration: InputDecoration(
                    labelText: _locale.languageCode == 'en' ? 'Departure City' : 'Ville de départ',
                    prefixIcon: Icon(Icons.location_city),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return _locale.languageCode == 'en'
                          ? 'Please enter the departure city'
                          : 'Veuillez entrer la ville de départ';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _destinationCityController,
                  decoration: InputDecoration(
                    labelText: _locale.languageCode == 'en' ? 'Destination City' : 'Ville de destination',
                    prefixIcon: Icon(Icons.location_city),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return _locale.languageCode == 'en'
                          ? 'Please enter the destination city'
                          : 'Veuillez entrer la ville de destination';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    Text(
                      _locale.languageCode == 'en' ? 'Departure Time:' : 'Heure de départ:',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Spacer(),
                    TextButton(
                      onPressed: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(_departureTime),
                        );
                        if (time != null) {
                          setState(() {
                            _departureTime = DateTime(
                              _departureTime.year,
                              _departureTime.month,
                              _departureTime.day,
                              time.hour,
                              time.minute,
                            );
                          });
                        }
                      },
                      child: Text(
                        DateFormat.jm().format(_departureTime),
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    Text(
                      _locale.languageCode == 'en' ? 'Arrival Time:' : 'Heure d\'arrivée:',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Spacer(),
                    TextButton(
                      onPressed: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(_arrivalTime),
                        );
                        if (time != null) {
                          setState(() {
                            _arrivalTime = DateTime(
                              _arrivalTime.year,
                              _arrivalTime.month,
                              _arrivalTime.day,
                              time.hour,
                              time.minute,
                            );
                          });
                        }
                      },
                      child: Text(
                        DateFormat.jm().format(_arrivalTime),
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Center(
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    child: Text(
                      _locale.languageCode == 'en' ? 'Submit' : 'Soumettre',
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
                      textStyle: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
