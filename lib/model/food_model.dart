// class Food {
//   final String name;
//   final int calories;
//   final int protein;
//   final int fats;
//   final int carbs;
//   final int grams;

//   Food({
//     required this.name,
//     required this.calories,
//     required this.protein,
//     required this.fats,
//     required this.carbs,
//     required this.grams,
//   });
// }

class Food {
  final String name;
  final int calories;
  final int protein;
  final int fats;
  final int carbs;
  final int grams;

  Food({
    required this.name,
    required this.calories,
    required this.protein,
    required this.fats,
    required this.carbs,
    required this.grams,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'calories': calories,
      'protein': protein,
      'fats': fats,
      'carbs': carbs,
      'grams': grams,
    };
  }

  factory Food.fromMap(Map<String, dynamic> map) {
    return Food(
      name: map['name'] ?? '',
      calories: map['calories'] ?? 0,
      protein: map['protein'] ?? 0,
      fats: map['fats'] ?? 0,
      carbs: map['carbs'] ?? 0,
      grams: map['grams'] ?? 0,
    );
  }
}
