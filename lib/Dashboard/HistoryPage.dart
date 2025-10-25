import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rider_app/model/Booking.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Future<List<Booking>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _historyFuture = _fetchRideHistory();
  }

  Future<List<Booking>> _fetchRideHistory() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Not logged in, return empty list
      return [];
    }

    final historySnapshot = await FirebaseFirestore.instance
        .collection('bookings')
        .where('driverId', isEqualTo: user.uid)
        .where('status', whereIn: ['accepted', 'completed']) // Fetch accepted or completed rides
        .orderBy('acceptedAt', descending: true)
        .get();

    return historySnapshot.docs.map((doc) {
      final data = doc.data();
      String formattedBookingTime = 'N/A';
      if (data['acceptedAt'] is Timestamp) {
        final timestamp = data['acceptedAt'] as Timestamp;
        formattedBookingTime =
            DateFormat('MMM d, yyyy - hh:mm a').format(timestamp.toDate());
      }

      return Booking(
        id: doc.id,
        user: data['userName'] ?? 'Unknown User',
        details: 'From: ${data['pickupLocation']} → To: ${data['dropoffLocation']}',
        pickupLocation: data['pickupLocation'] ?? '',
        dropoffLocation: data['dropoffLocation'] ?? '',
        bookingTime: formattedBookingTime,
        fare: data['fare']?.toDouble() ?? 0.0,
        status: data['status'] ?? 'unknown',
      );
    }).toList();
  }

  Future<void> _refreshHistory() async {
    // This will re-run the FutureBuilder
    setState(() {
      _historyFuture = _fetchRideHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History of Rides'),
        backgroundColor: Colors.blue[800],
      ),
      body: FutureBuilder<List<Booking>>(
        future: _historyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history_toggle_off, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No Ride History',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Your completed rides will appear here.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          final rides = snapshot.data!;

          return RefreshIndicator(
            onRefresh: _refreshHistory,
            child: ListView.builder(
              itemCount: rides.length,
              itemBuilder: (context, index) {
                final ride = rides[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Ride on ${ride.bookingTime.split(' - ')[0]}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(
                              '₱${ride.fare.toStringAsFixed(2)}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.green),
                            ),
                          ],
                        ),
                        const Divider(height: 20),
                        Text('From: ${ride.pickupLocation}'),
                        const SizedBox(height: 4),
                        Text('To: ${ride.dropoffLocation}'),
                        const SizedBox(height: 8),
                        Text('Passenger: ${ride.user}'),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
