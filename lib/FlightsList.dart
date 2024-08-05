import 'package:flutter/material.dart';
import 'Flight.dart';
import 'FlightDAO.dart';
import 'FlightDatabase.dart';
import 'AddFlight.dart';
import 'UpdateOrDeleteFlight.dart';
class FlightsList extends StatefulWidget {
  const FlightsList({super.key});
  @override
  State<FlightsList> createState() => FlightsListState();
}
class FlightsListState extends State<FlightsList> {
  List<Flight> flights = [];
  late FlightDAO flightDAO;
  bool isLandscape = false;
  bool addFlight = false;
  Flight? selectedFlight;
  @override
  void initState() {
    super.initState();
    loadData();
  }
  void loadData() async {
    final database = await $FloorFlightDatabase.databaseBuilder('flight_database.db').build();
    flightDAO = database.flightDAO;
    List<Flight> fetchedFlights = await flightDAO.findAllFlights();
    setState(() {
      flights = fetchedFlights;
    });
  }
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
  void _showAlertDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
  void submit(String departureCity, String destinationCity, String departureTime, String arrivalTime) async {
    Flight newFlight = Flight(
      Flight.ID++,
      departureCity,
      destinationCity,
      departureTime,
      arrivalTime,
    );
    await flightDAO.insertFlight(newFlight);
    setState(() {
      flights.add(newFlight);
      selectedFlight = null;
      if (isLandscape) {
        addFlight = false;
      } else {
        Navigator.of(context).pop();
      }
    });
    _showSnackbar('Flight added successfully');
    _showAlertDialog('Success', 'Flight added successfully');
  }
  void update(String departureCity, String destinationCity, String departureTime, String arrivalTime) async {
    Flight updatedFlight = Flight(
      selectedFlight!.id,
      departureCity,
      destinationCity,
      departureTime,
      arrivalTime,
    );
    await flightDAO.updateFlight(updatedFlight);
    setState(() {
      loadData();
      selectedFlight = null;
      if (!isLandscape) {
        Navigator.of(context).pop();
      }
    });
    _showSnackbar('Flight updated successfully');
    _showAlertDialog('Success', 'Flight updated successfully');
  }
  void delete() async {
    await flightDAO.deleteFlight(selectedFlight!);
    setState(() {
      flights.remove(selectedFlight);
      selectedFlight = null;
      if (!isLandscape) {
        Navigator.of(context).pop();
      }
    });
    _showSnackbar('Flight deleted successfully');
    _showAlertDialog('Success', 'Flight deleted successfully');
  }
  @override
  Widget build(BuildContext context) {
    isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text('Flights List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help),
            onPressed: () {
              _showAlertDialog('Instructions', 'Instructions on how to use the application.');
            },
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(child: buildFlightList()),
          if (isLandscape && addFlight == true)
            Expanded(child: buildAddFlight()),
          if (isLandscape && selectedFlight != null)
            Expanded(child: buildUpdateOrDeleteFlight())
        ],
      )
    );
  }
  Widget buildFlightList() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            child: const Text('Add Flight'),
            onPressed: () {
              if (isLandscape) {
                setState(() {
                  selectedFlight = null;
                  addFlight = true;
                });
              } else {
                Navigator.pushNamed(
                  context, '/AddFlight', arguments: (departureCity, destinationCity, departureTime, arrivalTime) {
                    submit(departureCity, destinationCity, departureTime, arrivalTime);
                  }
                );
              }
            },
          ),
          Expanded(
            child: flights.isEmpty
              ? const Center(child: Text('There are no available flights.'))
              : ListView.builder(
              itemCount: flights.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('${flights[index].departureCity} to ${flights[index].destinationCity}'),
                  subtitle: Text('Departure: ${flights[index].departureTime}\nArrival: ${flights[index].arrivalTime}'),
                  onTap: () {
                    setState(() {
                      addFlight = false;
                      selectedFlight = flights[index];
                    });
                    if (!isLandscape) {
                      Navigator.pushNamed(
                        context,
                        '/UpdateOrDeleteFlight',
                        arguments: {
                          'selectedFlight': selectedFlight,
                          'onUpdate': (departureCity, destinationCity, departureTime, arrivalTime) {
                            update(departureCity, destinationCity, departureTime, arrivalTime);
                          },
                          'onDelete': () {
                            delete();
                          }
                        },
                      );
                    }
                  }
                );
              }
            )
          )
        ],
      )
    );
  }
  Widget buildAddFlight() {
    return AddFlight(
      onSubmit: (departureCity, destinationCity, departureTime, arrivalTime) {
        submit(departureCity, destinationCity, departureTime, arrivalTime);
      },
    );
  }
  Widget buildUpdateOrDeleteFlight() {
    return UpdateOrDeleteFlight(
      selectedFlight: selectedFlight!,
      onUpdate: (departureCity, destinationCity, departureTime, arrivalTime) {
        update(departureCity, destinationCity, departureTime, arrivalTime);
      },
      onDelete: () {
        delete();
      },
    );
  }
}