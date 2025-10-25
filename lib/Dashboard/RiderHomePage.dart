import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rider_app/Dashboard/BookingsPage.dart';
import 'package:rider_app/Dashboard/HistoryPage.dart';

class RiderHomePage extends StatefulWidget {
  const RiderHomePage({Key? key}) : super(key: key);

  @override
  State<RiderHomePage> createState() => _RiderHomePageState();
}

class _RiderHomePageState extends State<RiderHomePage> {
  String? _username;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userData.exists) {
          setState(() {
            _username = userData.data()?['username'];
          });
        }
      }
    } catch (e) {
      // Handle error (e.g., display an error message)
      print("Error loading user data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load user data.")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _showLogoutConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Are you sure you want to logout?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
            TextButton(
              child: const Text('Logout'),
              onPressed: () async {
                Navigator.of(context).pop(); // Dismiss the dialog
                await FirebaseAuth.instance.signOut();
                if (!mounted) return;
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue[100], // Light blue color for AppBar
      ),
      body: Stack(
        children: [
          // Light blue background that extends from top
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color.fromARGB(255, 83, 48, 224), const Color.fromARGB(255, 50, 156, 243)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Welcome Section with blue outline
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white, // White background for welcome section
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.blue, // Blue outline
                            width: 2.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.blue,
                                  width: 2.0,
                                ),
                              ),
                              child: const Icon(
                                Icons.person,
                                size: 48,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _username != null ? 'Welcome, $_username!' : 'Welcome!',
                              style: const TextStyle(
                                fontSize: 26,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Ready to ride?',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.blue[700],
                                fontFamily: 'Roboto',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30), // Spacing after welcome section

                      // Option Buttons
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            _buildOptionButton(
                              icon: Icons.book,
                              title: 'Bookings',
                              color: Colors.white,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const BookingsPage()),
                                );
                              },
                            ),
                            const SizedBox(height: 17), // Gap between buttons
                            _buildOptionButton(
                              icon: Icons.history,
                              title: 'History of Rides',
                              color: Colors.white,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const HistoryPage()),
                                );
                              },
                            ),
                            const SizedBox(height: 17),
                            _buildOptionButton(
                              icon: Icons.logout,
                              title: 'Logout',
                              color: Colors.white,
                              onTap: () {
                                _showLogoutConfirmationDialog(context); // Show confirmation dialog
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildOptionButton({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.blue, // Blue outline
          width: 2.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: title == 'Bookings'
              ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BookingsPage()),
                  );
                }
              : title == 'History of Rides'
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HistoryPage()),
                      );
                    }
                  : title == 'Logout'
                      ? () {
                          _showLogoutConfirmationDialog(context);
                        }
                      : onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.blue,
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    icon,
                    size: 24,
                    color: Colors.blue[700],
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue[800],
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.blue,
                      width: 1.5,
                    ),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.blue,
                    size: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}