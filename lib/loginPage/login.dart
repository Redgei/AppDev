import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rider_app/Dashboard/RiderHomePage.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginPageState();
}

class _LoginPageState extends State<Login> with SingleTickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  String _errorMessage = '';
  late AnimationController _controller;
  late Animation<double> _fadeIn;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void loginUser() async {
    setState(() {
      _errorMessage = '';
    });

    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = "Please enter email and password";
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login Successful!")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const RiderHomePage()),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Login failed";
      if (e.code == 'user-not-found') {
        errorMessage = "No user found with this email";
      } else if (e.code == 'wrong-password') {
        errorMessage = "Incorrect password";
      } else if (e.code == 'invalid-email') {
        errorMessage = "Invalid email address";
      } else if (e.code == 'user-disabled') {
        errorMessage = "This account has been disabled";
      } else if (e.code == 'too-many-requests') {
        errorMessage = "Too many attempts. Try again later";
      }

      setState(() {
        _errorMessage = errorMessage;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "An error occurred. Please try again.";
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  InputDecoration _inputStyle(String label, IconData icon) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white.withOpacity(0.9),
      prefixIcon: Icon(icon, color: Colors.blueGrey),
      labelText: label,
      labelStyle: const TextStyle(color: Colors.blueGrey),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.blue, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade300, Colors.indigo.shade700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: FadeTransition(
              opacity: _fadeIn,
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: Colors.white.withOpacity(0.9),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      // 🔹 Logo
                      Hero(
                        tag: "rider_logo",
                        child: Image.asset(
                          "assets/GoRide.png",
                          height: 160,
                        ),
                      ),
                      const SizedBox(height: 20),

                      const Text(
                        "Welcome Back, Rider!",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey,
                        ),
                      ),
                      const SizedBox(height: 25),

                      // 🔹 Error Message
                      if (_errorMessage.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            _errorMessage,
                            style: const TextStyle(color: Colors.red, fontSize: 14),
                          ),
                        ),

                      // 🔹 Email Field
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: _inputStyle("Email", Icons.email),
                      ),
                      const SizedBox(height: 16),

                      // 🔹 Password Field
                      TextField(
                        controller: passwordController,
                        obscureText: _obscurePassword,
                        decoration: _inputStyle("Password", Icons.lock).copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off : Icons.visibility,
                              color: Colors.blueGrey,
                            ),
                            onPressed: () {
                              setState(() => _obscurePassword = !_obscurePassword);
                            },
                          ),
                        ),
                      ),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // Add forgot password functionality here
                          },
                          child: Text(
                            "Forgot password?",
                            style: TextStyle(color: Colors.blueGrey.shade700),
                          ),
                        ),
                      ),

                      // 🔹 Login Button
                      _isLoading
                          ? const CircularProgressIndicator()
                          : SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: loginUser,
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                ),
                                child: Ink(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.blue.shade600,
                                        Colors.indigo.shade700,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Container(
                                    alignment: Alignment.center,
                                    constraints: const BoxConstraints(minHeight: 50),
                                    child: const Text(
                                      "Login",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                      // 🔹 Register link
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: Text(
                          "Don’t have an account? Register",
                          style: TextStyle(color: Colors.blueGrey.shade700),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
