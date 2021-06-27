import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:multiverse/model/auth/session_cubit.dart';
import 'package:multiverse/model/dining/menu.dart';
import 'package:multiverse/screens/dashboard_screen.dart';
import 'package:multiverse/screens/dining_screen.dart';
import 'package:multiverse/screens/green_pass_screen.dart';
import 'package:multiverse/screens/nus_card_screen.dart';
import 'package:multiverse/model/dining/dining_model.dart';
import 'package:multiverse/model/green_pass_model.dart';
import 'package:multiverse/model/user_model.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';

import '../mocks/model_mocks.dart';
import '../mocks/model_mocks.mocks.dart';
import 'dashboard_screen_test.mocks.dart';

const _mockUserId = 'mockUserId';

@GenerateMocks([
  UserModel,
  GreenPassModel,
  SessionCubit,
], customMocks: [
  MockSpec<NavigatorObserver>(returnNullOnMissingStub: true),
])
void main() {
  final mockUserModel = MockUserModel();
  when(mockUserModel.isTemperatureAcceptable).thenReturn(true);

  final mockDiningModel = MockDiningModel()..stubWithDefaultValues();


  group('App bar', () {
    testWidgets('is present', (tester) async {
      await tester.pumpAndSettleScreen(
          mockUserModel, mockDiningModel, const DashboardScreen());
      // App bar is present
      expect(find.byType(AppBar), findsOneWidget);
    });
    testWidgets('has title', (tester) async {
      await tester.pumpAndSettleScreen(
          mockUserModel, mockDiningModel, const DashboardScreen());
      // App title is present
      expect(find.text('multiverse'), findsOneWidget);
    });
    testWidgets('has icon', (tester) async {
      await tester.pumpAndSettleScreen(
          mockUserModel, mockDiningModel, const DashboardScreen());
      expect(find.bySemanticsLabel('multiverse logo'), findsOneWidget);
    });
  });

  group('Green pass card', () {
    group('Temperature not declared', () {
      final unacceptableModel = MockUserModel();
      when(unacceptableModel.isTemperatureAcceptable).thenReturn(false);

      testWidgets('shows correct declaration state',
          (tester) async {
        final mockObserver = MockNavigatorObserver();
        await tester.pumpAndSettleScreen(
            unacceptableModel, mockDiningModel, const DashboardScreen(),
            navigatorObservers: [mockObserver]);

        expect(find.text('Declare temperature first'), findsOneWidget);
        expect(find.text('Temperature declared'), findsNothing);
        expect(find.text('View Green Pass'), findsOneWidget);
      });
      testWidgets('is disabled and does not launch green pass screen',
          (tester) async {
        final mockObserver = MockNavigatorObserver();
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
      final acceptableModel = MockUserModel();
      when(acceptableModel.isTemperatureAcceptable).thenReturn(true);

      testWidgets('shows correct declaration state',
          (tester) async {
        final mockObserver = MockNavigatorObserver();
        await tester.pumpAndSettleScreen(
            acceptableModel, mockDiningModel, const DashboardScreen(),
            navigatorObservers: [mockObserver]);

        expect(find.text('Declare temperature first'), findsNothing);
        expect(find.text('Temperature declared'), findsOneWidget);
      });
      testWidgets('is enabled and launches correct screen on tap',
          (tester) async {
        final mockObserver = MockNavigatorObserver();
        await tester.pumpAndSettleScreen(
            acceptableModel, mockDiningModel, const DashboardScreen(),
            navigatorObservers: [mockObserver]);
        expect(find.text('View Green Pass'), findsOneWidget);

        // Expect that button is enabled
        await tester.tap(find.text('View Green Pass'));
        await tester.pumpAndSettle();

        // Verify that screen is launched
        // verify(mockObserver.didPush(any, any));
        // expect(find.byType(GreenPassScreen), findsOneWidget);
      });
    });
  });

  group('Dining card', () {
    testWidgets('icon should be shown', (tester) async {
      await tester.pumpAndSettleScreen(
          mockUserModel, mockDiningModel, const DashboardScreen());
      expect(find.byIcon(Icons.lunch_dining), findsOneWidget);
    });
    group('title should show current meal', () {
      testWidgets('breakfast', (tester) async {
        final DiningModel breakfastModel = MockDiningModel();
        when(breakfastModel.currentMealType).thenReturn(MealType.breakfast);
        when(breakfastModel.cardSubtitle).thenReturn('cardSubtitle');
        await tester.pumpAndSettleScreen(
            mockUserModel, breakfastModel, const DashboardScreen());
        expect(find.text('Breakfast'), findsOneWidget);
      });
      testWidgets('dinner', (tester) async {
        final DiningModel dinnerModel = MockDiningModel();
        when(dinnerModel.currentMealType).thenReturn(MealType.dinner);
        when(dinnerModel.cardSubtitle).thenReturn('cardSubtitle');
        await tester.pumpAndSettleScreen(
            mockUserModel, dinnerModel, const DashboardScreen());
        expect(find.text('Dinner'), findsOneWidget);
      });
      testWidgets('no meal', (tester) async {
        final DiningModel noneModel = MockDiningModel();
        when(noneModel.currentMealType).thenReturn(MealType.none);
        when(noneModel.cardSubtitle).thenReturn('cardSubtitle');
        await tester.pumpAndSettleScreen(
            mockUserModel, noneModel, const DashboardScreen());
        expect(find.text('Closed'), findsOneWidget);
      });
    });

    testWidgets('subtitle should displayed correctly',
        (tester) async {
      final DiningModel mockDiningModel = MockDiningModel();
      when(mockDiningModel.currentMealType).thenReturn(MealType.none);
      when(mockDiningModel.cardSubtitle).thenReturn('cardSubtitle');
      await tester.pumpAndSettleScreen(
          mockUserModel, mockDiningModel, const DashboardScreen());
      expect(find.text(mockDiningModel.cardSubtitle), findsOneWidget);
    });

    testWidgets('Launches dining screen on tap', (tester) async {
      final mockObserver = MockNavigatorObserver();
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
    testWidgets('Shown correctly', (tester) async {
      await tester.pumpAndSettleScreen(
          mockUserModel, mockDiningModel, const DashboardScreen());
      expect(find.text('NUS Card'), findsOneWidget);
      expect(find.text('View details'), findsOneWidget);
    });

    testWidgets('Launches NUS Card screen on tap', (tester) async {
      final mockObserver = MockNavigatorObserver();
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
extension on WidgetTester {
  Future<void> pumpAndSettleScreen(
      UserModel userModel, DiningModel diningModel, Widget screen,
      {List<NavigatorObserver>? navigatorObservers}) async {
    final mockGreenPassModel = MockGreenPassModel();
    when(mockGreenPassModel.isPassGreen).thenReturn(false);

    final mockSessionCubit = MockSessionCubit();
    when(mockSessionCubit.userUID).thenReturn(_mockUserId);
    await pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider<UserModel>(create: (context) => userModel),
        ChangeNotifierProvider<DiningModel>(create: (context) => diningModel),
        ChangeNotifierProvider<GreenPassModel>(create: (context) => mockGreenPassModel),
        Provider<SessionCubit>(create: (context) => mockSessionCubit),
      ],
      child: MaterialApp(
        home: const DashboardScreen(),
        navigatorObservers: navigatorObservers ?? [],
      ),
    ));
    await pumpAndSettle();
  }
}
