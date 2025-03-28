// import 'package:eat_fit/app/main_page.dart';
// import 'package:eat_fit/consts/consts.dart';
// import 'package:eat_fit/views/auth%20screen/registration_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   bool _isPasswordVisible = false; // For toggling password visibility
//   bool _isLoading = false; // For showing loading state

//   Future<void> signIn() async {
//     setState(() {
//       _isLoading = true; // Set loading state to true
//     });

//     try {
//       await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: _emailController.text.trim(),
//         password: _passwordController.text.trim(),
//       );

//       // Navigate to the MainPage after successful login
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const MainPage()),
//       );
//     } on FirebaseAuthException catch (e) {
//       // Log the error code for debugging purposes
//       print("FirebaseAuthException code: ${e.code}");

//       String errorMessage;
//       switch (e.code) {
//         case 'user-not-found':
//           errorMessage = "No user found with this email.";
//           break;
//         case 'wrong-password':
//           errorMessage = "Incorrect password.";
//           break;
//         case 'invalid-email':
//           errorMessage = "Invalid email address.";
//           break;
//         case 'invalid-credential': // Handle invalid credential case
//           errorMessage = "Invalid credentials provided.";
//           break;
//         default:
//           errorMessage = "An error occurred. Please try again.";
//       }

//       // Show the specific error message in a SnackBar
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             errorMessage,
//             style: const TextStyle(color: Colors.white),
//           ),
//           backgroundColor: Colors.red,
//         ),
//       );
//     } catch (e) {
//       // Handle generic errors
//       print("Unknown error: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: const Text(
//             "Something went wrong. Please try again later.",
//             style: TextStyle(color: Colors.white),
//           ),
//           backgroundColor: Colors.red,
//         ),
//       );
//     } finally {
//       // Reset loading state
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   void dispose() {
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
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         title: const Text(
//           "Log In",
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
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "Welcome Back",
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//               ),
//             ),
//             const SizedBox(height: 10),
//             const Text(
//               "Log in to your account",
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.grey,
//               ),
//             ),
//             const SizedBox(height: 30),
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
//             // Login Button
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: _isLoading ? null : signIn,
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
//                         'Login',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 16,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//               ),
//             ),
//             const SizedBox(height: 10),
//             // Registration Navigation
//             Center(
//               child: GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const RegistrationScreen(),
//                     ),
//                   );
//                 },
//                 child: const Text(
//                   "Don't have an account? Register",
//                   style: TextStyle(
//                     color: Colors.blue,
//                     fontSize: 14,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:eat_fit/app/main_page.dart';
import 'package:eat_fit/consts/consts.dart';
import 'package:eat_fit/views/auth%20screen/registration_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false; // For toggling password visibility
  bool _isLoading = false; // For showing loading state

  // Method for signing in
  Future<void> signIn() async {
    setState(() {
      _isLoading = true; // Set loading state to true
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Navigate to the MainPage after successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainPage()),
      );
    } on FirebaseAuthException catch (e) {
      // Log the error code for debugging purposes
      print("FirebaseAuthException code: ${e.code}");

      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = "No user found with this email.";
          break;
        case 'wrong-password':
          errorMessage = "Incorrect password.";
          break;
        case 'invalid-email':
          errorMessage = "Invalid email address.";
          break;
        case 'invalid-credential': // Handle invalid credential case
          errorMessage = "Invalid credentials provided.";
          break;
        default:
          errorMessage = "An error occurred. Please try again.";
      }

      // Show the specific error message in a SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            errorMessage,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      // Handle generic errors
      print("Unknown error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            "Something went wrong. Please try again later.",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      // Reset loading state
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Method to handle forgot password
  Future<void> _forgotPassword() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter your email address."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Password reset email sent. Check your inbox.",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      switch (e.code) {
        case 'user-not-found':
          errorMessage = "No user found with this email.";
          break;
        case 'invalid-email':
          errorMessage = "Invalid email address.";
          break;
        default:
          errorMessage = "An error occurred. Please try again.";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            errorMessage,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Log In",
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Welcome Back",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Log in to your account",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 30),
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
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _forgotPassword,
                child: const Text(
                  "Forgot Password?",
                  style: TextStyle(color: Colors.blue, fontSize: 14),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Login Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : signIn,
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
                        'Login',
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
                      builder: (context) => const RegistrationScreen(),
                    ),
                  );
                },
                child: const Text(
                  "Don't have an account? Register",
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
