import 'package:flutter/material.dart';
import 'package:multiverse/dining_repository.dart';
import 'package:multiverse/menu.dart';

class DiningModel extends ChangeNotifier {
  DiningModel(this.diningRepository) {
    update();
  }

  final DiningRepository diningRepository;

  FullDayMenu menu = FullDayMenu();
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