import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart'; // hypothetical

class CustomerListPage extends StatefulWidget {
  @override
  _CustomerListPageState createState() => _CustomerListPageState();
}

class _CustomerListPageState extends State<CustomerListPage> {
  Database? database;
  List<Map<String, dynamic>> customers = [];
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();
  final EncryptedSharedPreferences encryptedSharedPreferences = EncryptedSharedPreferences();

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    database = await openDatabase(
      join(await getDatabasesPath(), 'customers.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE customers(id INTEGER PRIMARY KEY, firstName TEXT, lastName TEXT, address TEXT, birthday TEXT)",
        );
      },
      version: 1,
    );
    _loadCustomers();
  }

  Future<void> _loadCustomers() async {
    final List<Map<String, dynamic>> maps = await database!.query('customers');
    setState(() {
      customers = maps;
    });
  }

  Future<void> _addCustomer(String firstName, String lastName, String address, String birthday) async {
    await database!.insert(
      'customers',
      {'firstName': firstName, 'lastName': lastName, 'address': address, 'birthday': birthday},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    _loadCustomers();
  }

  Future<void> _updateCustomer(int id, String firstName, String lastName, String address, String birthday) async {
    await database!.update(
      'customers',
      {'firstName': firstName, 'lastName': lastName, 'address': address, 'birthday': birthday},
      where: 'id = ?',
      whereArgs: [id],
    );
    _loadCustomers();
  }

  Future<void> _deleteCustomer(int id) async {
    await database!.delete(
      'customers',
      where: 'id = ?',
      whereArgs: [id],
    );
    _loadCustomers();
  }

  void _showAddCustomerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Customer'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: firstNameController, decoration: InputDecoration(hintText: 'First Name')),
              TextField(controller: lastNameController, decoration: InputDecoration(hintText: 'Last Name')),
              TextField(controller: addressController, decoration: InputDecoration(hintText: 'Address')),
              TextField(controller: birthdayController, decoration: InputDecoration(hintText: 'Birthday')),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _addCustomer(firstNameController.text, lastNameController.text, addressController.text, birthdayController.text);
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showUpdateCustomerDialog(BuildContext context, int id, String firstName, String lastName, String address, String birthday) {
    firstNameController.text = firstName;
    lastNameController.text = lastName;
    addressController.text = address;
    birthdayController.text = birthday;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Customer'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: firstNameController, decoration: InputDecoration(hintText: 'First Name')),
              TextField(controller: lastNameController, decoration: InputDecoration(hintText: 'Last Name')),
              TextField(controller: addressController, decoration: InputDecoration(hintText: 'Address')),
              TextField(controller: birthdayController, decoration: InputDecoration(hintText: 'Birthday')),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _updateCustomer(id, firstNameController.text, lastNameController.text, addressController.text, birthdayController.text);
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
        title: Text('Customer List'),
        actions: [
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Instructions'),
                    content: Text('Instructions on how to use the interface.'),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: customers.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(customers[index]['firstName']),
                  subtitle: Text(customers[index]['lastName']),
                  onTap: () {
                    _showUpdateCustomerDialog(
                      context,
                      customers[index]['id'],
                      customers[index]['firstName'],
                      customers[index]['lastName'],
                      customers[index]['address'],
                      customers[index]['birthday'],
                    );
                  },
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _showAddCustomerDialog(context);
            },
            child: Text('Add Customer'),
          ),
        ],
      ),
    );
  }
}
