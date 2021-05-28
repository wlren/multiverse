class FullDayMenu {
  FullDayMenu({this.breakfast, this.dinner});

  // Some days may not have breakfast/dinner
  final Menu? breakfast;
  final Menu? dinner;
}

enum MealType {
  breakfast, dinner, none
}

class Menu {
  Menu(this.meals);

  final List<Meal> meals;
}

class Meal {
  Meal(this.cuisineName, this.mealItems);

  final String cuisineName;
  final List<MealItem> mealItems;
}

class MealItem {
  MealItem(this.name);

  final String name;
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
