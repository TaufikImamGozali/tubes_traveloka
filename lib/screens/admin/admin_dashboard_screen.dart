import 'package:flutter/material.dart';
import '../../models/hotel.dart';
import '../../services/database_helper.dart';
import 'add_edit_hotel_screen.dart';
import 'view_bookings_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  @override
  _AdminDashboardScreenState createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final dbHelper = DatabaseHelper();
  late Future<List<Hotel>> _hotels;

  @override
  void initState() {
    super.initState();
    _refreshHotels();
  }

  void _refreshHotels() {
    setState(() {
      _hotels = dbHelper.getHotels();
    });
  }

  void _deleteHotel(int id) async {
    await dbHelper.deleteHotel(id);
    _refreshHotels();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.book),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ViewBookingsScreen()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Hotel>>(
        future: _hotels,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final hotel = snapshot.data![index];
              return ListTile(
                title: Text(hotel.name),
                subtitle: Text(hotel.location),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddEditHotelScreen(hotel: hotel),
                          ),
                        );
                        _refreshHotels();
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteHotel(hotel.id!),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEditHotelScreen()),
          );
          _refreshHotels();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}