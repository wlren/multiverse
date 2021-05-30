class FullDayMenu {
  // Some days may not have breakfast/dinner
  final Menu? breakfast;
  final Menu? dinner;

  FullDayMenu({this.breakfast, this.dinner});
}

class Menu {
  final List<Meal> meals;

  Menu(this.meals);
}

class Meal {
  final String cuisineName;
  final List<MealItem> mealItems;

  Meal(this.cuisineName, this.mealItems);
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
