import 'package:eat_fit/model/food_model.dart';
import 'package:flutter/material.dart';

class SelectedFoodScreen extends StatelessWidget {
  final List<Food> selectedFoods;
  final VoidCallback onAddMore;
  final VoidCallback onSave;
  final Function(Food) onRemoveFood;
  final Function(Food, int) onUpdateGrams;

  const SelectedFoodScreen({
    super.key,
    required this.selectedFoods,
    required this.onAddMore,
    required this.onSave,
    required this.onRemoveFood,
    required this.onUpdateGrams,
  });

  @override
  Widget build(BuildContext context) {
    final totalCalories = selectedFoods.fold<int>(
      0,
      (sum, food) => sum + food.calories,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Selected Foods",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black),
            onPressed: onAddMore,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNutritionInfo("Calories", "$totalCalories"),
                _buildNutritionInfo(
                  "Proteins",
                  "${selectedFoods.fold<int>(0, (sum, food) => sum + food.protein)}g",
                ),
                _buildNutritionInfo(
                  "Fats",
                  "${selectedFoods.fold<int>(0, (sum, food) => sum + food.fats)}g",
                ),
                _buildNutritionInfo(
                  "Carbs",
                  "${selectedFoods.fold<int>(0, (sum, food) => sum + food.carbs)}g",
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: selectedFoods.length,
              itemBuilder: (context, index) {
                final food = selectedFoods[index];
                return ListTile(
                  title: Text(food.name),
                  subtitle: Text("${food.grams} g • ${food.calories} Cal"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          _showEditDialog(context, food);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => onRemoveFood(food),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: onSave,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: const Color(0xFF35CC8C),
              ),
              child: const Text("Save"),
            ),
          ),
        ],
      ),
    );
  }

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

  void _showEditDialog(BuildContext context, Food food) {
    final TextEditingController _gramsController =
        TextEditingController(text: food.grams.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit ${food.name}"),
          content: TextField(
            controller: _gramsController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Grams",
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
                    int.tryParse(_gramsController.text) ?? food.grams;
                onUpdateGrams(food, newGrams);
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
