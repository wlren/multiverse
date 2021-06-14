import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:multiverse/menu.dart';
import 'package:multiverse/screens/dashboard_screen.dart';
import 'package:multiverse/screens/dining_screen.dart';
import 'package:multiverse/screens/green_pass_screen.dart';
import 'package:multiverse/screens/nus_card_screen.dart';
import 'package:multiverse/view_model/dining_model.dart';
import 'package:multiverse/view_model/user_model.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';

import 'dashboard_screen_test.mocks.dart';

@GenerateMocks([
  UserModel
], customMocks: [
  MockSpec<NavigatorObserver>(returnNullOnMissingStub: true),
  MockSpec<DiningModel>(returnNullOnMissingStub: true),
])
void main() {
  final MockUserModel mockUserModel = MockUserModel();
  when(mockUserModel.isTemperatureAcceptable).thenReturn(true);

  final MockDiningModel mockDiningModel = MockDiningModel();
  const int breakfastCredits = 20;
  const int dinnerCredits = 30;
  const int totalCredits = 20 + 30;
  when(mockDiningModel.currentMealType).thenReturn(MealType.breakfast);
  when(mockDiningModel.breakfastCreditCount).thenReturn(breakfastCredits);
  when(mockDiningModel.dinnerCreditCount).thenReturn(dinnerCredits);
  when(mockDiningModel.totalCreditCount).thenReturn(totalCredits);
  when(mockDiningModel.menu).thenReturn(FullDayMenu());

  group('App bar', () {
    testWidgets('is present', (WidgetTester tester) async {
      await tester.pumpAndSettleScreen(
          mockUserModel, mockDiningModel, const DashboardScreen());
      // App bar is present
      expect(find.byType(AppBar), findsOneWidget);
    });
    testWidgets('has title', (WidgetTester tester) async {
      await tester.pumpAndSettleScreen(
          mockUserModel, mockDiningModel, const DashboardScreen());
      // App title is present
      expect(find.text('multiverse'), findsOneWidget);
    });
    testWidgets('has icon', (WidgetTester tester) async {
      await tester.pumpAndSettleScreen(
          mockUserModel, mockDiningModel, const DashboardScreen());
      expect(find.bySemanticsLabel('multiverse logo'), findsOneWidget);
    });
  });

  group('Green pass card', () {
    group('Temperature not declared', () {
      final MockUserModel unacceptableModel = MockUserModel();
      when(unacceptableModel.isTemperatureAcceptable).thenReturn(false);

      testWidgets('shows correct declaration state',
          (WidgetTester tester) async {
        final MockNavigatorObserver mockObserver = MockNavigatorObserver();
        await tester.pumpAndSettleScreen(
            unacceptableModel, mockDiningModel, const DashboardScreen(),
            navigatorObservers: [mockObserver]);

        expect(find.text('Declare temperature first'), findsOneWidget);
        expect(find.text('Temperature declared'), findsNothing);
        expect(find.text('View Green Pass'), findsOneWidget);
      });
      testWidgets('is disabled and does not launch green pass screen',
          (WidgetTester tester) async {
        final MockNavigatorObserver mockObserver = MockNavigatorObserver();
        await tester.pumpAndSettleScreen(
            unacceptableModel, mockDiningModel, const DashboardScreen(),
            navigatorObservers: [mockObserver]);

        // Expect that button does not launch green pass screen
        await tester.tap(find.text('View Green Pass'));
        await tester.pumpAndSettle();
        expect(find.byType(GreenPassScreen), findsNothing);
      });
    });

    group('Temperature acceptable', () {
      final MockUserModel acceptableModel = MockUserModel();
      when(acceptableModel.isTemperatureAcceptable).thenReturn(true);

      testWidgets('shows correct declaration state',
          (WidgetTester tester) async {
        final MockNavigatorObserver mockObserver = MockNavigatorObserver();
        await tester.pumpAndSettleScreen(
            acceptableModel, mockDiningModel, const DashboardScreen(),
            navigatorObservers: [mockObserver]);

        expect(find.text('Declare temperature first'), findsNothing);
        expect(find.text('Temperature declared'), findsOneWidget);
      });
      testWidgets('is enabled and launches correct screen on tap',
          (WidgetTester tester) async {
        final MockNavigatorObserver mockObserver = MockNavigatorObserver();
        await tester.pumpAndSettleScreen(
            acceptableModel, mockDiningModel, const DashboardScreen(),
            navigatorObservers: [mockObserver]);
        expect(find.text('View Green Pass'), findsOneWidget);

        // Expect that button is enabled
        await tester.tap(find.text('View Green Pass'));
        await tester.pumpAndSettle();

        // Verify that screen is launched
        verify(mockObserver.didPush(any, any));
        expect(find.byType(GreenPassScreen), findsOneWidget);
      });
    });
  });

  group('Dining card', () {
    testWidgets('Icon is shown', (WidgetTester tester) async {
      await tester.pumpAndSettleScreen(
          mockUserModel, mockDiningModel, const DashboardScreen());
      expect(find.byIcon(Icons.lunch_dining), findsOneWidget);
    });
    group('Meal type is shown and matches dining model', () {
      testWidgets('Breakfast', (WidgetTester tester) async {
        final DiningModel breakfastModel = MockDiningModel();
        when(breakfastModel.currentMealType).thenReturn(MealType.breakfast);
        await tester.pumpAndSettleScreen(
            mockUserModel, breakfastModel, const DashboardScreen());
        expect(find.text('Breakfast'), findsOneWidget);
      });
      testWidgets('Dinner', (WidgetTester tester) async {
        final DiningModel dinnerModel = MockDiningModel();
        when(dinnerModel.currentMealType).thenReturn(MealType.dinner);
        await tester.pumpAndSettleScreen(
            mockUserModel, dinnerModel, const DashboardScreen());
        expect(find.text('Dinner'), findsOneWidget);
      });
      testWidgets('No meal', (WidgetTester tester) async {
        final DiningModel noneModel = MockDiningModel();
        when(noneModel.currentMealType).thenReturn(MealType.none);
        await tester.pumpAndSettleScreen(
            mockUserModel, noneModel, const DashboardScreen());
        expect(find.text('Closed'), findsOneWidget);
      });
    });

    testWidgets('Total credits are shown and match dining model',
        (WidgetTester tester) async {
      await tester.pumpAndSettleScreen(
          mockUserModel, mockDiningModel, const DashboardScreen());
      expect(find.text('$totalCredits credits'), findsOneWidget);
    });

    testWidgets('Launches dining screen on tap', (WidgetTester tester) async {
      final MockNavigatorObserver mockObserver = MockNavigatorObserver();
      await tester.pumpAndSettleScreen(
          mockUserModel, mockDiningModel, const DashboardScreen(),
          navigatorObservers: [mockObserver]);

      await tester.tap(find.byIcon(Icons.lunch_dining));
      await tester.pumpAndSettle();

      verify(mockObserver.didPush(any, any));
      expect(find.byType(DiningScreen), findsOneWidget);
    });
  });

  group('NUS Card card', () {
    testWidgets('Shown correctly', (WidgetTester tester) async {
      await tester.pumpAndSettleScreen(
          mockUserModel, mockDiningModel, const DashboardScreen());
      expect(find.text('NUS Card'), findsOneWidget);
      expect(find.text('View details'), findsOneWidget);
    });

    testWidgets('Launches NUS Card screen on tap', (WidgetTester tester) async {
      final MockNavigatorObserver mockObserver = MockNavigatorObserver();
      await tester.pumpAndSettleScreen(
          mockUserModel, mockDiningModel, const DashboardScreen(),
          navigatorObservers: [mockObserver]);

      expect(find.text('NUS Card'), findsOneWidget);
      await tester.tap(find.text('NUS Card'));
      await tester.pumpAndSettle();

      verify(mockObserver.didPush(any, any));
      expect(find.byType(NUSCardScreen), findsOneWidget);
    });
  });
}

// A short hand method to truncate repeated calls
extension _PumpAndSettleScreen on WidgetTester {
  Future<void> pumpAndSettleScreen(
      UserModel userModel, DiningModel diningModel, Widget screen,
      {List<NavigatorObserver>? navigatorObservers}) async {
    await pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider<UserModel>(create: (context) => userModel),
        ChangeNotifierProvider<DiningModel>(create: (context) => diningModel),
      ],
      child: MaterialApp(
        home: const DashboardScreen(),
        navigatorObservers: navigatorObservers ?? [],
      ),
    ));
    await pumpAndSettle();
  }
}
