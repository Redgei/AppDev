import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rider_app/model/Booking.dart';

class BookingsPage extends StatefulWidget {
  const BookingsPage({Key? key}) : super(key: key);

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {
  List<Booking> bookings = [];
  bool isLoading = true;
  String? driverVehicleType;

  @override
  void initState() {
    super.initState();
    _loadDriverDataAndBookings();
  }

  Future<void> _loadDriverDataAndBookings() async {
    setState(() {
      isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Get driver's vehicle type
        final driverDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        
        driverVehicleType = driverDoc.data()?['vehicleType'];

        // Load bookings for this vehicle type
        _loadBookings();
      }
    } catch (e) {
      print("Error loading driver data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadBookings() async {
    try {
      final bookingsSnapshot = await FirebaseFirestore.instance
          .collection('bookings')
          .where('vehicleType', isEqualTo: driverVehicleType)
          .where('status', isEqualTo: 'pending')
          .orderBy('createdAt', descending: true)
          .get();

      setState(() {
        bookings = bookingsSnapshot.docs.map((doc) {
          final data = doc.data();
          return Booking(
            id: doc.id,
            user: data['userName'] ?? data['userEmail'] ?? 'Unknown User',
            details: 'From: ${data['pickupLocation']} → To: ${data['dropoffLocation']}',
            pickupLocation: data['pickupLocation'] ?? '',
            dropoffLocation: data['dropoffLocation'] ?? '',
            bookingTime: data['bookingTime'] ?? '',
            fare: data['fare']?.toDouble() ?? 0.0,
            status: data['status'] ?? 'pending',
          );
        }).toList();
        isLoading = false;
      });
    } catch (e) {
      print("Error loading bookings: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _acceptBooking(String bookingId) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(bookingId)
          .update({
            'status': 'accepted',
            'driverId': user!.uid,
            'driverName': _getCurrentUserName(),
            'acceptedAt': FieldValue.serverTimestamp(),
          });

      // Reload bookings to remove accepted one
      _loadBookings();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Booking accepted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error accepting booking: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _getCurrentUserName() {
    // You might want to store driver's name in Firestore during registration
    return FirebaseAuth.instance.currentUser?.displayName ?? 'Driver';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Bookings'),
        backgroundColor: Colors.blue[800],
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : bookings.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.bookmark_border, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No Available Bookings',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'New bookings will appear here',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    final booking = bookings[index];
                    return Card(
                      margin: const EdgeInsets.all(12.0),
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
                                  'Booking #${booking.id.substring(0, 8)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.orange[50],
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.orange),
                                  ),
                                  child: const Text(
                                    'PENDING',
                                    style: TextStyle(
                                      color: Colors.orange,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Icon(Icons.person, size: 16, color: Colors.grey),
                                const SizedBox(width: 8),
                                Text(
                                  booking.user,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.location_on, size: 16, color: Colors.green),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    booking.pickupLocation,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.flag, size: 16, color: Colors.red),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    booking.dropoffLocation,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                                const SizedBox(width: 8),
                                Text(
                                  booking.bookingTime,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () => _acceptBooking(booking.id),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                child: const Text(
                                  'Accept Booking',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
