//Packages
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//Local Files
import '../model/dining/menu.dart';

//Dining related repository which communicates with backend API to fetch dining-related data
class DiningRepository {
  String userUID;
  String? location;
  int? currentBreakfastCredit;
  int? currentDinnerCredit;

  DiningRepository({required this.userUID}) {
    //print(userUID);
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
    final day = weekDayAsString(date);
    final menuReference =
        await diningReference.doc('menu').collection(location).doc(day).get();
    final mealDict = menuReference.data() as Map<String, dynamic>;
    final breakfast = mealDict['breakfast'];
    final dinner = mealDict['dinner'];
    // ignore: omit_local_variable_types
    final List<Meal> bf = [];
    // ignore: omit_local_variable_types
    final List<Meal> dinz = [];
    if (breakfast != null) {
      for (final cuisine in breakfast.keys) {
        final crusineType = CuisineType.values
            .firstWhere((element) => describeEnum(element) == cuisine);
        final newCuisine = Cuisine(crusineType.index, cuisine as String);
        final mealItems = <MealItem>[];
        for (final mealName in breakfast[cuisine]!) {
          mealItems.add(MealItem(mealName as String));
        }
        bf.add(Meal(newCuisine, mealItems));
      }
    }

    if (dinner != null) {
      for (final cuisine in dinner.keys) {
        final crusineType = CuisineType.values
            .firstWhere((element) => describeEnum(element) == cuisine);
        final newCuisine = Cuisine(crusineType.index, cuisine as String);
        final mealItems = <MealItem>[];
        for (final mealName in dinner[cuisine]!) {
          mealItems.add(MealItem(mealName as String));
        }
        dinz.add(Meal(newCuisine, mealItems));
      }
    }

    final menu = FullDayMenu(
        breakfast: bf.isEmpty ? null : Menu(bf),
        dinner: dinz.isEmpty ? null : Menu(dinz));
    return menu;
  }

  Future<int> getBreakfastCreditCount() async {
    final studentData = await diningReference
        .doc('students')
        .collection(userUID)
        .doc('info')
        .get();
    final data = studentData.data() as Map<String, dynamic>;
    currentBreakfastCredit = data['breakfast'] as int;
    return currentBreakfastCredit!;
  }

  Future<int> getDinnerCreditCount() async {
    final studentData = await diningReference
        .doc('students')
        .collection(userUID)
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
    if (getCurrentMealType() == MealType.breakfast) {
      currentBreakfastCredit ?? await getBreakfastCreditCount();
      if (currentBreakfastCredit! >= mealCount) {
        await diningReference
            .doc('students')
            .collection(userUID)
            .doc('info')
            .update({'breakfast': currentBreakfastCredit! - mealCount});
      }
    }
    if (getCurrentMealType() == MealType.dinner) {
      currentDinnerCredit ?? await getDinnerCreditCount();
      if (currentDinnerCredit! >= mealCount) {
        await diningReference
            .doc('students')
            .collection(userUID)
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
