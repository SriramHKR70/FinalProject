import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'reservation_page.dart';
import 'package:intl/intl.dart';

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
      home: ReservationListPage(),
    );
  }
}

class ReservationListPage extends StatefulWidget {
  @override
  _ReservationListPageState createState() => _ReservationListPageState();
}

class _ReservationListPageState extends State<ReservationListPage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservations'),
      ),
      body: ListView.builder(
        itemCount: reservations.length,
        itemBuilder: (context, index) {
          final reservation = reservations[index];
          return Card(
            child: ListTile(
              leading: Icon(Icons.flight),
              title: Text(reservation['title']),
              subtitle: Text(
                  '${reservation['customerName']} - ${reservation['flight']}'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ReservationDetailPage(reservation: reservation),
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
              builder: (context) =>
                  ReservationPage(onReservationAdded: _addReservation),
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
            Text(
                'Departure Time: ${DateFormat.jm().format(DateTime.parse(reservation['departureTime']))}'),
            SizedBox(height: 8.0),
            Text(
                'Arrival Time: ${DateFormat.jm().format(DateTime.parse(reservation['arrivalTime']))}'),
          ],
        ),
      ),
    );
  }
}
