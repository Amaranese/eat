import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:eat_fit/model/food_model.dart';
import 'package:eat_fit/model/mock_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class AddMealScreen extends StatefulWidget {
  final String mealType;
  final Function(List<Food>) onFoodAdded;
  final DateTime selectedDate;

  const AddMealScreen({
    super.key,
    required this.mealType,
    required this.selectedDate, // Accept the selected date
    required this.onFoodAdded,
  });

  @override
  State<AddMealScreen> createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Food> _filteredFoods = mockFoods; // Initially display all foods
  List<Food> _selectedFoods = []; // List to store selected foods
  int _grams = 100;
  bool _showAddedProducts = false; // Toggle for added products display

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterFoods);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterFoods);
    _searchController.dispose();
    super.dispose();
  }

  /// Filters the food list based on the search input
  void _filterFoods() {
    setState(() {
      _filteredFoods = mockFoods
          .where((food) => food.name
              .toLowerCase()
              .contains(_searchController.text.trim().toLowerCase()))
          .toList();
    });
  }

  /// Calculates the total nutrition for the selected foods
  Map<String, int> _calculateTotals() {
    int totalCalories = 0;
    int totalProteins = 0;
    int totalFats = 0;
    int totalCarbs = 0;

    for (final food in _selectedFoods) {
      totalCalories += food.calories;
      totalProteins += food.protein;
      totalFats += food.fats;
      totalCarbs += food.carbs;
    }

    return {
      "calories": totalCalories,
      "proteins": totalProteins,
      "fats": totalFats,
      "carbs": totalCarbs,
    };
  }

// save meal to fire

  Future<void> _saveMealToFirebase() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("No logged-in user found");
      }

      // Format the selected date properly
      final formattedDate =
          DateFormat('yyyy-MM-dd').format(widget.selectedDate);

      // Create the meal data to save
      final mealData = {
        'userId': user.uid,
        'mealType': widget.mealType,
        'foods': _selectedFoods.map((food) => food.toMap()).toList(),
        'timestamp':
            Timestamp.fromDate(widget.selectedDate), // Use selectedDate
        'date': formattedDate, // Add this for easier querying
      };

      // Save to Firestore
      await FirebaseFirestore.instance.collection('meals').add(mealData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Meal saved successfully!")),
      );

      Navigator.pop(context);
    } catch (error) {
      print("Error: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save meal: $error")),
      );
    }
  }

  /// Displays the food details in a dialog
  void _showFoodDetails(BuildContext context, Food food) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(food.name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("${food.calories} Calories"),
              Text("${food.protein}g Protein"),
              Text("${food.fats}g Fats"),
              Text("${food.carbs}g Carbs"),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text("Grams:"),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          _grams = int.tryParse(value) ?? 100;
                        });
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "100",
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedFoods.add(Food(
                    name: food.name,
                    calories: (food.calories * _grams ~/ 100),
                    protein: (food.protein * _grams ~/ 100),
                    fats: (food.fats * _grams ~/ 100),
                    carbs: (food.carbs * _grams ~/ 100),
                    grams: _grams,
                  ));
                });
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void _showItemOptions(Food food) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text("Edit Grams"),
              onTap: () {
                Navigator.pop(context);
                _showEditGramsDialog(food);
              },
            ),
            ListTile(
              title: const Text("Remove"),
              onTap: () {
                setState(() {
                  _selectedFoods.remove(food);
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditGramsDialog(Food food) {
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
                //     setState(() {
                //       food.grams = int.tryParse(gramsController.text) ?? food.grams;
                //     });
                //     Navigator.pop(context);
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
    final totals = _calculateTotals();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Add Meal",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.fastfood, color: Colors.black),
                if (_selectedFoods.isNotEmpty)
                  Positioned(
                    right: 0,
                    child: CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.red,
                      child: Text(
                        "${_selectedFoods.length}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () {
              setState(() {
                _showAddedProducts = !_showAddedProducts;
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
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
              const Divider(height: 1, color: Colors.grey),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    labelText: "Search food",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredFoods.length,
                  itemBuilder: (context, index) {
                    final food = _filteredFoods[index];
                    return ListTile(
                      title: Text(food.name),
                      subtitle: Text("${food.calories} cal / 100 g"),
                      trailing: IconButton(
                        icon: const Icon(Icons.add_circle, color: Colors.green),
                        onPressed: () => _showFoodDetails(context, food),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          if (_showAddedProducts)
            GestureDetector(
              onTap: () {
                setState(() {
                  _showAddedProducts = false;
                });
              },
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    color: Colors.white,
                    height: 300,
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: _selectedFoods.length,
                            itemBuilder: (context, index) {
                              final food = _selectedFoods[index];
                              return ListTile(
                                title: Text(food.name),
                                subtitle: Text(
                                    "${food.grams} g • ${food.calories} Cal"),
                                trailing: IconButton(
                                  icon: const Icon(Icons.more_vert),
                                  onPressed: () => _showItemOptions(food),
                                ),
                              );
                            },
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _showAddedProducts = false;
                            });
                          },
                          child: const Text("Close"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF35CC8C),
        onPressed: () async {
          if (_selectedFoods.isNotEmpty) {
            await _saveMealToFirebase();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text("Please add at least one food item")),
            );
          }
        },
        child: const Icon(Icons.check),
      ),

      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: const Color(0xFF35CC8C),
      //   onPressed: () {
      //     widget.onFoodAdded(_selectedFoods);
      //     Navigator.pop(context);
      //   },
      //   child: const Icon(Icons.check),
      // ),
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
}
