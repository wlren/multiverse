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

  int? get totalCreditCount {
    if (DateTime.now().hour >= 0 && DateTime.now().hour < 12) {
      return breakfastCreditCount;
    } else if (DateTime.now().hour >= 12 && DateTime.now().hour <= 23) {
      return dinnerCreditCount;
    } else {
      return null;
    }
  }

  Future<void> update() async {
    mealLocation = await diningRepository.getMealLocation();
    menu = await diningRepository.getMenu(menuDate, mealLocation);
    breakfastCreditCount = await diningRepository.getBreakfastCreditCount();
    dinnerCreditCount = await diningRepository.getDinnerCreditCount();
    currentMealType = diningRepository.getCurrentMealType();
    notifyListeners();
    print('update');
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
