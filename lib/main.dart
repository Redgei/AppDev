import 'package:flutter/material.dart';
import 'loginPage/login.dart';
import 'loginPage/register.dart';
import 'RiderDashboard.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rider App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const Login(),
      routes: {
        '/login': (context) => const Login(),
        '/register': (context) => const register(),
        '/RiderDashboard': (context) => const RiderDashboard(),
      },
    );
  }
}
