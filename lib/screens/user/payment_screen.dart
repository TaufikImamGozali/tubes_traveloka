import 'package:flutter/material.dart';
import '../auth/login_screen.dart'; // Redirect ke login setelah 'pembayaran'

class PaymentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pembayaran')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, size: 100, color: Colors.green),
            SizedBox(height: 20),
            Text('Pembayaran Berhasil!', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginScreen()), // Kembali ke login
                  (Route<dynamic> route) => false,
                );
              },
              child: Text('Kembali ke Halaman Awal'),
            ),
          ],
        ),
      ),
    );
  }
}