//Packages
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//Local Files
import '../model/dining/menu.dart';

//Dining related repository which communicates with backend API to fetch dining-related data
class DiningRepository {
  String userId;
  String? location;
  int? currentBreakfastCredit;
  int? currentDinnerCredit;

  DiningRepository({required this.userId}) {
    //print(userId);
    // redeemMeal(
    //     Meal(
    //       const Cuisine(1, 'western'),
    //       [],
    //     ),
    //     2);
  }

  CollectionReference diningReference =
      FirebaseFirestore.instance.collection('dining');
  //Temp local data since backend is not set up
  static final FullDayMenu sampleMenu = FullDayMenu(
    breakfast: Menu([
      Meal(
        Cuisine.western,
        [
          MealItem('Scrambled Egg'),
          MealItem('Honey Ham'),
          MealItem('Herb Potato'),
        ],
      ),
      Meal(
        Cuisine.asian,
        [
          MealItem('Fried Ipoh Hor Fun'),
          MealItem('Nonya Curry Vegetables'),
          MealItem('Steamed Egg w/ Century Egg'),
        ],
      ),
      Meal(
        Cuisine.vegetarian,
        [
          MealItem('Fried Ipoh Hor Fun'),
          MealItem('Nonya Curry Vegetables'),
          MealItem('Deep Fried Goose Skin'),
        ],
      ),
      Meal(
        Cuisine.malay,
        [
          MealItem('Local Fried Mee Hoon'),
          MealItem('Penang Curry Chicken'),
          MealItem('Stir Fried Long Beans w/ Anchovies'),
        ],
      ),
    ]),
  );

  Future<FullDayMenu> getMenu(DateTime date, String location) async {
    final day = weekDayAsString(date);
    final menuReference =
        await diningReference.doc('menu').collection(location).doc(day).get();
    final mealDict = menuReference.data() as Map<String, dynamic>;
    return FullDayMenu.fromMap(mealDict);
  }

  Future<int> getBreakfastCreditCount() async {
    final studentData = await diningReference
        .doc('students')
        .collection(userId)
        .doc('info')
        .get();
    final data = studentData.data() as Map<String, dynamic>;
    currentBreakfastCredit = data['breakfast'] as int;
    return currentBreakfastCredit!;
  }

  Future<int> getDinnerCreditCount() async {
    final studentData = await diningReference
        .doc('students')
        .collection(userId)
        .doc('info')
        .get();
    final data = studentData.data() as Map<String, dynamic>;
    currentDinnerCredit = data['dinner'] as int;
    return currentDinnerCredit!;
  }

  MealType getCurrentMealType() {
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
          .collection(userId)
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
    if (getCurrentMealType() == MealType.breakfast) {
      currentBreakfastCredit ?? await getBreakfastCreditCount();
      if (currentBreakfastCredit! >= mealCount) {
        await diningReference
            .doc('students')
            .collection(userId)
            .doc('info')
            .update({'breakfast': currentBreakfastCredit! - mealCount});
      }
    }
    if (getCurrentMealType() == MealType.dinner) {
      currentDinnerCredit ?? await getDinnerCreditCount();
      if (currentDinnerCredit! >= mealCount) {
        await diningReference
            .doc('students')
            .collection(userId)
            .doc('info')
            .update({'dinner': currentDinnerCredit! - mealCount});
      }
    }
    if (getCurrentMealType() == MealType.none) {
      throw Exception('No meals currently available');
    }
  }

  String weekDayAsString(DateTime date) {
    switch (date.weekday) {
      case 1:
        {
          return 'monday';
        }
      case 2:
        {
          return 'tuesday';
        }
      case 3:
        {
          return 'wednesday';
        }
      case 4:
        {
          return 'thursday';
        }
      case 5:
        {
          return 'friday';
        }
      case 6:
        {
          return 'saturday';
        }
      case 7:
        {
          return 'sunday';
        }
      default:
        {
          return 'invalid';
        }
    }
  }
}
