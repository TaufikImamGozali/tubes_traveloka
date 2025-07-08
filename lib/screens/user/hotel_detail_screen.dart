import 'package:flutter/material.dart';
import '../../models/hotel.dart';
import '../../models/user.dart';
import 'booking_screen.dart';

class HotelDetailScreen extends StatelessWidget {
  final Hotel hotel;
  final User user;

  HotelDetailScreen({required this.hotel, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(hotel.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Lokasi: ${hotel.location}', style: TextStyle(fontSize: 18)),
            Text('Rating: ${hotel.rating} Bintang', style: TextStyle(fontSize: 18)),
            Text('Harga: Rp ${hotel.price} / malam', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingScreen(hotel: hotel, user: user),
                  ),
                );
              },
              child: Text('Booking Sekarang'),
            ),
          ],
        ),
      ),
    );
  }
}