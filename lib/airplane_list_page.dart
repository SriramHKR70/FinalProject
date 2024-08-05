import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

class AirplaneListPage extends StatefulWidget {
  @override
  _AirplaneListPageState createState() => _AirplaneListPageState();
}

class _AirplaneListPageState extends State<AirplaneListPage> {
  Database? database;
  List<Map<String, dynamic>> airplanes = [];
  final TextEditingController typeController = TextEditingController();
  final TextEditingController passengersController = TextEditingController();
  final TextEditingController maxSpeedController = TextEditingController();
  final TextEditingController rangeController = TextEditingController();
  final EncryptedSharedPreferences encryptedSharedPreferences = EncryptedSharedPreferences();

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    database = await openDatabase(
      join(await getDatabasesPath(), 'airplanes.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE airplanes(id INTEGER PRIMARY KEY, type TEXT, passengers INTEGER, maxSpeed INTEGER, range INTEGER)",
        );
      },
      version: 1,
    );
    _loadAirplanes();
  }

  Future<void> _loadAirplanes() async {
    final List<Map<String, dynamic>> maps = await database!.query('airplanes');
    setState(() {
      airplanes = maps;
    });
  }

  Future<void> _addAirplane(String type, int passengers, int maxSpeed, int range) async {
    await database!.insert(
      'airplanes',
      {'type': type, 'passengers': passengers, 'maxSpeed': maxSpeed, 'range': range},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    _loadAirplanes();
  }

  Future<void> _updateAirplane(int id, String type, int passengers, int maxSpeed, int range) async {
    await database!.update(
      'airplanes',
      {'type': type, 'passengers': passengers, 'maxSpeed': maxSpeed, 'range': range},
      where: 'id = ?',
      whereArgs: [id],
    );
    _loadAirplanes();
  }

  Future<void> _deleteAirplane(int id) async {
    await database!.delete(
      'airplanes',
      where: 'id = ?',
      whereArgs: [id],
    );
    _loadAirplanes();
  }

  void _showAddAirplaneDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Airplane'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: typeController, decoration: InputDecoration(hintText: 'Type')),
              TextField(controller: passengersController, decoration: InputDecoration(hintText: 'Passengers'), keyboardType: TextInputType.number),
              TextField(controller: maxSpeedController, decoration: InputDecoration(hintText: 'Max Speed'), keyboardType: TextInputType.number),
              TextField(controller: rangeController, decoration: InputDecoration(hintText: 'Range'), keyboardType: TextInputType.number),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _addAirplane(
                  typeController.text,
                  int.parse(passengersController.text),
                  int.parse(maxSpeedController.text),
                  int.parse(rangeController.text),
                );
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showUpdateAirplaneDialog(BuildContext context, int id, String type, int passengers, int maxSpeed, int range) {
    typeController.text = type;
    passengersController.text = passengers.toString();
    maxSpeedController.text = maxSpeed.toString();
    rangeController.text = range.toString();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Airplane'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: typeController, decoration: InputDecoration(hintText: 'Type')),
              TextField(controller: passengersController, decoration: InputDecoration(hintText: 'Passengers'), keyboardType: TextInputType.number),
              TextField(controller: maxSpeedController, decoration: InputDecoration(hintText: 'Max Speed'), keyboardType: TextInputType.number),
              TextField(controller: rangeController, decoration: InputDecoration(hintText: 'Range'), keyboardType: TextInputType.number),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _updateAirplane(
                  id,
                  typeController.text,
                  int.parse(passengersController.text),
                  int.parse(maxSpeedController.text),
                  int.parse(rangeController.text),
                );
                Navigator.of(context).pop();
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Airplane List'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: airplanes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(airplanes[index]['type']),
                  subtitle: Text('Passengers: ${airplanes[index]['passengers']}, Max Speed: ${airplanes[index]['maxSpeed']}, Range: ${airplanes[index]['range']}'),
                  onTap: () {
                    _showUpdateAirplaneDialog(
                      context,
                      airplanes[index]['id'],
                      airplanes[index]['type'],
                      airplanes[index]['passengers'],
                      airplanes[index]['maxSpeed'],
                      airplanes[index]['range'],
                    );
                  },
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _deleteAirplane(airplanes[index]['id']);
                    },
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _showAddAirplaneDialog(context);
            },
            child: Text('Add Airplane'),
          ),
        ],
      ),
    );
  }
}
