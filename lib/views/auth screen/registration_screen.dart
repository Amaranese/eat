// import 'package:eat_fit/controllers/auth_controller.dart';
// import 'package:flutter/material.dart';

// class RegistrationScreen extends StatefulWidget {
//   const RegistrationScreen({super.key});

//   @override
//   State<RegistrationScreen> createState() => _RegistrationScreenState();
// }

// class _RegistrationScreenState extends State<RegistrationScreen> {
//   final AuthController _authController =
//       AuthController(); // Create an instance of AuthController
//   final TextEditingController _firstNameController = TextEditingController();
//   final TextEditingController _lastNameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   bool _isPasswordVisible = false;
//   bool _isLoading = false;

//   // Function to handle registration

//   Future<void> _registerUser() async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       await _authController.registerUser(
//         firstName: _firstNameController.text.trim(),
//         lastName: _lastNameController.text.trim(),
//         email: _emailController.text.trim(),
//         password: _passwordController.text.trim(),
//       );

//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text("User Created Successfully! 🎉"),
//           content:
//               const Text("Your account has been created. You can now log in."),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context); // Close dialog
//                 Navigator.pop(context); // Navigate back to LoginScreen
//               },
//               child: const Text("Continue to Login"),
//             ),
//           ],
//         ),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(e.toString())),
//       );
//     } finally {
//       setState(() {
//         _isLoading = false; // Ensure loading state is reset
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _firstNameController.dispose();
//     _lastNameController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         elevation: 0,
//         title: const Text(
//           "Register",
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         centerTitle: true,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const Text(
//               "Create an account",
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//               ),
//             ),
//             const SizedBox(height: 30),
//             // First Name Field
//             TextField(
//               controller: _firstNameController,
//               decoration: InputDecoration(
//                 labelText: "First Name",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 prefixIcon: const Icon(Icons.person),
//               ),
//             ),
//             const SizedBox(height: 20),
//             // Last Name Field
//             TextField(
//               controller: _lastNameController,
//               decoration: InputDecoration(
//                 labelText: "Last Name",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 prefixIcon: const Icon(Icons.person_outline),
//               ),
//             ),
//             const SizedBox(height: 20),
//             // Email Field
//             TextField(
//               controller: _emailController,
//               keyboardType: TextInputType.emailAddress,
//               decoration: InputDecoration(
//                 labelText: "Email",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 prefixIcon: const Icon(Icons.email),
//               ),
//             ),
//             const SizedBox(height: 20),
//             // Password Field
//             TextField(
//               controller: _passwordController,
//               obscureText: !_isPasswordVisible,
//               decoration: InputDecoration(
//                 labelText: "Password",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 prefixIcon: const Icon(Icons.lock),
//                 suffixIcon: IconButton(
//                   icon: Icon(
//                     _isPasswordVisible
//                         ? Icons.visibility
//                         : Icons.visibility_off,
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       _isPasswordVisible = !_isPasswordVisible;
//                     });
//                   },
//                 ),
//               ),
//             ),
//             const SizedBox(height: 30),
//             // Register Button
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: _isLoading ? null : _registerUser,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF34C759),
//                   minimumSize: const Size(315, 60),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(99),
//                   ),
//                 ),
//                 child: _isLoading
//                     ? const CircularProgressIndicator(
//                         valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                       )
//                     : const Text(
//                         'Register',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 16,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:eat_fit/controllers/auth_controller.dart';
import 'package:eat_fit/views/auth%20screen/login_screen.dart';
import 'package:flutter/material.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final AuthController _authController =
      AuthController(); // Create an instance of AuthController
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  // Function to handle registration
  Future<void> _registerUser() async {
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields.")),
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match.")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _authController.registerUser(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("User Created Successfully! 🎉"),
          content:
              const Text("Your account has been created. You can now log in."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Navigate back to LoginScreen
              },
              child: const Text("Continue to Login"),
            ),
          ],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() {
        _isLoading = false; // Ensure loading state is reset
      });
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Register",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Create an account",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 30),
            // First Name Field
            TextField(
              controller: _firstNameController,
              decoration: InputDecoration(
                labelText: "First Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 20),
            // Last Name Field
            TextField(
              controller: _lastNameController,
              decoration: InputDecoration(
                labelText: "Last Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 20),
            // Email Field
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 20),
            // Password Field
            TextField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Confirm Password Field
            TextField(
              controller: _confirmPasswordController,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: "Confirm Password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Register Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _registerUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF34C759),
                  minimumSize: const Size(315, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : const Text(
                        'Register',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 10),
            // Registration Navigation
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                child: const Text(
                  "Already Registered? Login",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
