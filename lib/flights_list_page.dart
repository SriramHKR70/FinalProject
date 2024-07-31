import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'flight_form_page.dart';
import 'reservation_page.dart';

class FlightListPage extends StatefulWidget {
  @override
  _FlightListPageState createState() => _FlightListPageState();
}

class _FlightListPageState extends State<FlightListPage> {
  late Future<List<Map<String, dynamic>>> _flights;

  @override
  void initState() {
    super.initState();
    _loadFlights();
  }

  void _loadFlights() {
    setState(() {
      _flights = DatabaseHelper().getFlights();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flights List'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _flights,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No flights available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final flight = snapshot.data![index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    title: Text(flight['name']),
                    subtitle: Text('${flight['source']} -> ${flight['destination']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FlightFormPage(flight: flight),
                              ),
                            );
                            _loadFlights();
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            await DatabaseHelper().deleteFlight(flight['id']);
                            _loadFlights();
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReservationPage(flightId: flight['id']),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FlightFormPage(),
            ),
          );
          _loadFlights();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
