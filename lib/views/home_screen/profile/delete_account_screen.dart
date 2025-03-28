import 'package:eat_fit/views/auth%20screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  bool _isLoading = false;

  /// **Delete the user's account**
  Future<void> _deleteAccount(String password) async {
    try {
      setState(() {
        _isLoading = true;
      });

      final user = FirebaseAuth.instance.currentUser!;
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );

      // Reauthenticate the user
      await user.reauthenticateWithCredential(credential);

      // Delete the user document from Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .delete();

      // Delete the user's account
      await user.delete();

      // Show success dialog and navigate to login screen
      showDialog(
        context: context,
        barrierDismissible:
            false, // Prevent closing the dialog by tapping outside
        builder: (context) {
          return AlertDialog(
            title: const Text("Account Deleted"),
            content: const Text("Your account has been successfully deleted."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                    (route) => false,
                  ); // Navigate to LoginScreen
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        _showSnackbar("Incorrect password. Please try again.");
      } else {
        _showSnackbar("Error: ${e.message}");
      }
    } catch (e) {
      _showSnackbar("An unexpected error occurred.");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// **Show a Snackbar with a message**
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  /// **Show the password confirmation dialog**
  Future<void> _showPasswordDialog() async {
    final TextEditingController passwordController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm Deletion"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Enter your password to delete your account."),
              const SizedBox(height: 10),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final password = passwordController.text.trim();
                Navigator.pop(context);
                _deleteAccount(password);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text("Delete"),
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
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Delete Account",
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  const Text(
                    "Are you sure you want to delete your account?",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _showPasswordDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Delete Account",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
