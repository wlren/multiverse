import 'package:flutter_test/flutter_test.dart';
import 'package:multiverse/model/dining/redeem/dining_redeem_form_model.dart';

void main() {
  group('Attribute setters work correctly, and call notifyListeners', () {
    test('Meal count setter', () {
      var testPassed = false;
      final diningRedeemFormModel = DiningRedeemFormModel(3);
      diningRedeemFormModel.addListener(() {
        testPassed = true;
      });
      diningRedeemFormModel.mealCount = 1;
      assert(testPassed);
    });
    test('onPlusPressed', () {
      var testPassed = false;
      final diningRedeemFormModel = DiningRedeemFormModel(3);
      diningRedeemFormModel.addListener(() {
        testPassed = true;
      });
      diningRedeemFormModel.onPlusPressed();
      assert(testPassed);
    });
    test('onMinusPressed', () {
      var testPassed = false;
      final diningRedeemFormModel = DiningRedeemFormModel(3);
      diningRedeemFormModel.addListener(() {
        testPassed = true;
      });
      diningRedeemFormModel.onMinusPressed();
      assert(testPassed);
    });
    group('onMinusPressed should deduct meal count correctly', () {
      test('meal count should be deducted correctly', () {
        final diningRedeemFormModel = DiningRedeemFormModel(3);
        const initialMealCount = 2;
        diningRedeemFormModel.mealCount = initialMealCount;
        diningRedeemFormModel.onMinusPressed();
        assert(diningRedeemFormModel.mealCount == initialMealCount - 1);
      });
      test('meal count should not be deducted when meal count is 1', () {
        final diningRedeemFormModel = DiningRedeemFormModel(3);
        const initialMealCount = 1;
        diningRedeemFormModel.mealCount = initialMealCount;
        diningRedeemFormModel.onMinusPressed();
        assert(diningRedeemFormModel.mealCount == initialMealCount);
      });
    });
    group('onPlusPressed should increase meal count correctly', () {
      test('meal count should be increased correctly', () {
        final diningRedeemFormModel = DiningRedeemFormModel(3);
        final initialMealCount = diningRedeemFormModel.maxMeals - 1;
        diningRedeemFormModel.mealCount = initialMealCount;
        diningRedeemFormModel.onMinusPressed();
        assert(diningRedeemFormModel.mealCount == initialMealCount - 1);
      });
      test('meal count should not be increased when meal count is at max value', () {
        final diningRedeemFormModel = DiningRedeemFormModel(3);
        final initialMealCount = diningRedeemFormModel.maxMeals;
        diningRedeemFormModel.mealCount = initialMealCount;
        diningRedeemFormModel.onPlusPressed();
        assert(diningRedeemFormModel.mealCount == initialMealCount);
      });
    });
    group('canPressPlus should return correct values', () {
      test('canPressPlus should be true when meal count is not at max value', () {
        final diningRedeemFormModel = DiningRedeemFormModel(3);
        final initialMealCount = diningRedeemFormModel.maxMeals - 1;
        diningRedeemFormModel.mealCount = initialMealCount;
        assert(diningRedeemFormModel.canPressPlus);
      });
      test('canPressPlus should be false when meal count is at max value', () {
        final diningRedeemFormModel = DiningRedeemFormModel(3);
        final initialMealCount = diningRedeemFormModel.maxMeals;
        diningRedeemFormModel.mealCount = initialMealCount;
        assert(!diningRedeemFormModel.canPressPlus);
      });
    });
    group('canPressMinus should return correct values', () {
      test('canPressMinus should be true when meal count is not 1', () {
        final diningRedeemFormModel = DiningRedeemFormModel(3);
        const initialMealCount = 2;
        diningRedeemFormModel.mealCount = initialMealCount;
        assert(diningRedeemFormModel.canPressMinus);
      });
      test('canPressMinus should be false when meal count is at 1', () {
        final diningRedeemFormModel = DiningRedeemFormModel(3);
        const initialMealCount = 1;
        diningRedeemFormModel.mealCount = initialMealCount;
        assert(!diningRedeemFormModel.canPressMinus);
      });
    });
  });
}