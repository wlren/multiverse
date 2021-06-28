import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:multiverse/model/auth/session_cubit.dart';
import 'package:multiverse/screens/login_screen.dart';
import 'package:provider/provider.dart';

import 'login_screen_test.mocks.dart';

@GenerateMocks([SessionCubit])
void main() {
  testWidgets('Login button tries to login with email and password',
      (tester) async {
    final mockSessionCubit = MockSessionCubit();
    when(mockSessionCubit.login(
            email: anyNamed('email'), password: anyNamed('password')))
        .thenAnswer((_) async => '');
    await tester.pumpWidget(Provider<SessionCubit>(
      create: (context) => mockSessionCubit,
      child: const MaterialApp(home: LoginScreen()),
    ));
    final emailField = find.ancestor(
        of: find.text('NUSNET Email'), matching: find.byType(TextField));
    final passwordField = find.ancestor(
        of: find.text('Password'), matching: find.byType(TextField));
    expect(emailField, findsOneWidget);
    expect(passwordField, findsOneWidget);

    await tester.enterText(emailField, 'e1234567');
    await tester.enterText(passwordField, 'password');
    await tester.tap(find.text('Login'));

    verify(mockSessionCubit.login(
        email: 'e1234567@u.nus.edu', password: 'password'));
    verifyNoMoreInteractions(mockSessionCubit);
  });
}
