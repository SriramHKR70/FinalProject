import 'package:sqflite/sqflite.dart';
import 'database_helper.dart';
import '../models/customer.dart';

class CustomerDao {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<List<Customer>> getCustomers() async {
    final Database db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('customers');
    return List.generate(maps.length, (i) {
      return Customer(
        id: maps[i]['id'],
        firstName: maps[i]['firstName'],
        lastName: maps[i]['lastName'],
        address: maps[i]['address'],
        birthday: maps[i]['birthday'],
      );
    });
  }

  Future<void> insertCustomer(Customer customer) async {
    final Database db = await _databaseHelper.database;
    await db.insert(
      'customers',
      customer.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
