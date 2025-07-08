import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/booking.dart';
import '../../models/hotel.dart';
import '../../models/user.dart';
import '../../services/database_helper.dart';
import 'payment_screen.dart';

class BookingScreen extends StatefulWidget {
  final Hotel hotel;
  final User user;

  BookingScreen({required this.hotel, required this.user});

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime? _checkinDate;
  DateTime? _checkoutDate;
  final dbHelper = DatabaseHelper();
  double _totalPrice = 0.0;

  void _calculateTotalPrice() {
    if (_checkinDate != null && _checkoutDate != null) {
      final difference = _checkoutDate!.difference(_checkinDate!).inDays;
      setState(() {
        _totalPrice = difference * widget.hotel.price;
      });
    }
  }

  void _bookHotel() async {
    if (_checkinDate != null && _checkoutDate != null) {
      final booking = Booking(
        userId: widget.user.id!,
        hotelId: widget.hotel.id!,
        checkinDate: DateFormat('yyyy-MM-dd').format(_checkinDate!),
        checkoutDate: DateFormat('yyyy-MM-dd').format(_checkoutDate!),
        totalPrice: _totalPrice,
      );
      await dbHelper.insertBooking(booking);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PaymentScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Silakan pilih tanggal check-in dan check-out')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Booking Hotel')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: Text(_checkinDate == null
                  ? 'Pilih Tanggal Check-in'
                  : 'Check-in: ${DateFormat('EEE, d MMM yyyy', 'id_ID').format(_checkinDate!)}'),
              trailing: Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2101),
                );
                if (date != null) {
                  setState(() {
                    _checkinDate = date;
                    _calculateTotalPrice();
                  });
                }
              },
            ),
            ListTile(
              title: Text(_checkoutDate == null
                  ? 'Pilih Tanggal Check-out'
                  : 'Check-out: ${DateFormat('EEE, d MMM yyyy', 'id_ID').format(_checkoutDate!)}'),
              trailing: Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _checkinDate ?? DateTime.now(),
                  firstDate: _checkinDate ?? DateTime.now(),
                  lastDate: DateTime(2101),
                );
                if (date != null) {
                  setState(() {
                    _checkoutDate = date;
                    _calculateTotalPrice();
                  });
                }
              },
            ),
            SizedBox(height: 20),
            Text('Total Harga: Rp $_totalPrice', style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _bookHotel,
              child: Text('Lanjut ke Pembayaran'),
            ),
          ],
        ),
      ),
    );
  }
}