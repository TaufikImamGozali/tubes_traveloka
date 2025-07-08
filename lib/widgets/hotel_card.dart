import 'package:flutter/material.dart';
import '../models/hotel.dart';

class HotelCard extends StatelessWidget {
  final Hotel hotel;
  final VoidCallback onTap;

  const HotelCard({Key? key, required this.hotel, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                // Placeholder image, ganti dengan URL gambar hotel jika ada
                'https://picsum.photos/seed/${hotel.id}/400/200',
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hotel.name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_pin, color: Colors.grey[600], size: 16),
                      SizedBox(width: 4),
                      Text(hotel.location, style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      ...List.generate(5, (index) => Icon(
                        index < hotel.rating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 20,
                      )),
                      Spacer(),
                      Text(
                        'Rp ${hotel.price.toStringAsFixed(0)}',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}