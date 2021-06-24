import 'package:flutter/material.dart';

import '../model/dining/menu.dart';

class DiningMealScreen extends StatelessWidget {
  const DiningMealScreen(this.meal, {Key? key}) : super(key: key);

  final Meal meal;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(meal.cuisine.name),
      ),
    );
  }
}
