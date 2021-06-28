import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class FullDayMenu {
  // Some days may not have breakfast/dinner
  final Menu? breakfast;
  final Menu? dinner;

  FullDayMenu({this.breakfast, this.dinner});

  factory FullDayMenu.fromMap(Map<String, dynamic> mealDict) {
    final breakfast = mealDict['breakfast'] as Map<String, dynamic>?;
    final dinner = mealDict['dinner'] as Map<String, dynamic>?;

    return FullDayMenu(
      breakfast: breakfast?.createMenu(),
      dinner: dinner?.createMenu(),
    );
  }
}

extension on Map<String, dynamic> {
  Menu createMenu() {
    return Menu.fromMap(this);
  }
}

class Menu {
  final List<Meal> meals;

  Menu(this.meals);

  Meal? getMealByCuisineId(int cuisineId) {
    if (cuisineId < 0 || cuisineId >= Cuisine.values.length) return null;
    try {
      return meals
          .singleWhere((meal) => meal.cuisine == Cuisine.values[cuisineId]);
      // ignore: empty_catches
    } on StateError {
      // meal not found
    }
  }

  factory Menu.fromMap(Map<String, dynamic> map) {
    final meals = <Meal>[];
    map.forEach((cuisineName, mealItemList) {
      final cuisine = Cuisine.values
          .firstWhere((type) => describeEnum(type) == cuisineName);
      final mealItems = (mealItemList as List<dynamic>)
          .map((mealItemName) => MealItem(mealItemName as String))
          .toList();
      meals.add(Meal(cuisine, mealItems));
    });
    return Menu(meals);
  }
}

class Meal {
  final Cuisine cuisine;
  final List<MealItem> mealItems;

  Meal(this.cuisine, this.mealItems);
}

class MealItem {
  final String name;

  MealItem(this.name);
}

enum MealType { breakfast, dinner, none }

enum Cuisine { asian, malay, vegetarian, western }

extension CuisineName on Cuisine {
  String get name => describeEnum(this).capitalize();
}

extension on String {
  String capitalize() {
    return toBeginningOfSentenceCase(this)!;
  }
}

extension MealTypeShortString on MealType {
  String toShortString() {
    switch (this) {
      case MealType.breakfast:
        return 'Breakfast';
      case MealType.dinner:
        return 'Dinner';
      case MealType.none:
        return 'Closed';
    }
  }
}
