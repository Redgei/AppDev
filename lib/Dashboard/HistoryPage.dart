import 'package:flutter/material.dart';
import '../model/Ride.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Mock history data (replace with actual data fetching)
    final List<Ride> rides = [
      Ride(id: '1', date: '2024-01-15', from: 'Location A', to: 'Location B'),
      Ride(id: '2', date: '2024-02-20', from: 'Location C', to: 'Location D'),
      Ride(id: '3', date: '2024-03-10', from: 'Location E', to: 'Location F'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('History of Rides'),
      ),
      body: ListView.builder(
        itemCount: rides.length,
        itemBuilder: (context, index) {
          final ride = rides[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ride ID: ${ride.id}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text('Date: ${ride.date}'),
                  Text('From: ${ride.from}'),
                  Text('To: ${ride.to}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
