//Local Files
import '../model/dining/menu.dart';

//Dining related repository which communicates with backend API to fetch dining-related data
class DiningRepository {
  String userUID;
  DiningRepository({required this.userUID});
  //Temp local data since backend is not set up
  static final FullDayMenu sampleMenu = FullDayMenu(
    breakfast: Menu([
      Meal(
        const Cuisine(0, 'Western'),
        [
          MealItem('Scrambled Egg'),
          MealItem('Honey Ham'),
          MealItem('Herb Potato'),
        ],
      ),
      Meal(
        const Cuisine(1, 'Asian'),
        [
          MealItem('Fried Ipoh Hor Fun'),
          MealItem('Nonya Curry Vegetables'),
          MealItem('Steamed Egg w/ Century Egg'),
        ],
      ),
      Meal(
        const Cuisine(2, 'Vegetarian'),
        [
          MealItem('Fried Ipoh Hor Fun'),
          MealItem('Nonya Curry Vegetables'),
          MealItem('Deep Fried Goose Skin'),
        ],
      ),
      Meal(
        const Cuisine(3, 'Malay'),
        [
          MealItem('Local Fried Mee Hoon'),
          MealItem('Penang Curry Chicken'),
          MealItem('Stir Fried Long Beans w/ Anchovies'),
        ],
      ),
    ]),
  );

  Future<FullDayMenu> getMenu(DateTime date, String location) async {
    // TODO: Fetch menu from database and parse appropriately
    // FullDayMenu menu = FullDayMenu.fromJson(data);
    return sampleMenu;
  }

  Future<int> getBreakfastCreditCount(String userUID) async {
    // TODO: Get from database
    return 50;
  }

  Future<int> getDinnerCreditCount(String userUID) async {
    // TODO: Get from database
    return 48;
  }

  Future<MealType> getCurrentMealType() async {
    return MealType.breakfast;
    // TODO
    // DateTime now = DateTime.now();
    // bool isAfterSeven = now.hour >= 7;
    // bool isBeforeTenThirty =
    //     now.hour <= 9 || (now.hour == 10 && now.minute <= 30);
    // bool isBreakfastTime = isAfterSeven && isBeforeTenThirty;
    //
    // bool isAfterFiveThirty =
    //     now.hour >= 6 || (now.hour == 5 && now.minute >= 30);
    // bool isBeforeNineThirty =
    //     now.hour <= 8 || (now.hour == 9 && now.minute <= 30);
    // bool isDinnerTime = isAfterFiveThirty && isBeforeNineThirty;
    //
    // // Breakfast served from Monday to Saturday
    // bool dayHasBreakfast = now.day != DateTime.sunday;
    //
    // // Dinner served from Sunday to Friday
    // bool dayHasDinner = now.day != DateTime.saturday;
    //
    // if (dayHasBreakfast && isBreakfastTime) {
    //   return MealType.breakfast;
    // } else if (dayHasDinner && isDinnerTime) {
    //   return MealType.dinner;
    // } else {
    //   return MealType.none;
    // }
  }

  Future<String> getMealLocation(String userUID) async {
    //TODO get from database
    return 'RVRC';
  }

  /// Redeems meal at the database. Throws an exception if failure occurs.
  Future<void> redeemMeal(
    Meal meal,
    int mealCount,
  ) async {
    // TODO
  }
}
