import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rider_app/Dashboard/RiderHomePage.dart';
import 'loginPage/login.dart';
import 'loginPage/register.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rider App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
      ),
      home: const Login(),
      routes: {
        '/login': (context) => const Login(),
        '/register': (context) => const Register(),
        '/RiderHomePage': (context) => const RiderHomePage(),
      },
    );
  }
}