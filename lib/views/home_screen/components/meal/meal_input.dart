// import 'package:eat_fit/model/food_model.dart';
// import 'package:flutter/material.dart';

// class MealInput extends StatelessWidget {
//   final String mealType;
//   final List<Food> foods; // Updated to match DiaryScreen
//   final VoidCallback onAddMeal;

//   const MealInput({
//     super.key,
//     required this.mealType,
//     required this.foods,
//     required this.onAddMeal,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final totalCalories =
//         foods.fold<int>(0, (sum, food) => sum + food.calories);

//     return Card(
//       color: const Color.fromARGB(255, 254, 253, 251),
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       child: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Meal Type and Calories Display
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   mealType,
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   "$totalCalories cal",
//                   style: const TextStyle(
//                     fontSize: 16,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),

//             // Foods List or Placeholder Text
//             if (foods.isEmpty)
//               const Text(
//                 "Input your food",
//                 style: TextStyle(color: Colors.grey),
//               )
//             else
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: foods
//                     .map((food) => Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 4.0),
//                           child: Text(
//                             "${food.name} - ${food.calories} cal",
//                             style: const TextStyle(fontSize: 14),
//                           ),
//                         ))
//                     .toList(),
//               ),
//             const SizedBox(height: 10),

//             // Add Food Button
//             Align(
//               alignment: Alignment.centerRight,
//               child: TextButton(
//                 onPressed: onAddMeal,
//                 child: const Text(
//                   "Add Food",
//                   style: TextStyle(color: Colors.blue),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:eat_fit/model/food_model.dart';
import 'package:flutter/material.dart';

class MealInput extends StatelessWidget {
  final String mealType;
  final List<Food> foods;
  final VoidCallback onAddMeal;
  final Function(Food) onDeleteFood; // Callback for deleting a food
  final Function(Food, int) onEditFood; // Callback for editing a food's grams

  const MealInput({
    super.key,
    required this.mealType,
    required this.foods,
    required this.onAddMeal,
    required this.onDeleteFood,
    required this.onEditFood,
  });

  @override
  Widget build(BuildContext context) {
    final totalCalories =
        foods.fold<int>(0, (sum, food) => sum + food.calories);

    return Card(
      color: const Color.fromARGB(255, 255, 255, 255),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Meal Type and Calories Display
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  mealType,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "$totalCalories cal",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Foods List or Placeholder Text
            if (foods.isEmpty)
              const Text(
                "Input your food",
                style: TextStyle(color: Colors.grey),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: foods
                    .map((food) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${food.name} - ${food.calories} cal",
                                style: const TextStyle(fontSize: 14),
                              ),
                              IconButton(
                                icon: const Icon(Icons.more_vert,
                                    color: Colors.grey),
                                onPressed: () {
                                  _showFoodOptions(context, food);
                                },
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            const SizedBox(height: 10),

            // Add Food Button
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onAddMeal,
                child: const Text(
                  "Add Food",
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Displays a modal with options to edit or delete the food item
  void _showFoodOptions(BuildContext context, Food food) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                food.name,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.blue),
                title: const Text("Edit Grams"),
                onTap: () {
                  Navigator.pop(context);
                  _showEditGramsDialog(context, food);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text("Delete"),
                onTap: () {
                  onDeleteFood(food);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// Shows a dialog to edit the grams of a food item
  void _showEditGramsDialog(BuildContext context, Food food) {
    final TextEditingController gramsController =
        TextEditingController(text: food.grams.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Grams for ${food.name}"),
          content: TextField(
            controller: gramsController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Enter grams",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final newGrams =
                    int.tryParse(gramsController.text) ?? food.grams;
                onEditFood(food, newGrams); // Trigger edit callback
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }
}

// import 'package:eat_fit/model/food_model.dart';
// import 'package:flutter/material.dart';

// class MealInput extends StatelessWidget {
//   final String mealType;
//   final List<Food> foods;
//   final VoidCallback onAddMeal;
//   final Function(Food) onDeleteFood; // Callback for deleting a food
//   final Function(Food, int) onEditFood; // Callback for editing a food's grams

//   const MealInput({
//     super.key,
//     required this.mealType,
//     required this.foods,
//     required this.onAddMeal,
//     required this.onDeleteFood,
//     required this.onEditFood,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final totalCalories =
//         foods.fold<int>(0, (sum, food) => sum + food.calories);

//     return Card(
//       color: const Color.fromARGB(255, 254, 253, 251),
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       child: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Meal Type and Calories Display
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   mealType,
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   "$totalCalories cal",
//                   style: const TextStyle(
//                     fontSize: 16,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),

//             // Foods List or Placeholder Text
//             if (foods.isEmpty)
//               const Text(
//                 "Input your food",
//                 style: TextStyle(color: Colors.grey),
//               )
//             else
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: foods
//                     .map((food) => Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 4.0),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 "${food.name} - ${food.calories} cal",
//                                 style: const TextStyle(fontSize: 14),
//                               ),
//                               IconButton(
//                                 icon: const Icon(Icons.more_vert,
//                                     color: Colors.grey),
//                                 onPressed: () {
//                                   _showFoodOptions(context, food);
//                                 },
//                               ),
//                             ],
//                           ),
//                         ))
//                     .toList(),
//               ),
//             const SizedBox(height: 10),

//             // Add Food Button
//             Align(
//               alignment: Alignment.centerRight,
//               child: TextButton(
//                 onPressed: onAddMeal,
//                 child: const Text(
//                   "Add Food",
//                   style: TextStyle(color: Colors.blue),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   /// Displays a modal with options to edit or delete the food item
//   void _showFoodOptions(BuildContext context, Food food) {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return Container(
//           padding: const EdgeInsets.all(16),
//           height: 200,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 food.name,
//                 style:
//                     const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 16),
//               ListTile(
//                 leading: const Icon(Icons.edit, color: Colors.blue),
//                 title: const Text("Edit Grams"),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _showEditGramsDialog(context, food);
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.delete, color: Colors.red),
//                 title: const Text("Delete"),
//                 onTap: () {
//                   onDeleteFood(food);
//                   Navigator.pop(context);
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   /// Shows a dialog to edit the grams of a food item
//   void _showEditGramsDialog(BuildContext context, Food food) {
//     final TextEditingController gramsController =
//         TextEditingController(text: food.grams.toString());

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text("Edit Grams for ${food.name}"),
//           content: TextField(
//             controller: gramsController,
//             keyboardType: TextInputType.number,
//             decoration: const InputDecoration(
//               border: OutlineInputBorder(),
//               hintText: "Enter grams",
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("Cancel"),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 final newGrams =
//                     int.tryParse(gramsController.text) ?? food.grams;
//                 final newCalories = (food.calories * newGrams ~/ food.grams);

//                 onEditFood(food, newGrams);
//                 Navigator.pop(context);
//               },
//               child: const Text("Save"),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
