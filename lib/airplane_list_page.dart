import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'airplane_form_page.dart';

class AirplaneListPage extends StatefulWidget {
  @override
  _AirplaneListPageState createState() => _AirplaneListPageState();
}

class _AirplaneListPageState extends State<AirplaneListPage> {
  final dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> airplanesList = [];

  @override
  void initState() {
    super.initState();
    _fetchAirplanes();
  }

  void _fetchAirplanes() async {
    final allRows = await dbHelper.queryAllAirplanes();
    setState(() {
      airplanesList = allRows;
    });
  }

  void _addAirplane() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AirplaneFormPage()),
    ).then((value) {
      if (value != null) {
        _fetchAirplanes();
      }
    });
  }

  void _updateAirplane(Map<String, dynamic> airplane) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AirplaneFormPage(airplane: airplane)),
    ).then((value) {
      if (value != null) {
        _fetchAirplanes();
      }
    });
  }

  void _deleteAirplane(int id) async {
    await dbHelper.deleteAirplane(id);
    _fetchAirplanes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Airplanes List'),
      ),
      body: ListView.builder(
        itemCount: airplanesList.length,
        itemBuilder: (context, index) {
          final airplane = airplanesList[index];
          return ListTile(
            title: Text(airplane['type']),
            subtitle: Text('Passengers: ${airplane['passengers']}, Max Speed: ${airplane['maxSpeed']}, Range: ${airplane['range']}'),
            onTap: () => _updateAirplane(airplane),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _deleteAirplane(airplane['id']),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addAirplane,
        tooltip: 'Add Airplane',
        child: Icon(Icons.add),
      ),
    );
  }
}
