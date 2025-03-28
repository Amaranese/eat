// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:eat_fit/model/food_model.dart';

// class MealService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   /// Save a meal to Firestore
//   Future<void> saveMeal(String uid, String mealType, List<Food> foods) async {
//     final mealData = {
//       'uid': uid,
//       'mealType': mealType,
//       'foods': foods.map((food) => food.toMap()).toList(),
//       'timestamp': DateTime.now().toIso8601String(),
//     };

//     await _firestore.collection('meals').add(mealData);
//   }

//   /// Fetch all meals for a user
//   Future<List<Map<String, dynamic>>> fetchMeals(String uid) async {
//     final snapshot = await _firestore
//         .collection('meals')
//         .where('uid', isEqualTo: uid)
//         .orderBy('timestamp', descending: true)
//         .get();

//     return snapshot.docs.map((doc) => doc.data()).toList();
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eat_fit/model/food_model.dart';

class MealService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Save a meal to Firestore
  Future<void> saveMeal(String uid, String mealType, List<Food> foods) async {
    try {
      final mealData = {
        'userId': uid, // Store userId for security rules
        'mealType': mealType,
        'foods': foods.map((food) => food.toMap()).toList(),
        'timestamp':
            FieldValue.serverTimestamp(), // Firestore's server timestamp
      };

      await _firestore.collection('meals').add(mealData);
    } catch (e) {
      throw Exception('Failed to save meal: $e');
    }
  }

  /// Fetch all meals for a user
  /// Fetch all meals for the logged-in user
  Future<List<Map<String, dynamic>>> fetchMeals(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('meals')
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true) // Optional: sort by timestamp
          .get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      throw Exception("Failed to fetch meals: $e");
    }
  }
  // Future<List<Map<String, dynamic>>> fetchMeals(String uid) async {
  //   try {
  //     final snapshot = await _firestore
  //         .collection('meals')
  //         .where('userId', isEqualTo: uid) // Filter by userId
  //         .orderBy('timestamp', descending: true) // Order by the latest first
  //         .get();

  //     return snapshot.docs.map((doc) => doc.data()).toList();
  //   } catch (e) {
  //     throw Exception('Failed to fetch meals: $e');
  //   }
  // }
}
