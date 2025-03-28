import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NutrientsIndicator extends StatefulWidget {
  final int totalCalories;
  final int totalProteins;
  final int totalFats;
  final int totalCarbs;

  const NutrientsIndicator({
    super.key,
    required this.totalCalories,
    required this.totalProteins,
    required this.totalFats,
    required this.totalCarbs,
  });

  @override
  _NutrientsIndicatorState createState() => _NutrientsIndicatorState();
}

class _NutrientsIndicatorState extends State<NutrientsIndicator> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, int> _dailyGoals = {
    'calories': 3400,
    'proteins': 225,
    'fats': 118,
    'carbs': 340,
  };

  @override
  void initState() {
    super.initState();
    _fetchDailyGoals();
  }

  /// Fetch custom nutrient goals from Firestore
  Future<void> _fetchDailyGoals() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) return;

    final doc = await _firestore.collection('users').doc(userId).get();

    if (doc.exists && doc.data()!['dailyGoals'] != null) {
      setState(() {
        _dailyGoals = Map<String, int>.from(doc.data()!['dailyGoals']);
      });
    }
  }

  /// Save updated nutrient goals to Firestore
  Future<void> _saveDailyGoals(Map<String, int> updatedGoals) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) return;

    await _firestore.collection('users').doc(userId).set(
      {'dailyGoals': updatedGoals},
      SetOptions(merge: true),
    );

    setState(() {
      _dailyGoals = updatedGoals;
    });
  }

  /// Show dialog to edit nutrient goals
  void _showEditGoalsDialog() {
    final TextEditingController caloriesController =
        TextEditingController(text: _dailyGoals['calories'].toString());
    final TextEditingController proteinsController =
        TextEditingController(text: _dailyGoals['proteins'].toString());
    final TextEditingController fatsController =
        TextEditingController(text: _dailyGoals['fats'].toString());
    final TextEditingController carbsController =
        TextEditingController(text: _dailyGoals['carbs'].toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Daily Goals"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildInputField("Calories", caloriesController),
              _buildInputField("Proteins", proteinsController),
              _buildInputField("Fats", fatsController),
              _buildInputField("Carbs", carbsController),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final updatedGoals = {
                  'calories': int.tryParse(caloriesController.text) ?? 0,
                  'proteins': int.tryParse(proteinsController.text) ?? 0,
                  'fats': int.tryParse(fatsController.text) ?? 0,
                  'carbs': int.tryParse(carbsController.text) ?? 0,
                };

                _saveDailyGoals(updatedGoals);
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Nutrients Indicator",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.edit,
                  color: Color.fromARGB(255, 75, 75, 75)),
              onPressed: _showEditGoalsDialog,
            ),
          ],
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
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _nutrientItem("Proteins", widget.totalProteins,
                      _dailyGoals['proteins']!, Colors.red),
                  _nutrientItem("Fats", widget.totalFats, _dailyGoals['fats']!,
                      Colors.yellow),
                  _nutrientItem("Carbs", widget.totalCarbs,
                      _dailyGoals['carbs']!, Colors.brown),
                ],
              ),
              const SizedBox(height: 20),
              _calorieBar(widget.totalCalories, _dailyGoals['calories']!),
            ],
          ),
        ),
      ],
    );
  }

  Widget _nutrientItem(String name, int consumed, int target, Color color) {
    double progress = consumed / target;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 5),
        SizedBox(
          width: 80,
          child: LinearProgressIndicator(
            value: progress > 1 ? 1 : progress,
            color: color,
            backgroundColor: Colors.grey.shade300,
            minHeight: 5,
          ),
        ),
        const SizedBox(height: 5),
        Text("$consumed / $target",
            style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _calorieBar(int consumed, int target) {
    double progress = consumed / target;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Calories", style: TextStyle(fontSize: 16)),
        const SizedBox(height: 5),
        LinearProgressIndicator(
          value: progress > 1 ? 1 : progress,
          color: Colors.green,
          backgroundColor: Colors.grey.shade300,
        ),
        const SizedBox(height: 5),
        Text("$consumed / $target"),
      ],
    );
  }
}
