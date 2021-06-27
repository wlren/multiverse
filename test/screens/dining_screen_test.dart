import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:multiverse/model/dining/dining_model.dart';
import 'package:multiverse/model/dining/menu.dart';
import 'package:multiverse/screens/dining_qr_screen.dart';
import 'package:multiverse/screens/dining_screen.dart';
import 'package:provider/provider.dart';

import '../mocks/menu.dart';
import '../mocks/model_mocks.dart';
import '../mocks/model_mocks.mocks.dart';
import 'dining_screen_test.mocks.dart';

@GenerateMocks([], customMocks: [MockSpec<NavigatorObserver>(returnNullOnMissingStub: true)])
void main() {
  group('Dining menu bar should display correctly', () {
    testWidgets('Tab bar should be present with two tabs', (tester) async {
      final mockDiningModel = MockDiningModel()..stubWithDefaultValues();
      await tester.pumpWidget(ChangeNotifierProvider<DiningModel>(
        create: (_) => mockDiningModel,
        child: const MaterialApp(home: DiningScreen()),
      ));

      expect(find.byType(TabBar), findsOneWidget);
      expect(find.byType(Tab), findsNWidgets(2));
    });
    group('menu should launch with focus on correct menu', () {
      testWidgets('breakfast with proper menu', (tester) async {
        final mockDiningModel = MockDiningModel()..stubWithDefaultValues();
        when(mockDiningModel.currentMealType).thenReturn(MealType.breakfast);
        await tester.pumpWidget(ChangeNotifierProvider<DiningModel>(
          create: (_) => mockDiningModel,
          child: const MaterialApp(home: DiningScreen()),
        ));
        await tester.pumpAndSettle();
        final tabBarView = find.byType(TabBarView).first;
        final firstBreakfastItem = find.text(sampleMenu.breakfast!.meals.first.cuisine.name);
        expect(find.descendant(of: tabBarView, matching: firstBreakfastItem), findsOneWidget);
        expect(find.descendant(of: tabBarView, matching: find.text('No menu found')), findsNothing);
      });
      testWidgets('dinner with empty menu', (tester) async {
        final mockDiningModel = MockDiningModel()..stubWithDefaultValues();
        when(mockDiningModel.currentMealType).thenReturn(MealType.dinner);
        await tester.pumpWidget(ChangeNotifierProvider<DiningModel>(
          create: (_) => mockDiningModel,
          child: const MaterialApp(home: DiningScreen()),
        ));
        await tester.pumpAndSettle();
        final tabBarView = find.byType(TabBarView).first;
        final firstBreakfastItem = find.text(sampleMenu.breakfast!.meals.first.cuisine.name);
        expect(find.descendant(of: tabBarView, matching: firstBreakfastItem), findsNothing);
        expect(find.descendant(of: tabBarView, matching: find.text('No menu found')), findsOneWidget);
      });
    });
    group('app bar should show correct title', () {
      testWidgets('breakfast', (tester) async {
        final mockDiningModel = MockDiningModel()..stubWithDefaultValues();
        const mealLocation = 'mockMealLocation';
        when(mockDiningModel.currentMealType).thenReturn(MealType.breakfast);
        when(mockDiningModel.mealLocation).thenReturn(mealLocation);
        await tester.pumpWidget(ChangeNotifierProvider<DiningModel>(
          create: (_) => mockDiningModel,
          child: const MaterialApp(home: DiningScreen()),
        ));
        await tester.pumpAndSettle();
        final appBar = find.byType(SliverAppBar).first;
        expect(find.descendant(of: appBar, matching: find.text('Breakfast · $mealLocation')), findsOneWidget);
      });
      testWidgets('dinner', (tester) async {
        final mockDiningModel = MockDiningModel()..stubWithDefaultValues();
        const mealLocation = 'mockMealLocation';
        when(mockDiningModel.currentMealType).thenReturn(MealType.dinner);
        when(mockDiningModel.mealLocation).thenReturn(mealLocation);
        await tester.pumpWidget(ChangeNotifierProvider<DiningModel>(
          create: (_) => mockDiningModel,
          child: const MaterialApp(home: DiningScreen()),
        ));
        await tester.pumpAndSettle();
        final appBar = find.byType(SliverAppBar).first;
        expect(find.descendant(of: appBar, matching: find.text('Dinner · $mealLocation')), findsOneWidget);
      });
      testWidgets('none', (tester) async {
        final mockDiningModel = MockDiningModel()..stubWithDefaultValues();
        const mealLocation = 'mockMealLocation';
        when(mockDiningModel.currentMealType).thenReturn(MealType.none);
        when(mockDiningModel.mealLocation).thenReturn(mealLocation);
        await tester.pumpWidget(ChangeNotifierProvider<DiningModel>(
          create: (_) => mockDiningModel,
          child: const MaterialApp(home: DiningScreen()),
        ));
        await tester.pumpAndSettle();
        final appBar = find.byType(SliverAppBar).first;
        expect(find.descendant(of: appBar, matching: find.text('Meals closed')), findsOneWidget);
      });
    });
    testWidgets('FAB should open DiningQrScreen when currentMenu is not null', (tester) async {
      final mockDiningModel = MockDiningModel()..stubWithDefaultValues();
      when(mockDiningModel.currentMenu).thenReturn(sampleMenu.breakfast);
      final mockNavigatorObserver = MockNavigatorObserver();
      await tester.pumpWidget(ChangeNotifierProvider<DiningModel>(
        create: (_) => mockDiningModel,
        child: MaterialApp(
          home: const DiningScreen(),
          navigatorObservers: [mockNavigatorObserver],
        ),
      ));
      await tester.pumpAndSettle();

      assert(mockDiningModel.currentMenu != null);

      await tester.tap(find.byType(FloatingActionButton));

      // Cannot pump and settle as camera keeps updating frames
      await tester.pump(const Duration(seconds: 1));

      verify(mockNavigatorObserver.didPush(any, any));
      expect(find.byType(DiningQrScreen), findsOneWidget);
    });
    testWidgets('FAB should not open DiningQrScreen when currentMenu is null, snackBar with unavailability message should show', (tester) async {
      final mockDiningModel = MockDiningModel()..stubWithDefaultValues();
      when(mockDiningModel.currentMenu).thenReturn(null);
      final mockNavigatorObserver = MockNavigatorObserver();
      await tester.pumpWidget(ChangeNotifierProvider<DiningModel>(
        create: (_) => mockDiningModel,
        child: MaterialApp(
          home: const DiningScreen(),
          navigatorObservers: [mockNavigatorObserver],
        ),
      ));
      await tester.pumpAndSettle();

      assert(mockDiningModel.currentMenu == null);

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.byType(DiningQrScreen), findsNothing);
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.descendant(of: find.byType(SnackBar), matching: find.text('Meals are currently unavailable')), findsOneWidget);
    });
  });
}