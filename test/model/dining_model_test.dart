import 'package:mockito/annotations.dart';
import 'package:multiverse/model/dining/menu.dart';
import 'package:test/test.dart';
import 'package:multiverse/repository/dining_repository.dart';
import 'package:multiverse/model/dining/dining_model.dart';
import 'package:mockito/mockito.dart';
import '../mocks/menu.dart';
import 'dining_model_test.mocks.dart';

@GenerateMocks([DiningRepository])
void main() {
  final repository = MockDiningRepository();
  const mealType = MealType.dinner;
  const breakfastCredits = 50;
  const dinnerCredits = 48;
  const mealLocation = 'mealLocation';

  when(repository.getCurrentMealType()).thenAnswer((_) async => mealType);
  when(repository.getBreakfastCreditCount())
      .thenAnswer((_) async => breakfastCredits);
  when(repository.getDinnerCreditCount())
      .thenAnswer((_) async => dinnerCredits);
  when(repository.getMealLocation()).thenAnswer((_) async => mealLocation);
  when(repository.getMenu(any, any)).thenAnswer((_) async => sampleMenu);

  group('Dining model should update properly', () {
    test('menu date should be updated', () {
      final diningModel = DiningModel(repository);
      final now = DateTime(2021, 1, 1);
      diningModel.setMenuDate(now);
      expect(diningModel.menuDate, now);
    });

    test('breakfast credit count should be updated', () async {
      final diningModel = DiningModel(repository);
      await diningModel.update();
      expect(diningModel.breakfastCreditCount, breakfastCredits);
    });

    test('dinner credit count should be updated', () async {
      final diningModel = DiningModel(repository);
      await diningModel.update();
      expect(diningModel.dinnerCreditCount, dinnerCredits);
    });

    test('meal location should be updated', () async {
      final diningModel = DiningModel(repository);
      await diningModel.update();
      expect(diningModel.mealLocation, mealLocation);
    });

    test('current meal type should be updated', () async {
      final diningModel = DiningModel(repository);
      await diningModel.update();
      expect(diningModel.currentMealType, mealType);
    });

    test('currentMenu getter should return the correct value', () async {
      final diningModel = DiningModel(repository);
      await diningModel.update();
      expect(diningModel.totalCreditCount, breakfastCredits + dinnerCredits);
    });
  });

  group('currentMenu getter should return the correct value', () {
    test('currentMealType = breakfast', () async {
      final mockRepository = MockDiningRepository();
      when(mockRepository.getCurrentMealType())
          .thenAnswer((_) async => MealType.breakfast);
      when(mockRepository.getBreakfastCreditCount())
          .thenAnswer((_) async => breakfastCredits);
      when(mockRepository.getDinnerCreditCount())
          .thenAnswer((_) async => dinnerCredits);
      when(mockRepository.getMealLocation())
          .thenAnswer((_) async => mealLocation);
      when(mockRepository.getMenu(any, any))
          .thenAnswer((_) async => sampleMenu);

      final diningModel = DiningModel(mockRepository);
      await diningModel.update();
      expect(diningModel.currentMenu, sampleMenu.breakfast);
    });

    test('currentMealType = dinner', () async {
      final mockRepository = MockDiningRepository();
      when(mockRepository.getCurrentMealType())
          .thenAnswer((_) async => MealType.dinner);
      when(mockRepository.getBreakfastCreditCount())
          .thenAnswer((_) async => breakfastCredits);
      when(mockRepository.getDinnerCreditCount())
          .thenAnswer((_) async => dinnerCredits);
      when(mockRepository.getMealLocation())
          .thenAnswer((_) async => mealLocation);
      when(mockRepository.getMenu(any, any))
          .thenAnswer((_) async => sampleMenu);

      final diningModel = DiningModel(mockRepository);
      await diningModel.update();
      expect(diningModel.currentMenu, sampleMenu.dinner);
    });

    test('currentMealType = none', () async {
      final mockRepository = MockDiningRepository();
      when(mockRepository.getCurrentMealType())
          .thenAnswer((_) async => MealType.none);
      when(mockRepository.getBreakfastCreditCount())
          .thenAnswer((_) async => breakfastCredits);
      when(mockRepository.getDinnerCreditCount())
          .thenAnswer((_) async => dinnerCredits);
      when(mockRepository.getMealLocation())
          .thenAnswer((_) async => mealLocation);
      when(mockRepository.getMenu(any, any))
          .thenAnswer((_) async => sampleMenu);

      final diningModel = DiningModel(mockRepository);
      await diningModel.update();
      expect(diningModel.currentMenu, null);
    });
  });
}
