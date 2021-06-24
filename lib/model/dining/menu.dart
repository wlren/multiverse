class FullDayMenu {
  // Some days may not have breakfast/dinner
  final Menu? breakfast;
  final Menu? dinner;

  FullDayMenu({this.breakfast, this.dinner});
}

class Menu {
  late final List<Meal> meals;

  Menu(List<Meal> meals) {
    assert(meals.map((meal) => meal.cuisine.id).toSet().length == meals.length,
        'Meals\' cuisines must have unique ids');
    this.meals = meals.toList(growable: false);
  }

  Meal? getMealByCuisineId(int cuisineId) {
    try {
      return meals.singleWhere((meal) => meal.cuisine.id == cuisineId);
      // ignore: empty_catches
    } on StateError {
      // meal not found
    }
  }
}

class Meal {
  final Cuisine cuisine;
  final List<MealItem> mealItems;

  Meal(this.cuisine, this.mealItems);
}

class Cuisine {
  const Cuisine(this.id, this.name);
  final int id;
  final String name;
}

class MealItem {
  final String name;

  MealItem(this.name);
}

enum MealType { breakfast, dinner, none }

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
