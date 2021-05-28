import 'package:multiverse/menu.dart';

class DiningRepository {
  static final FullDayMenu sampleMenu = FullDayMenu(
    breakfast: Menu([
      Meal(
        'Western',
        [
          MealItem('Scrambled Egg'),
          MealItem('Honey Ham'),
          MealItem('Herb Potato'),
        ],
      ),
      Meal(
        'Asian',
        [
          MealItem('Fried Ipoh Hor Fun'),
          MealItem('Nonya Curry Vegetables'),
          MealItem('Steamed Egg w/ Century Egg'),
        ],
      ),
      Meal(
        'Vegetarian',
        [
          MealItem('Fried Ipoh Hor Fun'),
          MealItem('Nonya Curry Vegetables'),
          MealItem('Deep Fried Goose Skin'),
        ],
      ),
      Meal(
        'Malay',
        [
          MealItem('Local Fried Mee Hoon'),
          MealItem('Penang Curry Chicken'),
          MealItem('Stir Fried Long Beans w/ Anchovies'),
        ],
      ),
    ]),
  );

  Future<FullDayMenu> getMenu(DateTime date) async {
    // TODO: Fetch menu from database and parse appropriately
    // FullDayMenu menu = FullDayMenu.fromJson(data);
    return sampleMenu;
  }

  Future<int> getBreakfastCreditCount() async {
    // TODO: Get from database
    return 50;
  }

  Future<int> getDinnerCreditCount() async {
    // TODO: Get from database
    return 48;
  }

  Future<MealType> getCurrentMealType() async {
    DateTime now = DateTime.now();
    bool isAfterSeven = now.hour >= 7;
    bool isBeforeTenThirty = now.hour <= 9 || (now.hour == 10 && now.minute <= 30);
    bool isBreakfastTime = isAfterSeven && isBeforeTenThirty;

    bool isAfterFiveThirty = now.hour >= 6 || (now.hour == 5 && now.minute >= 30);
    bool isBeforeNineThirty = now.hour <= 8 || (now.hour == 9 && now.minute <= 30);
    bool isDinnerTime = isAfterFiveThirty && isBeforeNineThirty;

    // Breakfast served from Monday to Saturday
    bool dayHasBreakfast = now.day != DateTime.sunday;

    // Dinner served from Sunday to Friday
    bool dayHasDinner = now.day != DateTime.saturday;

    if (dayHasBreakfast && isBreakfastTime) {
      return MealType.breakfast;
    } else if (dayHasDinner && isDinnerTime) {
      return MealType.dinner;
    } else {
      return MealType.none;
    }
  }

  Future<String> getMealLocation() async {
    return 'RVRC';
  }
}