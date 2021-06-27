//Packages
import 'package:flutter/material.dart';

//Local Files
import '../../repository/dining_repository.dart';
import 'menu.dart';

class DiningModel extends ChangeNotifier {
  final DiningRepository diningRepository;
  DiningModel(this.diningRepository) {
    update('test');
  }

  late String mealLocation;
  MealType? currentMealType;

  FullDayMenu menu = FullDayMenu();
  Menu? get currentMenu => menu.getMenuOfType(currentMealType);

  DateTime menuDate = DateTime.now();
  int? breakfastCreditCount;
  int? dinnerCreditCount;

  int? get totalCreditCount {
    if (breakfastCreditCount != null && dinnerCreditCount != null) {
      return breakfastCreditCount! + dinnerCreditCount!;
    } else {
      return null;
    }
  }

  Future<void> update(String userUID) async {
    mealLocation = await diningRepository.getMealLocation(userUID);
    menu = await diningRepository.getMenu(menuDate, mealLocation);
    breakfastCreditCount =
        await diningRepository.getBreakfastCreditCount(userUID);
    dinnerCreditCount = await diningRepository.getDinnerCreditCount(userUID);
    currentMealType = await diningRepository.getCurrentMealType();
    notifyListeners();
  }

  Future<void> setMenuDate(DateTime date, String userUID) async {
    menuDate = date;
    update(userUID);
  }
}

extension on FullDayMenu {
  Menu? getMenuOfType(MealType? mealType) {
    if (mealType == MealType.breakfast) {
      return breakfast;
    } else if (mealType == MealType.dinner) {
      return dinner;
    }
  }
}
