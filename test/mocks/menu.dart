import 'package:multiverse/model/dining/menu.dart';

final FullDayMenu sampleMenu = FullDayMenu(
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