// import 'package:flutter/material.dart';
// import 'dart:convert'; // Required for json encoding/decoding
// import 'package:http/http.dart' as http; // The http package
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';

// class Register extends StatefulWidget {
//   const Register({Key? key}) : super(key: key);

//   @override
//   State<Register> createState() => _RegisterPageState();
// }

// enum DriverRole { car, motorcycle }

// class _RegisterPageState extends State<Register> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController usernameController = TextEditingController();
//   DriverRole? _selectedRole;
  
//   // We are replacing Firebase with our own backend, so these are no longer needed.
//   // final FirebaseAuth _auth = FirebaseAuth.instance;
//   // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
//   bool _isLoading = false;
//   String _errorMessage = '';

//   void registerUser() async {
//     setState(() {
//       _errorMessage = '';
//     });

//     // We'll use the username as 'name' for the PHP script
//     String name = usernameController.text.trim();
//     String email = emailController.text.trim();
//     String password = passwordController.text.trim();
//     String vehicleType = _selectedRole.toString().split('.').last;

//     if (email.isEmpty || password.isEmpty || name.isEmpty || _selectedRole == null) {
//       setState(() {
//         _errorMessage = "Please fill all fields and select a driver role";
//       });
    
//       return;
//     }

//     // Validate password strength
//     if (password.length < 6) {
//       setState(() {
//         _errorMessage = "Password must be at least 6 characters";
//       });
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       // IMPORTANT: Replace with the actual URL where your PHP script is hosted.
//       // '10.0.2.2' is a special IP for the Android emulator to access the host machine's localhost.
//       // For a real device, you'd need the host machine's network IP.
//       // For production, this would be your domain name (e.g., 'https://api.yourdomain.com/register.php').
//       final url = Uri.parse('http://10.0.2.2/goride/register.php');

//       final response = await http.post(
//         url,
//         headers: {
//           'Content-Type': 'application/json; charset=UTF-8',
//         },
//         body: json.encode({
//           'name': name,
//           'phone': '09123456789', // You'll need to add a phone field to your form
//           'email': email,
//           'password': password,
//           // You can send extra data too, your PHP script would need to handle it.
//           'vehicleType': vehicleType,
//         }),
//       );

//       if (!mounted) return;

//       if (response.statusCode == 200) {
//         final responseData = json.decode(response.body);
//         if (responseData['success'] == true) {
//           // Registration was successful
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text("Registration Successful! You are registered as a $vehicleType rider."),
//               backgroundColor: Colors.green,
//             ),
//           );
//           Navigator.pushReplacementNamed(context, '/login');
//         } else {
//           // The server returned an error (e.g., "email already exists")
//           setState(() {
//             _errorMessage = responseData['error'] ?? 'An unknown error occurred.';
//           });
//         }
//       } else {
//         // The server returned a non-200 status code (e.g., 404 Not Found, 500 Internal Server Error)
//         setState(() {
//           _errorMessage = 'Server error: ${response.statusCode}';
//         });
//       }
//     } catch (e) {
//       // This catches network errors (e.g., no internet connection, server not reachable)
//       if (mounted) {
//         setState(() {
//           _errorMessage = "Could not connect to the server. Please check your internet connection.";
//         });
//       }
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.blue.shade300, Colors.purple.shade400],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: Center(
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   const SizedBox(height: 40),
//                   Image.asset(
//                     "assets/SigninRider.png",
//                     height: 150,
//                   ),
//                   const Text(
//                     "Create Account",
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                   const SizedBox(height: 30),
                  
//                   // Error Message
//                   if (_errorMessage.isNotEmpty)
//                     Container(
//                       padding: const EdgeInsets.all(10),
//                       margin: const EdgeInsets.only(bottom: 15),
//                       decoration: BoxDecoration(
//                         color: Colors.redAccent,
//                         borderRadius: BorderRadius.circular(5),
//                       ),
//                       child: Row(
//                         children: [
//                           const Icon(Icons.error, color: Colors.white),
//                           const SizedBox(width: 5),
//                           Expanded(
//                             child: Text(
//                               _errorMessage,
//                               style: const TextStyle(color: Colors.white),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
                  
//                   // Username Field
//                   TextFormField(
//                     controller: usernameController,
//                     decoration: InputDecoration(
//                       labelText: 'Username',
//                       labelStyle: const TextStyle(color: Colors.white),
//                       prefixIcon: const Icon(Icons.person, color: Colors.white),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: const BorderSide(color: Colors.white),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: const BorderSide(color: Colors.white),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: const BorderSide(color: Colors.white),
//                       ),
//                       filled: true,
//                       fillColor: Colors.white.withOpacity(0.2),
//                     ),
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                   const SizedBox(height: 15),
                  
//                   // Email Field
//                   TextFormField(
//                     controller: emailController,
//                     decoration: InputDecoration(
//                       labelText: 'Email',
//                       labelStyle: const TextStyle(color: Colors.white),
//                       prefixIcon: const Icon(Icons.email, color: Colors.white),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: const BorderSide(color: Colors.white),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: const BorderSide(color: Colors.white),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: const BorderSide(color: Colors.white),
//                       ),
//                       filled: true,
//                       fillColor: Colors.white.withOpacity(0.2),
//                     ),
//                     style: const TextStyle(color: Colors.white),
//                     keyboardType: TextInputType.emailAddress,
//                   ),
//                   const SizedBox(height: 15),
                  
//                   // Password Field
//                   TextFormField(
//                     controller: passwordController,
//                     obscureText: true,
//                     decoration: InputDecoration(
//                       labelText: 'Password',
//                       labelStyle: const TextStyle(color: Colors.white),
//                       prefixIcon: const Icon(Icons.lock, color: Colors.white),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: const BorderSide(color: Colors.white),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: const BorderSide(color: Colors.white),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: const BorderSide(color: Colors.white),
//                       ),
//                       filled: true,
//                       fillColor: Colors.white.withOpacity(0.2),
//                     ),
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                   const SizedBox(height: 20),
                  
//                   // Vehicle Type Selection
//                   const Text(
//                     "Select Your Vehicle Type:",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 10),
                  
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       // Car Option
//                       Container(
//                         margin: const EdgeInsets.symmetric(horizontal: 10),
//                         child: Column(
//                           children: [
//                             Container(
//                               width: 100,
//                               height: 100,
//                               decoration: BoxDecoration(
//                                 color: _selectedRole == DriverRole.car 
//                                     ? Colors.green 
//                                     : Colors.white.withOpacity(0.3),
//                                 borderRadius: BorderRadius.circular(10),
//                                 border: Border.all(
//                                   color: _selectedRole == DriverRole.car 
//                                       ? Colors.green 
//                                       : Colors.white,
//                                   width: 2,
//                                 ),
//                               ),
//                               child: IconButton(
//                                 icon: const Icon(Icons.directions_car, size: 40),
//                                 color: _selectedRole == DriverRole.car 
//                                     ? Colors.white 
//                                     : Colors.white,
//                                 onPressed: () {
//                                   setState(() {
//                                     _selectedRole = DriverRole.car;
//                                   });
//                                 },
//                               ),
//                             ),
//                             const SizedBox(height: 5),
//                             const Text(
//                               'Car',
//                               style: TextStyle(color: Colors.white),
//                             ),
//                           ],
//                         ),
//                       ),
                      
//                       // Motorcycle Option
//                       Container(
//                         margin: const EdgeInsets.symmetric(horizontal: 10),
//                         child: Column(
//                           children: [
//                             Container(
//                               width: 100,
//                               height: 100,
//                               decoration: BoxDecoration(
//                                 color: _selectedRole == DriverRole.motorcycle 
//                                     ? Colors.green 
//                                     : Colors.white.withOpacity(0.3),
//                                 borderRadius: BorderRadius.circular(10),
//                                 border: Border.all(
//                                   color: _selectedRole == DriverRole.motorcycle 
//                                       ? Colors.green 
//                                       : Colors.white,
//                                   width: 2,
//                                 ),
//                               ),
//                               child: IconButton(
//                                 icon: const Icon(Icons.motorcycle, size: 40),
//                                 color: _selectedRole == DriverRole.motorcycle 
//                                     ? Colors.white 
//                                     : Colors.white,
//                                 onPressed: () {
//                                   setState(() {
//                                     _selectedRole = DriverRole.motorcycle;
//                                   });
//                                 },
//                               ),
//                             ),
//                             const SizedBox(height: 5),
//                             const Text(
//                               'Motorcycle',
//                               style: TextStyle(color: Colors.white),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
                  
//                   const SizedBox(height: 30),
                  
//                   // Register Button
//                   SizedBox(
//                     width: double.infinity,
//                     height: 50,
//                     child: ElevatedButton(
//                       onPressed: _isLoading ? null : registerUser,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.orange,
//                         foregroundColor: Colors.white,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       child: _isLoading
//                           ? const SizedBox(
//                               width: 20,
//                               height: 20,
//                               child: CircularProgressIndicator(
//                                 valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                               ),
//                             )
//                           : const Text(
//                               'Register',
//                               style: TextStyle(fontSize: 16),
//                             ),
//                     ),
//                   ),
                  
//                   const SizedBox(height: 20),
                  
//                   // Login Link
//                   TextButton(
//                     onPressed: () {
//                       Navigator.pushReplacementNamed(context, '/login');
//                     },
//                     child: const Text(
//                       "Already have an account? Login",
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     emailController.dispose();
//     passwordController.dispose();
//     usernameController.dispose();
//     super.dispose();
//   }
// }
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterPageState();
}

enum DriverRole { car, motorcycle }

class _RegisterPageState extends State<Register>
    with SingleTickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  DriverRole? _selectedRole;

  bool _isLoading = false;
  String _errorMessage = '';
  bool _obscurePassword = true;

  late AnimationController _controller;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  Future<void> registerUser() async {
    setState(() => _errorMessage = '');
    String name = usernameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String vehicleType = _selectedRole.toString().split('.').last;

    if (email.isEmpty || password.isEmpty || name.isEmpty || _selectedRole == null) {
      setState(() => _errorMessage = "⚠️ Please fill all fields and select a vehicle type");
      return;
    }

    if (password.length < 6) {
      setState(() => _errorMessage = "⚠️ Password must be at least 6 characters");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final url = Uri.parse('http://10.0.2.2/goride/signup.php');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode({
          'name': name,
          'phone': '09123456789',
          'email': email,
          'password': password,
          'vehicleType': vehicleType,
        }),
      );

      if (!mounted) return;

      final data = json.decode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("✅ Registered as $vehicleType rider!")),
        );
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        setState(() => _errorMessage = data['error'] ?? 'An unknown error occurred.');
      }
    } catch (e) {
      setState(() =>
          _errorMessage = "❌ Could not connect to the server. Please check your connection.");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
                color: Colors.white.withOpacity(0.95),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/GoRide.png",
                        height: 130,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Create Rider Account",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Error message
                      if (_errorMessage.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            _errorMessage,
                            style: const TextStyle(color: Colors.red, fontSize: 14),
                          ),
                        ),

                      // Username
                      TextField(
                        controller: usernameController,
                        decoration: _inputStyle("Full Name", Icons.person),
                      ),
                      const SizedBox(height: 14),

                      // Email
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: _inputStyle("Email", Icons.email),
                      ),
                      const SizedBox(height: 14),

                      // Password
                      TextField(
                        controller: passwordController,
                        obscureText: _obscurePassword,
                        decoration: _inputStyle("Password", Icons.lock).copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.blueGrey,
                            ),
                            onPressed: () {
                              setState(() => _obscurePassword = !_obscurePassword);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Vehicle Type
                      const Text(
                        "Select Vehicle Type:",
                        style: TextStyle(
                            color: Colors.indigo,
                            fontWeight: FontWeight.w600,
                            fontSize: 16),
                      ),
                      const SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _vehicleTile(
                            icon: Icons.directions_car,
                            label: 'Car',
                            selected: _selectedRole == DriverRole.car,
                            onTap: () =>
                                setState(() => _selectedRole = DriverRole.car),
                          ),
                          const SizedBox(width: 20),
                          _vehicleTile(
                            icon: Icons.motorcycle,
                            label: 'Motorcycle',
                            selected: _selectedRole == DriverRole.motorcycle,
                            onTap: () =>
                                setState(() => _selectedRole = DriverRole.motorcycle),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Register button
                      _isLoading
                          ? const CircularProgressIndicator()
                          : SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: registerUser,
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: EdgeInsets.zero,
                                ),
                                child: Ink(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.blue.shade600,
                                        Colors.indigo.shade700
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: const Text(
                                      "Register",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      const SizedBox(height: 16),

                      // Login link
                      TextButton(
                        onPressed: () =>
                            Navigator.pushReplacementNamed(context, '/login'),
                        child: Text(
                          "Already have an account? Login",
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

  Widget _vehicleTile({
    required IconData icon,
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: selected ? Colors.indigo.shade600 : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? Colors.indigo : Colors.grey.shade400,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: selected ? Colors.white : Colors.blueGrey, size: 40),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : Colors.blueGrey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    _controller.dispose();
    super.dispose();
  }
}
