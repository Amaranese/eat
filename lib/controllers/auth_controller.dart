import 'package:eat_fit/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Register user with email, password, and additional data
  Future<void> registerUser({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    try {
      // Create user in Firebase Authentication
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      String uid = userCredential.user!.uid;

      print('User created successfully with UID: $uid');

      // Save user details in Firestore
      print('Saving user data to Firestore...');
      await _firestore.collection('users').doc(uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
        'profileImageUrl': '',
      });
      print('User data saved successfully!');
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException: $e');
      throw Exception(_handleFirebaseAuthError(e.code));
    } catch (e) {
      print('Unexpected Error: $e');
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }

  Future<void> getUserDetails(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        print("User data: ${userDoc.data()}");
      } else {
        print("User document not found!");
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  String _handleFirebaseAuthError(String errorCode) {
    switch (errorCode) {
      case 'email-already-in-use':
        return 'The email address is already in use.';
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'invalid-email':
        return 'The email address is not valid.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}
