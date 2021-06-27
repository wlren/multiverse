import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:multiverse/model/dining/dining_model.dart';
import 'package:multiverse/model/dining/menu.dart';

import 'menu.dart';
import 'model_mocks.mocks.dart';

@GenerateMocks([],
    customMocks: [MockSpec<DiningModel>(returnNullOnMissingStub: true)])
class DefaultMocks {}

extension MockDiningModelDefaultStub on MockDiningModel {
  void stubWithDefaultValues() {
    const breakfastCredits = 20;
    const dinnerCredits = 30;
    when(currentMealType).thenReturn(MealType.breakfast);
    when(breakfastCreditCount).thenReturn(breakfastCredits);
    when(dinnerCreditCount).thenReturn(dinnerCredits);
    when(cardSubtitle).thenReturn('$breakfastCredits credits');
    when(menu).thenReturn(sampleMenu);
    when(mealLocation).thenReturn('mealLocation');
  }
}
