import 'package:flutter/material.dart';
import 'package:rider_app/model/Booking.dart';

class BookingsPage extends StatelessWidget {
  const BookingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Mock booking data (replace with actual data fetching)
    final List<Booking> bookings = [
      Booking(id: '1', user: 'User A', details: 'Pickup at location X'),
      Booking(id: '2', user: 'User B', details: 'Drop off at location Y'),
      Booking(id: '3', user: 'User C', details: 'Multiple stops'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookings'),
      ),
      body: ListView.builder(
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Booking ID: ${booking.id}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text('User: ${booking.user}'),
                  Text('Details: ${booking.details}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
