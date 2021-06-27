import 'package:mockito/annotations.dart';
import 'package:multiverse/model/dining/menu.dart';
import 'package:test/test.dart';
import 'package:multiverse/repository/dining_repository.dart';
import 'package:multiverse/model/dining/dining_model.dart';
import 'package:mockito/mockito.dart';
import '../mocks/menu.dart';
import 'dining_model_test.mocks.dart';

@GenerateMocks([], customMocks: [MockSpec<DiningRepository>(returnNullOnMissingStub: true)])
void main() {
  final repository = MockDiningRepository();
  const mealType = MealType.dinner;
  const breakfastCredits = 50;
  const dinnerCredits = 48;
  const mealLocation = 'mealLocation';

  when(repository.getCurrentMealType()).thenReturn(mealType);
  when(repository.getBreakfastCreditCount())
      .thenAnswer((_) async => breakfastCredits);
  when(repository.getDinnerCreditCount())
      .thenAnswer((_) async => dinnerCredits);
  when(repository.getMealLocation()).thenAnswer((_) async => mealLocation);
  when(repository.getMenu(any, any)).thenAnswer((_) async => sampleMenu);

  group('Dining model updates correctly', () {
    test('menu date is updated', () {
      final diningModel = DiningModel(repository);
      final now = DateTime(2021, 1, 1);
      diningModel.setMenuDate(now);
      expect(diningModel.menuDate, now);
    });

    test('breakfast credit count is updated', () async {
      final diningModel = DiningModel(repository);
      await diningModel.update();
      expect(diningModel.breakfastCreditCount, breakfastCredits);
    });

    test('dinner credit count is updated', () async {
      final diningModel = DiningModel(repository);
      await diningModel.update();
      expect(diningModel.dinnerCreditCount, dinnerCredits);
    });

    test('meal location is updated', () async {
      final diningModel = DiningModel(repository);
      await diningModel.update();
      expect(diningModel.mealLocation, mealLocation);
    });

    test('current meal type is updated', () async {
      final diningModel = DiningModel(repository);
      await diningModel.update();
      expect(diningModel.currentMealType, mealType);
    });

    group('cardSubtitle getter', () {
      test('returns "... credits" when currentMealType = breakfast', () async {
        final mockRepository = MockDiningRepository();
        when(mockRepository.getCurrentMealType()).thenReturn(MealType.breakfast);
        when(mockRepository.getBreakfastCreditCount())
            .thenAnswer((_) async => breakfastCredits);
        when(mockRepository.getDinnerCreditCount())
            .thenAnswer((_) async => dinnerCredits);
        when(mockRepository.getMealLocation()).thenAnswer((_) async => mealLocation);
        when(mockRepository.getMenu(any, any)).thenAnswer((_) async => sampleMenu);
        final diningModel = DiningModel(mockRepository);
        await diningModel.update();
        expect(diningModel.cardSubtitle, '$breakfastCredits credits');
      });
      test('returns "... credits" when currentMealType = dinner', () async {
        final mockRepository = MockDiningRepository();
        when(mockRepository.getCurrentMealType()).thenReturn(MealType.dinner);
        when(mockRepository.getBreakfastCreditCount())
            .thenAnswer((_) async => breakfastCredits);
        when(mockRepository.getDinnerCreditCount())
            .thenAnswer((_) async => dinnerCredits);
        when(mockRepository.getMealLocation()).thenAnswer((_) async => mealLocation);
        when(mockRepository.getMenu(any, any)).thenAnswer((_) async => sampleMenu);
        final diningModel = DiningModel(mockRepository);
        await diningModel.update();
        expect(diningModel.cardSubtitle, '$dinnerCredits credits');
      });
      test('returns "Until ..." when currentMealType = none', () async {
        final mockRepository = MockDiningRepository();
        when(mockRepository.getCurrentMealType()).thenReturn(MealType.none);
        when(mockRepository.getBreakfastCreditCount())
            .thenAnswer((_) async => breakfastCredits);
        when(mockRepository.getDinnerCreditCount())
            .thenAnswer((_) async => dinnerCredits);
        when(mockRepository.getMealLocation()).thenAnswer((_) async => mealLocation);
        when(mockRepository.getMenu(any, any)).thenAnswer((_) async => sampleMenu);
        final diningModel = DiningModel(mockRepository);
        await diningModel.update();
        expect(diningModel.cardSubtitle, matches(r'Until \w+'));
      });
    });
  });

  group('currentMenu getter returns the correct value', () {
    test('currentMealType = breakfast', () async {
      final mockRepository = MockDiningRepository();
      when(mockRepository.getCurrentMealType())
          .thenReturn(MealType.breakfast);
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
          .thenReturn(MealType.dinner);
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
          .thenReturn(MealType.none);
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
