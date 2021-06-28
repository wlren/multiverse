//Packages
import 'package:flutter/material.dart';

//Local Files
import '../../repository/dining_repository.dart';
import 'menu.dart';

class DiningModel extends ChangeNotifier {
  final DiningRepository diningRepository;
  DiningModel(this.diningRepository) {
    update();
  }

  late String mealLocation;
  MealType? currentMealType;

  FullDayMenu menu = FullDayMenu();
  Menu? get currentMenu => menu.getMenuOfType(currentMealType);

  DateTime menuDate = DateTime.now();
  int? breakfastCreditCount;
  int? dinnerCreditCount;

  int? get _creditCount {
    switch (currentMealType) {
      case MealType.breakfast:
        return breakfastCreditCount;
      case MealType.dinner:
        return dinnerCreditCount;
      default:
        return null;
    }
  }

  String get cardSubtitle {
    // TODO: Calculate the "until" time
    return _creditCount != null ? '$_creditCount credits' : 'Until 10:30pm';
  }

  Future<void> update() async {
    mealLocation = await diningRepository.getMealLocation();
    menu = await diningRepository.getMenu(menuDate, mealLocation);
    breakfastCreditCount = await diningRepository.getBreakfastCreditCount();
    dinnerCreditCount = await diningRepository.getDinnerCreditCount();
    currentMealType = diningRepository.getCurrentMealType();
    notifyListeners();
  }

  Future<void> setMenuDate(DateTime date) async {
    menuDate = date;
    update();
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
