import 'package:flutter/material.dart';
import '../../services/database_helper.dart';

class ViewBookingsScreen extends StatefulWidget {
  @override
  _ViewBookingsScreenState createState() => _ViewBookingsScreenState();
}

class _ViewBookingsScreenState extends State<ViewBookingsScreen> {
  final dbHelper = DatabaseHelper();
  late Future<List<Map<String, dynamic>>> _bookings;

  @override
  void initState() {
    super.initState();
    _bookings = dbHelper.getAllBookings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Bookings'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _bookings,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final booking = snapshot.data![index];
              return Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text('Hotel: ${booking['hotel_name']}'),
                  subtitle: Text(
                      'User: ${booking['username']}\nCheck-in: ${booking['checkin_date']}\nCheck-out: ${booking['checkout_date']}'),
                  trailing: Text('Rp ${booking['total_price']}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}