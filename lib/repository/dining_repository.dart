//Packages
import 'package:cloud_firestore/cloud_firestore.dart';

//Local Files
import '../model/dining/menu.dart';

//Dining related repository which communicates with backend API to fetch dining-related data
class DiningRepository {
  String userUID;
  String? location;

  DiningRepository({required this.userUID}) {
    //print(userUID);
  }

  CollectionReference diningReference =
      FirebaseFirestore.instance.collection('dining');
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

  Future<int> getBreakfastCreditCount() async {
    // TODO: Get from database
    return 50;
  }

  Future<int> getDinnerCreditCount() async {
    // TODO: Get from database
    return 48;
  }

  MealType getCurrentMealType() {
    //return MealType.breakfast;
    // TODO
    final now = DateTime.now();
    final isAfterSeven = now.hour >= 7;
    final isBeforeTenThirty =
        now.hour <= 9 || (now.hour == 10 && now.minute <= 30);
    final isBreakfastTime = isAfterSeven && isBeforeTenThirty;

    final isAfterFiveThirty =
        now.hour >= 18 || (now.hour == 17 && now.minute >= 30);
    final isBeforeNineThirty =
        now.hour <= 20 || (now.hour == 21 && now.minute <= 30);
    final isDinnerTime = isAfterFiveThirty && isBeforeNineThirty;

    // Breakfast served from Monday to Saturday
    final dayHasBreakfast = now.day != DateTime.sunday;

    // Dinner served from Sunday to Friday
    final dayHasDinner = now.day != DateTime.saturday;

    if (dayHasBreakfast && isBreakfastTime) {
      return MealType.breakfast;
    } else if (dayHasDinner && isDinnerTime) {
      return MealType.dinner;
    } else {
      return MealType.none;
    }
  }

  Future<String> getMealLocation() async {
    if (location == null) {
      final studentData = await diningReference
          .doc('students')
          .collection(userUID)
          .doc('info')
          .get();
      final data = studentData.data() as Map<String, dynamic>;
      location = data['hostel'] as String;
      return data['hostel'] as String;
    }
    return location!;
  }

  /// Redeems meal at the database. Throws an exception if failure occurs.
  Future<void> redeemMeal(
    Meal meal,
    int mealCount,
  ) async {
    // TODO
  }
}
