// import 'package:flutter/material.dart';

// class GreetingText extends StatelessWidget {
//   final String userName;

//   const GreetingText({super.key, required this.userName});

//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       "Hey $userName,\nHow is your diet?",
//       style: const TextStyle(
//         fontSize: 20,
//         fontWeight: FontWeight.bold,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GreetingText extends StatefulWidget {
  const GreetingText({super.key});

  @override
  State<GreetingText> createState() => _GreetingTextState();
}

class _GreetingTextState extends State<GreetingText> {
  String? firstName; // Stores the user's first name
  bool isLoading = true; // Indicates whether data is being fetched

  @override
  void initState() {
    super.initState();
    fetchFirstName(); // Fetch the first name on initialization
  }

  Future<void> fetchFirstName() async {
    try {
      // Get the current user's UID
      String? uid = FirebaseAuth.instance.currentUser?.uid;

      if (uid != null) {
        // Fetch user document from Firestore
        DocumentSnapshot userDoc =
            await FirebaseFirestore.instance.collection('users').doc(uid).get();

        if (userDoc.exists) {
          setState(() {
            firstName = userDoc['firstName']; // Extract the firstName field
            isLoading = false;
          });
        } else {
          print("User document does not exist.");
          setState(() {
            firstName = "User";
            isLoading = false;
          });
        }
      } else {
        print("No user is logged in.");
        setState(() {
          firstName = "User";
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching user first name: $e");
      setState(() {
        firstName = "User";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const CircularProgressIndicator(); // Show a loading indicator while fetching data
    }

    return Text(
      "Hey $firstName,\nHow is your diet?",
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
