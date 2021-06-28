import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:multiverse/model/auth/session_cubit.dart';
import 'package:multiverse/model/auth/user.dart';
import 'package:multiverse/model/dining/menu.dart';
import 'package:multiverse/model/temperature/temperature_model.dart';
import 'package:multiverse/model/temperature/temperature_state.dart';
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

const _mockUser = AuthUser('mockUserId');

@GenerateMocks([
  UserModel,
  GreenPassModel,
  SessionCubit,
], customMocks: [
  MockSpec<TemperatureModel>(returnNullOnMissingStub: true),
  MockSpec<NavigatorObserver>(returnNullOnMissingStub: true),
])
void main() {
  final mockUserModel = MockUserModel();
  when(mockUserModel.temperatureState).thenReturn(TemperatureState.acceptable);
  when(mockUserModel.userName).thenReturn('userName');

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
      final undeclaredModel = MockUserModel();
      when(undeclaredModel.temperatureState)
          .thenReturn(TemperatureState.undeclared);
      when(undeclaredModel.userName).thenReturn('userName');

      testWidgets('shows correct declaration state', (tester) async {
        final mockObserver = MockNavigatorObserver();
        await tester.pumpAndSettleScreen(
            undeclaredModel, mockDiningModel, const DashboardScreen(),
            navigatorObservers: [mockObserver]);

        expect(find.text('Declare temperature first'), findsOneWidget);
        expect(find.text('Temperature declared'), findsNothing);
        expect(find.text('View Green Pass'), findsOneWidget);
      });
      testWidgets('is disabled and does not launch green pass screen',
          (tester) async {
        final mockObserver = MockNavigatorObserver();
        await tester.pumpAndSettleScreen(
            undeclaredModel, mockDiningModel, const DashboardScreen(),
            navigatorObservers: [mockObserver]);

        // Expect that button does not launch green pass screen
        await tester.tap(find.text('View Green Pass'));
        await tester.pumpAndSettle();
        expect(find.byType(GreenPassScreen), findsNothing);
      });
    });
    group('Temperature acceptable', () {
      final acceptableModel = MockUserModel();
      when(acceptableModel.temperatureState)
          .thenReturn(TemperatureState.acceptable);
      when(acceptableModel.userName).thenReturn('userName');

      testWidgets('shows correct declaration state', (tester) async {
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
        verify(mockObserver.didPush(any, any));
        expect(find.byType(GreenPassScreen), findsOneWidget);
      });
    });

    group('Temperature unacceptable', () {
      final unacceptableModel = MockUserModel();
      when(unacceptableModel.temperatureState)
          .thenReturn(TemperatureState.unacceptable);
      when(unacceptableModel.userName).thenReturn('userName');

      testWidgets('shows correct declaration state', (tester) async {
        final mockObserver = MockNavigatorObserver();
        await tester.pumpAndSettleScreen(
            unacceptableModel, mockDiningModel, const DashboardScreen(),
            navigatorObservers: [mockObserver]);

        expect(find.text('Declare temperature first'), findsNothing);
        expect(find.text('Temperature unacceptable'), findsOneWidget);
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
  });

  group('Dining card', () {
    testWidgets('icon is shown', (tester) async {
      await tester.pumpAndSettleScreen(
          mockUserModel, mockDiningModel, const DashboardScreen());
      expect(find.byIcon(Icons.lunch_dining), findsOneWidget);
    });
    group('title shows current meal', () {
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

    testWidgets('subtitle is displayed correctly', (tester) async {
      final DiningModel mockDiningModel = MockDiningModel();
      when(mockDiningModel.currentMealType).thenReturn(MealType.none);
      when(mockDiningModel.cardSubtitle).thenReturn('cardSubtitle');
      await tester.pumpAndSettleScreen(
          mockUserModel, mockDiningModel, const DashboardScreen());
      expect(find.text(mockDiningModel.cardSubtitle), findsOneWidget);
    });

    testWidgets('launches dining screen with proper back navigation on tap',
        (tester) async {
      final mockObserver = MockNavigatorObserver();
      await tester.pumpAndSettleScreen(
          mockUserModel, mockDiningModel, const DashboardScreen(),
          navigatorObservers: [mockObserver]);

      await tester.tap(find.byIcon(Icons.lunch_dining));
      await tester.pumpAndSettle();

      verify(mockObserver.didPush(any, any));
      expect(find.byType(DiningScreen), findsOneWidget);

      // Verify that back navigation works
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.byType(DashboardScreen), findsOneWidget);
    });
  });

  group('NUS Card card', () {
    testWidgets('shows correctly', (tester) async {
      await tester.pumpAndSettleScreen(
          mockUserModel, mockDiningModel, const DashboardScreen());
      expect(find.text('NUS Card'), findsOneWidget);
      expect(find.text('View details'), findsOneWidget);
    });

    testWidgets('launches NUS Card screen with proper back navigation on tap',
        (tester) async {
      final mockObserver = MockNavigatorObserver();
      await tester.pumpAndSettleScreen(
          mockUserModel, mockDiningModel, const DashboardScreen(),
          navigatorObservers: [mockObserver]);

      expect(find.text('NUS Card'), findsOneWidget);
      await tester.tap(find.text('NUS Card'));
      await tester.pumpAndSettle();

      verify(mockObserver.didPush(any, any));
      expect(find.byType(NUSCardScreen), findsOneWidget);

      // Verify that back navigation works
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.byType(DashboardScreen), findsOneWidget);
    });
  });

  group('Temperature declaration button', () {
    group('shows correctly', () {
      testWidgets('when temperature is undeclared', (tester) async {
        final userModel = MockUserModel();
        when(userModel.temperatureState)
            .thenReturn(TemperatureState.undeclared);
        when(userModel.userName).thenReturn('userName');
        await tester.pumpAndSettleScreen(
            userModel, mockDiningModel, const DashboardScreen());
        expect(find.text('Undeclared'), findsOneWidget);
      });
      testWidgets('when temperature is acceptable', (tester) async {
        final userModel = MockUserModel();
        when(userModel.temperatureState)
            .thenReturn(TemperatureState.acceptable);
        when(userModel.userName).thenReturn('userName');
        await tester.pumpAndSettleScreen(
            userModel, mockDiningModel, const DashboardScreen());
        expect(find.text('Declared'), findsOneWidget);
      });
      testWidgets('when temperature is unacceptable', (tester) async {
        final userModel = MockUserModel();
        when(userModel.temperatureState)
            .thenReturn(TemperatureState.unacceptable);
        when(userModel.userName).thenReturn('userName');
        await tester.pumpAndSettleScreen(
            userModel, mockDiningModel, const DashboardScreen());
        expect(find.text('Unacceptable'), findsOneWidget);
      });
    });

    // testWidgets(
    //     'launches temperature declaration screen with proper back navigation on tap',
    //     (tester) async {
    //   final mockObserver = MockNavigatorObserver();
    //   await tester.pumpAndSettleScreen(
    //       mockUserModel, mockDiningModel, const DashboardScreen(),
    //       navigatorObservers: [mockObserver]);

    //   expect(find.text('Declared'), findsOneWidget);
    //   await tester.tap(find.text('Declared'));
    //   await tester.pumpAndSettle();

    //   verify(mockObserver.didPush(any, any));
    //   expect(find.byType(TemperatureScreen), findsOneWidget);

    //   // Verify that back navigation works
    //   await tester.pageBack();
    //   await tester.pumpAndSettle();
    //   expect(find.byType(DashboardScreen), findsOneWidget);
    // });
  });

  testWidgets('Sign out button is present and signs out correctly',
      (tester) async {
    final mockObserver = MockNavigatorObserver();
    final mockSessionCubit = MockSessionCubit();
    await tester.pumpAndSettleScreen(
        mockUserModel, mockDiningModel, const DashboardScreen(),
        sessionCubit: mockSessionCubit, navigatorObservers: [mockObserver]);
    expect(find.text('Sign out'), findsOneWidget);

    await tester.tap(find.text('Sign out'));
    verify(mockSessionCubit.logout());
  });

  testWidgets('User name shows correctly', (tester) async {
    final mockObserver = MockNavigatorObserver();
    await tester.pumpAndSettleScreen(
        mockUserModel, mockDiningModel, const DashboardScreen(),
        navigatorObservers: [mockObserver]);

    expect(find.text('Hello, userName!'), findsOneWidget);
  });
}

// A short hand method to truncate repeated calls
extension on WidgetTester {
  Future<void> pumpAndSettleScreen(
      UserModel userModel, DiningModel diningModel, Widget screen,
      {SessionCubit? sessionCubit,
      List<NavigatorObserver>? navigatorObservers}) async {
    final mockGreenPassModel = MockGreenPassModel();
    when(mockGreenPassModel.isPassGreen).thenReturn(false);

    final mockSessionCubit = MockSessionCubit();
    when(mockSessionCubit.user).thenReturn(_mockUser);

    sessionCubit ??= mockSessionCubit;

    await pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider<UserModel>(create: (context) => userModel),
        ChangeNotifierProvider<DiningModel>(create: (context) => diningModel),
        ChangeNotifierProvider<TemperatureModel>(
            create: (context) => MockTemperatureModel()),
        ChangeNotifierProvider<GreenPassModel>(
            create: (context) => mockGreenPassModel),
        Provider<SessionCubit>(create: (context) => sessionCubit!),
      ],
      child: MaterialApp(
        home: const DashboardScreen(),
        navigatorObservers: navigatorObservers ?? [],
      ),
    ));
    await pumpAndSettle();
  }
}
