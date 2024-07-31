import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'customer_form_page.dart';

class CustomerListPage extends StatefulWidget {
  @override
  _CustomerListPageState createState() => _CustomerListPageState();
}

class _CustomerListPageState extends State<CustomerListPage> {
  final dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> customersList = [];

  @override
  void initState() {
    super.initState();
    _fetchCustomers();
  }

  void _fetchCustomers() async {
    final allRows = await dbHelper.queryAllCustomers();
    setState(() {
      customersList = allRows;
    });
  }

  void _addCustomer() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CustomerFormPage()),
    ).then((value) {
      if (value != null) {
        _fetchCustomers();
      }
    });
  }

  void _updateCustomer(Map<String, dynamic> customer) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CustomerFormPage(customer: customer)),
    ).then((value) {
      if (value != null) {
        _fetchCustomers();
      }
    });
  }

  void _deleteCustomer(int id) async {
    await dbHelper.deleteCustomer(id);
    _fetchCustomers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customers List'),
      ),
      body: ListView.builder(
        itemCount: customersList.length,
        itemBuilder: (context, index) {
          final customer = customersList[index];
          return ListTile(
            title: Text('${customer['firstName']} ${customer['lastName']}'),
            subtitle: Text('${customer['address']}'),
            onTap: () => _updateCustomer(customer),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _deleteCustomer(customer['id']),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addCustomer,
        tooltip: 'Add Customer',
        child: Icon(Icons.add),
      ),
    );
  }
}
