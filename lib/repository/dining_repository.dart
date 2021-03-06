//Packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

//Local Files
import '../model/auth/user.dart';
import '../model/dining/menu.dart';

//Dining related repository which communicates with backend API to fetch dining-related data
class DiningRepository {
  AuthUser user;
  String? location;
  int? currentBreakfastCredit;
  int? currentDinnerCredit;

  DiningRepository({required this.user});

  CollectionReference diningReference =
      FirebaseFirestore.instance.collection('dining');

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
        .collection(user.id)
        .doc('info')
        .get();
    final data = studentData.data() as Map<String, dynamic>;
    currentBreakfastCredit = data['breakfast'] as int;
    return currentBreakfastCredit!;
  }

  Future<int> getDinnerCreditCount() async {
    final studentData = await diningReference
        .doc('students')
        .collection(user.id)
        .doc('info')
        .get();
    final data = studentData.data() as Map<String, dynamic>;
    currentDinnerCredit = data['dinner'] as int;
    return currentDinnerCredit!;
  }

  MealType getCurrentMealType() {
    if (!kReleaseMode) {
      // Debug mode
      return MealType.breakfast;
    }
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
          .collection(user.id)
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
            .collection(user.id)
            .doc('info')
            .update({'breakfast': currentBreakfastCredit! - mealCount});
      }
    }
    if (getCurrentMealType() == MealType.dinner) {
      currentDinnerCredit ?? await getDinnerCreditCount();
      if (currentDinnerCredit! >= mealCount) {
        await diningReference
            .doc('students')
            .collection(user.id)
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
