import 'package:eat_fit/shared/shared_date.dart';
import 'package:eat_fit/views/home_screen/components/calendar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eat_fit/views/home_screen/components/top_app_bar.dart';
import 'package:eat_fit/views/home_screen/profile/my_profile_screen.dart';
import 'package:eat_fit/views/home_screen/components/water_input.dart';
import 'package:eat_fit/views/home_screen/components/weight_input.dart';
import 'package:eat_fit/views/home_screen/diary/add_meal_screen.dart';
import 'package:eat_fit/views/home_screen/components/meal/meal_input.dart';
import 'package:eat_fit/model/food_model.dart';
import 'package:intl/intl.dart';

class DiaryScreen extends StatefulWidget {
  const DiaryScreen({super.key});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetch meals as a stream for the selected date
  Stream<List<Map<String, dynamic>>> _fetchMealsStream() {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      throw Exception("User is not logged in.");
    }

    final startOfDay = DateTime(
      selectedDateNotifier.value.year,
      selectedDateNotifier.value.month,
      selectedDateNotifier.value.day,
    );
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return _firestore
        .collection('meals')
        .where('userId', isEqualTo: userId)
        .where('timestamp',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('timestamp', isLessThan: Timestamp.fromDate(endOfDay))
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              return {
                ...data,
                'id': doc.id, // Add the Firestore document ID
              };
            }).toList());
  }

  /// Calculate total nutrients for the selected meals
  Map<String, int> _calculateTotals(Map<String, List<Food>> mealFoods) {
    int totalCalories = 0;
    int totalProteins = 0;
    int totalFats = 0;
    int totalCarbs = 0;

    mealFoods.forEach((_, foods) {
      for (final food in foods) {
        totalCalories += food.calories;
        totalProteins += food.protein;
        totalFats += food.fats;
        totalCarbs += food.carbs;
      }
    });

    return {
      'calories': totalCalories,
      'proteins': totalProteins,
      'fats': totalFats,
      'carbs': totalCarbs,
    };
  }

  /// Show the calendar dialog
  void _showCalendarDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return CalendarSection(
          selectedDate: selectedDateNotifier.value,
          onDateSelected: (date) {
            selectedDateNotifier.value = date; // Update the global date
            Navigator.pop(context); // Close the calendar dialog
          },
        );
      },
    );
  }

  // /// Push daily totals to Firestore for the selected date
  /// Push daily totals to Firestore for the selected date
  Future<void> _pushDailyTotalsToFirestore(Map<String, int> totals) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      print("No user logged in. Cannot save daily totals.");
      return;
    }

    // Check if all totals are 0. If so, skip saving to Firestore
    if (totals['calories'] == 0 &&
        totals['proteins'] == 0 &&
        totals['fats'] == 0 &&
        totals['carbs'] == 0) {
      print("No nutrients data to save. Skipping Firestore update.");
      return;
    }

    final selectedDate = selectedDateNotifier.value;
    final formattedDate =
        "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";

    try {
      await _firestore
          .collection('daily_totals')
          .doc("$userId-$formattedDate")
          .set({
        'userId': userId,
        'date': formattedDate,
        'calories': totals['calories'] ?? 0,
        'proteins': totals['proteins'] ?? 0,
        'fats': totals['fats'] ?? 0,
        'carbs': totals['carbs'] ?? 0,
      });
      print("Daily totals pushed to Firestore for $formattedDate.");
    } catch (e) {
      print("Failed to push daily totals: $e");
    }
  }

  // Future<void> _pushDailyTotalsToFirestore(Map<String, int> totals) async {
  //   final userId = FirebaseAuth.instance.currentUser?.uid;

  //   if (userId == null) {
  //     print("No user logged in. Cannot save daily totals.");
  //     return;
  //   }

  //   final selectedDate = selectedDateNotifier.value;
  //   final formattedDate =
  //       "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";

  //   try {
  //     await _firestore
  //         .collection('daily_totals')
  //         .doc("$userId-$formattedDate")
  //         .set({
  //       'userId': userId,
  //       'date': formattedDate,
  //       'calories': totals['calories'] ?? 0,
  //       'proteins': totals['proteins'] ?? 0,
  //       'fats': totals['fats'] ?? 0,
  //       'carbs': totals['carbs'] ?? 0,
  //     });
  //     print("Daily totals pushed to Firestore for $formattedDate.");
  //   } catch (e) {
  //     print("Failed to push daily totals: $e");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<DateTime>(
      valueListenable: selectedDateNotifier,
      builder: (context, selectedDate, _) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: TopAppBar(
              onProfileTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyProfileScreen(),
                  ),
                );
              },
              onCalendarTap: () => _showCalendarDialog(context),
              showCalendarIcon: true,
            ),
          ),
          body: StreamBuilder<List<Map<String, dynamic>>>(
            stream: _fetchMealsStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                print("Error fetching meals: \${snapshot.error}");
                return Center(child: Text("Error: \${snapshot.error}"));
              }

              final meals = snapshot.data ?? [];

              // Group meals by type and store meal IDs
              final Map<String, List<Food>> mealFoods = {
                "Breakfast": [],
                "Lunch": [],
                "Dinner": [],
              };
              final Map<String, String> mealIds = {};

              for (var meal in meals) {
                final mealType = meal['mealType'] as String;
                final foods = (meal['foods'] as List<dynamic>)
                    .map((foodMap) =>
                        Food.fromMap(foodMap as Map<String, dynamic>))
                    .toList();
                mealFoods[mealType]?.addAll(foods);
                mealIds[mealType] = meal['id']; // Store the meal ID
              }

              final totals = _calculateTotals(mealFoods);

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    const WaterConsumed(),
                    const SizedBox(height: 20),

                    // Total Nutrition Info Row
                    Text(
                      "${DateFormat.yMMMd().format(selectedDate)} \nNutrition Summary",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _buildNutritionInfoRow(totals),
                    const SizedBox(height: 20),

                    // Meal Input Sections
                    ...["Breakfast", "Lunch", "Dinner"].map((mealType) {
                      return Column(
                        children: [
                          MealInput(
                            mealType: mealType,
                            foods: mealFoods[mealType]!,
                            onAddMeal: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddMealScreen(
                                    mealType: mealType,
                                    selectedDate: selectedDate,
                                    onFoodAdded: (foods) {
                                      // Foods will be updated through Firestore
                                    },
                                  ),
                                ),
                              );
                            },
                            onDeleteFood: (food) async {
                              final mealId = mealIds[mealType];
                              if (mealId != null) {
                                await _deleteFood(mealId, food);
                              }
                            },
                            onEditFood: (food, newGrams) async {
                              final mealId = mealIds[mealType];
                              if (mealId != null) {
                                await _editFood(mealId, food, newGrams);
                              }
                            },
                          ),
                          const SizedBox(height: 10),
                        ],
                      );
                    }).toList(),

                    const SizedBox(height: 20),

                    // Weight Section
                    const WeightSection(),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  /// Build a row displaying the total nutrition information
  Widget _buildNutritionInfoRow(Map<String, int> totals) {
    // Push totals for the selected date
    _pushDailyTotalsToFirestore(totals);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNutritionInfo("Calories", "${totals['calories']}"),
            _buildNutritionInfo("Proteins", "${totals['proteins']}g"),
            _buildNutritionInfo("Fats", "${totals['fats']}g"),
            _buildNutritionInfo("Carbs", "${totals['carbs']}g"),
          ],
        ),
      ),
    );
  }

  /// Build individual nutrient info item
  Widget _buildNutritionInfo(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  /// Edit a food item for the selected date
  Future<void> _editFood(String mealId, Food oldFood, int newGrams) async {
    try {
      final updatedFood = Food(
        name: oldFood.name,
        calories: (oldFood.calories * newGrams ~/ oldFood.grams),
        protein: (oldFood.protein * newGrams ~/ oldFood.grams),
        fats: (oldFood.fats * newGrams ~/ oldFood.grams),
        carbs: (oldFood.carbs * newGrams ~/ oldFood.grams),
        grams: newGrams,
      );

      await _firestore.collection('meals').doc(mealId).update({
        'foods': FieldValue.arrayRemove([oldFood.toMap()]),
      });

      await _firestore.collection('meals').doc(mealId).update({
        'foods': FieldValue.arrayUnion([updatedFood.toMap()]),
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to edit food: $e")),
      );
    }
  }

  /// Delete a food item for the selected date
  Future<void> _deleteFood(String mealId, Food food) async {
    try {
      await _firestore.collection('meals').doc(mealId).update({
        'foods': FieldValue.arrayRemove([food.toMap()]),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Food item deleted successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete food: $e")),
      );
    }
  }
}
