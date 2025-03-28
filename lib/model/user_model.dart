class UserModel {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  // final List<Map<String, dynamic>> meals; // List to store meals
  // final DateTime? lastLogin; // Optional: To track user activity

  UserModel({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    // this.meals = const [], // Default to an empty list
    // this.lastLogin,
  });

  // Convert UserModel to Map (for Firestore storage)
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      // 'meals': meals, // Meals will be a list of maps
      // 'lastLogin': lastLogin?.toIso8601String(),
    };
  }

  // Create UserModel from Firestore Map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      email: map['email'] ?? '',
      // meals: List<Map<String, dynamic>>.from(map['meals'] ?? []),
      // lastLogin: map['lastLogin'] != null
      //     ? DateTime.parse(map['lastLogin'])
      //     : null,
    );
  }
}
