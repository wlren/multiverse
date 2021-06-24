import 'package:flutter/material.dart';

class DiningRedeemFormModel extends ChangeNotifier {
  DiningRedeemFormModel(this.maxMeals): assert(maxMeals >= 1);
  final int maxMeals;

  int get mealCount => _mealCount;
  set mealCount(int value) {
    _mealCount = value;
    notifyListeners();
  }

  bool get canPressPlus => mealCount < maxMeals;
  bool get canPressMinus => mealCount > 1;

  void onPlusPressed() {
    mealCount = (mealCount + 1).clamp(1, maxMeals);
  }

  void onMinusPressed() {
    mealCount = (mealCount - 1).clamp(1, maxMeals);
  }

  int _mealCount = 1;
}