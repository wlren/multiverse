import 'package:mockito/annotations.dart';
import 'package:multiverse/menu.dart';
import 'package:test/test.dart';
import 'package:multiverse/dining_repository.dart';
import 'package:multiverse/view_model/dining_model.dart';
import 'package:mockito/mockito.dart';
import 'dining_model_test.mocks.dart';

final FullDayMenu sampleMenu = FullDayMenu(
  breakfast: Menu([
    Meal(
      'Western',
      [
        MealItem('Scrambled Egg'),
        MealItem('Honey Ham'),
        MealItem('Herb Potato'),
      ],
    ),
    Meal(
      'Asian',
      [
        MealItem('Fried Ipoh Hor Fun'),
        MealItem('Nonya Curry Vegetables'),
        MealItem('Steamed Egg w/ Century Egg'),
      ],
    ),
    Meal(
      'Vegetarian',
      [
        MealItem('Fried Ipoh Hor Fun'),
        MealItem('Nonya Curry Vegetables'),
        MealItem('Deep Fried Goose Skin'),
      ],
    ),
    Meal(
      'Malay',
      [
        MealItem('Local Fried Mee Hoon'),
        MealItem('Penang Curry Chicken'),
        MealItem('Stir Fried Long Beans w/ Anchovies'),
      ],
    ),
  ]),
);

@GenerateMocks([DiningRepository])
void main() {
  final repository = MockDiningRepository();
  const mealType = MealType.dinner;
  const breakfastCredits = 50;
  const dinnerCredits = 48;
  const mealLocation = 'mealLocation';

  when(repository.getCurrentMealType()).thenAnswer((_) async => mealType);
  when(repository.getBreakfastCreditCount()).thenAnswer((_) async => breakfastCredits);
  when(repository.getDinnerCreditCount()).thenAnswer((_) async => dinnerCredits);
  when(repository.getMealLocation()).thenAnswer((_) async => mealLocation);
  when(repository.getMenu(captureAny)).thenAnswer((_) async => sampleMenu);

  group('Dining model', () {
    test('menu date should be updated', () {
      final DiningModel diningModel = DiningModel(repository);
      DateTime now = DateTime(2021, 1, 1);
      diningModel.setMenuDate(now);
      expect(diningModel.menuDate, now);
    });

    test('breakfast credit count should be updated', () async {
      final DiningModel diningModel = DiningModel(repository);
      await diningModel.update();
      expect(diningModel.breakfastCreditCount, breakfastCredits);
    });

    test('dinner credit count should be updated', () async {
      final DiningModel diningModel = DiningModel(repository);
      await diningModel.update();
      expect(diningModel.dinnerCreditCount, dinnerCredits);
    });

    test('meal location should be updated', () async {
      final DiningModel diningModel = DiningModel(repository);
      await diningModel.update();
      expect(diningModel.mealLocation, mealLocation);
    });

    test('current meal type should be updated', () async {
      final DiningModel diningModel = DiningModel(repository);
      await diningModel.update();
      expect(diningModel.currentMealType, mealType);
    });
  });
}