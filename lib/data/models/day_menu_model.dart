import 'package:equatable/equatable.dart';
import 'meal_model.dart';

class DayMenu extends Equatable {
  final String day;
  final Meal breakfast;
  final Meal lunch;
  final Meal snacks;
  final Meal dinner;

  const DayMenu({
    required this.day,
    required this.breakfast,
    required this.lunch,
    required this.snacks,
    required this.dinner,
  });

  List<Meal> get allMeals => [breakfast, lunch, snacks, dinner];

  Meal? get currentMeal {
    try {
      return allMeals.firstWhere(
        (meal) => meal.isActive,
      );
    } catch (e) {
      return null;
    }
  }

  Meal? get nextMeal {
    final upcomingMeals = allMeals.where((meal) => !meal.isPast).toList();
    if (upcomingMeals.isEmpty) return null;
    return upcomingMeals.first;
  }

  factory DayMenu.fromJson(String day, Map<String, dynamic> json) {
    return DayMenu(
      day: day,
      breakfast:
          Meal.fromJson('Breakfast', json['breakfast'] as Map<String, dynamic>),
      lunch: Meal.fromJson('Lunch', json['lunch'] as Map<String, dynamic>),
      snacks: Meal.fromJson('Snacks', json['snacks'] as Map<String, dynamic>),
      dinner: Meal.fromJson('Dinner', json['dinner'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'breakfast': breakfast.toJson(),
      'lunch': lunch.toJson(),
      'snacks': snacks.toJson(),
      'dinner': dinner.toJson(),
    };
  }

  @override
  List<Object?> get props => [day, breakfast, lunch, snacks, dinner];
}
