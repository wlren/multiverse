//Packages
import 'package:flutter/material.dart';

//Local Files
import 'menu.dart';
import '../../repository/dining_repository.dart';

class DiningModel extends ChangeNotifier {
  DiningModel(this.diningRepository) {
    update();
  }

  final DiningRepository diningRepository;

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

  String? mealLocation;
  MealType? currentMealType;

  Future<void> update() async {
    menu = await diningRepository.getMenu(menuDate);
    breakfastCreditCount = await diningRepository.getBreakfastCreditCount();
    dinnerCreditCount = await diningRepository.getDinnerCreditCount();
    mealLocation = await diningRepository.getMealLocation();
    currentMealType = await diningRepository.getCurrentMealType();
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