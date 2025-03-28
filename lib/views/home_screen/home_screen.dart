import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eat_fit/model/food_model.dart';
import 'package:eat_fit/shared/shared_date.dart';
import 'package:eat_fit/views/home_screen/components/calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:eat_fit/views/home_screen/profile/my_profile_screen.dart';
import 'components/greeting_text.dart';
import 'components/nutrients_indicator.dart';
import 'components/top_app_bar.dart';
import 'components/water_input.dart';
import 'components/weight_input.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

DateTime _selectedDate = DateTime.now(); // Add this to track the selected date

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _showCalendarDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return CalendarSection(
          selectedDate: selectedDateNotifier.value, // Use global value
          onDateSelected: (date) {
            selectedDateNotifier.value = date; // Update the global value
            Navigator.pop(context); // Close the calendar dialog
          },
        );
      },
    );
  }

  /// Fetch and calculate total nutrients from Firestore
  Stream<Map<String, int>> _fetchTotalNutrients() {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      throw Exception("User is not logged in.");
    }

    // React to changes in the global selected date
    final selectedDate = selectedDateNotifier.value;

    final startOfDay = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return _firestore
        .collection('meals')
        .where('userId', isEqualTo: userId)
        .where('timestamp',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('timestamp', isLessThan: Timestamp.fromDate(endOfDay))
        .snapshots()
        .map((snapshot) {
      int totalCalories = 0;
      int totalProteins = 0;
      int totalFats = 0;
      int totalCarbs = 0;

      for (final doc in snapshot.docs) {
        final foods = doc['foods'] as List<dynamic>;
        for (final foodMap in foods) {
          final food = Food.fromMap(foodMap as Map<String, dynamic>);
          totalCalories += food.calories;
          totalProteins += food.protein;
          totalFats += food.fats;
          totalCarbs += food.carbs;
        }
      }

      return {
        'calories': totalCalories,
        'proteins': totalProteins,
        'fats': totalFats,
        'carbs': totalCarbs,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: TopAppBar(
          onProfileTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyProfileScreen()),
            );
          },
          onCalendarTap: () =>
              _showCalendarDialog(context), // Call the calendar function
          showCalendarIcon: true,
        ),
      ),
      body: StreamBuilder<Map<String, int>>(
        stream: _fetchTotalNutrients(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final totals = snapshot.data ??
              {
                'calories': 0,
                'proteins': 0,
                'fats': 0,
                'carbs': 0,
              };

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting Text Component
                const GreetingText(),
                const SizedBox(height: 20),

                // Nutrients Indicator Component
                NutrientsIndicator(
                  totalCalories: totals['calories']!,
                  totalProteins: totals['proteins']!,
                  totalFats: totals['fats']!,
                  totalCarbs: totals['carbs']!,
                ),
                const SizedBox(height: 20),

                // Water Intake Component
                const WaterConsumed(),
                const SizedBox(height: 20),

                // Weight Input Component
                const WeightSection(),
              ],
            ),
          );
        },
      ),
    );
  }
}
