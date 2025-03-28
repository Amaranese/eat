import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<String?> getUserFirstName() async {
  try {
    String? uid =
        FirebaseAuth.instance.currentUser?.uid; // Get the current user's UID

    if (uid == null) {
      throw Exception("No user is logged in");
    }

    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (userDoc.exists) {
      return userDoc['firstName']; // Access the firstName field
    } else {
      print("User document does not exist.");
      return null;
    }
  } catch (e) {
    print("Error fetching user first name: $e");
    return null;
  }
}
