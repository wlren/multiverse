import 'package:multiverse/model/dining/menu.dart';

final FullDayMenu sampleMenu = FullDayMenu(
  breakfast: Menu([
    Meal(
      Cuisine.western,
      [
        MealItem('Scrambled Egg'),
        MealItem('Honey Ham'),
        MealItem('Herb Potato'),
      ],
    ),
    Meal(
      Cuisine.asian,
      [
        MealItem('Fried Ipoh Hor Fun'),
        MealItem('Nonya Curry Vegetables'),
        MealItem('Steamed Egg w/ Century Egg'),
      ],
    ),
    Meal(
      Cuisine.vegetarian,
      [
        MealItem('Fried Ipoh Hor Fun'),
        MealItem('Nonya Curry Vegetables'),
        MealItem('Deep Fried Goose Skin'),
      ],
    ),
    Meal(
      Cuisine.malay,
      [
        MealItem('Local Fried Mee Hoon'),
        MealItem('Penang Curry Chicken'),
        MealItem('Stir Fried Long Beans w/ Anchovies'),
      ],
    ),
  ]),
);
