import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../models/booking.dart';
import '../../models/user.dart';
import '../../services/database_helper.dart';

class BookingHistoryScreen extends StatefulWidget {
  final User user;
  BookingHistoryScreen({required this.user});

  @override
  _BookingHistoryScreenState createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
  final dbHelper = DatabaseHelper();
  late Future<List<Booking>> _bookings;

  @override
  void initState() {
    super.initState();
    _bookings = dbHelper.getBookingsByUser(widget.user.id!);
  }

  Future<void> _createPdf(Booking booking) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Padding(
              padding: pw.EdgeInsets.all(32),
              child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Bukti Pemesanan Hotel', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                    pw.Divider(thickness: 2),
                    pw.SizedBox(height: 20),
                    pw.Text('Booking ID: #${booking.id.toString().padLeft(6, '0')}'),
                    pw.Text('Hotel ID: ${booking.hotelId}'),
                    pw.SizedBox(height: 16),
                    pw.Text('Tanggal Check-in: ${DateFormat('EEE, d MMM yyyy', 'id_ID').format(DateTime.parse(booking.checkinDate))}'),
                    pw.Text('Tanggal Check-out: ${DateFormat('EEE, d MMM yyyy', 'id_ID').format(DateTime.parse(booking.checkoutDate))}'),
                    pw.SizedBox(height: 16),
                    pw.Align(
                      alignment: pw.Alignment.centerRight,
                      child: pw.Text('Total Harga: Rp ${booking.totalPrice.toStringAsFixed(0)}', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Spacer(),
                    pw.Center(child: pw.Text('Terima kasih telah memesan!', style: pw.TextStyle(fontStyle: pw.FontStyle.italic))),
                  ]),
            );
          }),
    );
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Riwayat Booking')),
      body: FutureBuilder<List<Booking>>(
        future: _bookings,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history_toggle_off, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Anda belum memiliki riwayat booking.', style: TextStyle(fontSize: 18)),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: EdgeInsets.all(8),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final booking = snapshot.data![index];
              return Card(
                elevation: 2,
                margin: EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Icon(Icons.receipt_long, color: Colors.white),
                  ),
                  title: Text(
                    'Booking ID: ${booking.id}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                      'Hotel ID: ${booking.hotelId}\nCheck-in: ${booking.checkinDate}'),
                  trailing: TextButton.icon(
                    icon: Icon(Icons.print, size: 18),
                    label: Text('Cetak'),
                    onPressed: () => _createPdf(booking),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}