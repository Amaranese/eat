// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:intl/intl.dart';

// class WeightSection extends StatefulWidget {
//   const WeightSection({super.key});

//   @override
//   _WeightSectionState createState() => _WeightSectionState();
// }

// class _WeightSectionState extends State<WeightSection> {
//   double _currentWeight = 0.0; // Default to 0 until fetched
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   @override
//   void initState() {
//     super.initState();
//     _fetchLatestWeight(); // Fetch the latest weight on initialization
//   }

//   /// Fetch the latest weight from Firestore
//   Future<void> _fetchLatestWeight() async {
//     try {
//       final user = FirebaseAuth.instance.currentUser;

//       if (user == null) {
//         throw Exception("No logged-in user found.");
//       }

//       // Get the weight document for the current user
//       final weightDoc =
//           await _firestore.collection('weights').doc(user.uid).get();

//       if (weightDoc.exists) {
//         final weights = weightDoc.data()?['weights'] as List<dynamic>? ?? [];

//         if (weights.isNotEmpty) {
//           // Sort weights by date to get the latest one
//           weights.sort((a, b) {
//             final dateA = DateTime.parse(a['date']);
//             final dateB = DateTime.parse(b['date']);
//             return dateB.compareTo(dateA); // Sort in descending order
//           });

//           setState(() {
//             _currentWeight =
//                 weights.first['weight'].toDouble(); // Set the latest weight
//           });
//         }
//       }
//     } catch (e) {
//       print("Error fetching latest weight: $e");
//     }
//   }

//   /// Save weight to Firestore
//   Future<void> _saveWeightToFirestore(double weight) async {
//     try {
//       final user = FirebaseAuth.instance.currentUser;

//       if (user == null) {
//         throw Exception("No logged-in user found.");
//       }

//       final date = DateTime.now();
//       final formattedDate = DateFormat('yyyy-MM-dd').format(date);

//       // Reference the weights document for the current user
//       final weightRef =
//           FirebaseFirestore.instance.collection('weights').doc(user.uid);

//       // Fetch existing weights
//       final weightDoc = await weightRef.get();
//       List<dynamic> weights = weightDoc.data()?['weights'] ?? [];

//       // Check if an entry for the current date already exists
//       bool updated = false;
//       for (var entry in weights) {
//         if (entry['date'] == formattedDate) {
//           // Update the existing entry
//           entry['weight'] = weight;
//           updated = true;
//           break;
//         }
//       }

//       if (!updated) {
//         // Add a new entry if no entry for today exists
//         weights.add({'weight': weight, 'date': formattedDate});
//       }

//       // Save the updated weights array back to Firestore
//       await weightRef.set({
//         'userId': user.uid,
//         'weights': weights,
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Weight saved successfully!")),
//       );

//       // Update the current weight in the UI
//       setState(() {
//         _currentWeight = weight;
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Failed to save weight: $e")),
//       );
//     }
//   }

//   void _registerWeight() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         double newWeight = _currentWeight;
//         return AlertDialog(
//           title: const Text("Register Weight"),
//           content: TextFormField(
//             initialValue: newWeight.toString(),
//             keyboardType: TextInputType.number,
//             decoration: InputDecoration(
//               labelText: "Enter your weight (kg)",
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//             onChanged: (value) {
//               newWeight = double.tryParse(value) ?? newWeight;
//             },
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close dialog without saving
//               },
//               child: const Text("Cancel"),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 _saveWeightToFirestore(newWeight); // Save weight to Firestore
//                 Navigator.of(context).pop(); // Save and close dialog
//               },
//               child: const Text("Save"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           "Weight",
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 10),
//         Container(
//           padding: const EdgeInsets.all(16.0),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//             color: Colors.white,
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.shade300,
//                 blurRadius: 10,
//                 offset: const Offset(0, 5),
//               ),
//             ],
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     "Your Weight",
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     "$_currentWeight kg",
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.blueAccent,
//                     ),
//                   ),
//                 ],
//               ),
//               Row(
//                 children: [
//                   IconButton(
//                     onPressed: _registerWeight,
//                     icon: const Icon(Icons.add_circle,
//                         color: Color.fromARGB(255, 185, 186, 185)),
//                     iconSize: 36,
//                   ),
//                   const SizedBox(width: 10),
//                   Image.asset(
//                     'assets/images/weight.png',
//                     width: 40,
//                     height: 40,
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:eat_fit/shared/shared_date.dart';

class WeightSection extends StatefulWidget {
  const WeightSection({super.key});

  @override
  _WeightSectionState createState() => _WeightSectionState();
}

class _WeightSectionState extends State<WeightSection> {
  double _currentWeight = 0.0; // Default to 0 until fetched
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _fetchWeightForSelectedDate(); // Fetch the weight for the current selected date
    selectedDateNotifier.addListener(_onDateChange); // Listen for date changes
  }

  @override
  void dispose() {
    selectedDateNotifier.removeListener(_onDateChange);
    super.dispose();
  }

  void _onDateChange() {
    _fetchWeightForSelectedDate(); // Fetch weight whenever the selected date changes
  }

  /// Fetch weight for the selected date from Firestore
  Future<void> _fetchWeightForSelectedDate() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception("No logged-in user found.");
      }

      final formattedDate =
          DateFormat('yyyy-MM-dd').format(selectedDateNotifier.value);

      // Get the weight document for the current user
      final weightDoc =
          await _firestore.collection('weights').doc(user.uid).get();

      if (weightDoc.exists) {
        final weights = weightDoc.data()?['weights'] as List<dynamic>? ?? [];

        for (var entry in weights) {
          if (entry['date'] == formattedDate) {
            setState(() {
              _currentWeight = entry['weight'].toDouble();
            });
            return;
          }
        }
      }

      // If no weight found for the selected date, set to 0
      setState(() {
        _currentWeight = 0.0;
      });
    } catch (e) {
      print("Error fetching weight for selected date: $e");
    }
  }

  /// Save weight to Firestore for the selected date
  Future<void> _saveWeightToFirestore(double weight) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception("No logged-in user found.");
      }

      final formattedDate =
          DateFormat('yyyy-MM-dd').format(selectedDateNotifier.value);

      // Reference the weights document for the current user
      final weightRef = _firestore.collection('weights').doc(user.uid);

      // Fetch existing weights
      final weightDoc = await weightRef.get();
      List<dynamic> weights = weightDoc.data()?['weights'] ?? [];

      // Check if an entry for the selected date already exists
      bool updated = false;
      for (var entry in weights) {
        if (entry['date'] == formattedDate) {
          // Update the existing entry
          entry['weight'] = weight;
          updated = true;
          break;
        }
      }

      if (!updated) {
        // Add a new entry if no entry for the selected date exists
        weights.add({'weight': weight, 'date': formattedDate});
      }

      // Save the updated weights array back to Firestore
      await weightRef.set({
        'userId': user.uid,
        'weights': weights,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Weight saved successfully!")),
      );

      // Update the current weight in the UI
      setState(() {
        _currentWeight = weight;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save weight: $e")),
      );
    }
  }

  void _registerWeight() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double newWeight = _currentWeight;
        return AlertDialog(
          title: const Text("Register Weight"),
          content: TextFormField(
            initialValue: newWeight.toString(),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Enter your weight (kg)",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onChanged: (value) {
              newWeight = double.tryParse(value) ?? newWeight;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog without saving
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                _saveWeightToFirestore(newWeight); // Save weight to Firestore
                Navigator.of(context).pop(); // Save and close dialog
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Weight",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Your Weight",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "$_currentWeight kg",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green, // Change to green
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: _registerWeight,
                    icon: const Icon(Icons.add_circle,
                        color: Color.fromARGB(255, 185, 186, 185)),
                    iconSize: 36,
                  ),
                  const SizedBox(width: 10),
                  Image.asset(
                    'assets/images/weight.png',
                    width: 40,
                    height: 40,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
