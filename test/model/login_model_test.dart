import 'package:flutter_test/flutter_test.dart';

import 'package:multiverse/model/login_model.dart';

void main() {
  group('Attribute setters work correctly, and call notifyListeners', () {
    test('email setter', () {
      var testPassed = false;
      final loginModel = LoginModel();
      loginModel.addListener(() {
        testPassed = true;
      });
      loginModel.email = 'email@email.com';
      expect(testPassed, true);
      expect(loginModel.email, 'email@email.com');
    });
    test('password setter', () {
      var testPassed = false;
      final loginModel = LoginModel();
      loginModel.addListener(() {
        testPassed = true;
      });
      loginModel.password = 'password';
      expect(testPassed, true);
      expect(loginModel.password, 'password');
    });
  });

  group('Form validators function correctly', () {
    test('Empty passwords are invalid', () {
      final loginModel = LoginModel();
      loginModel.password = '';
      expect(loginModel.password.isEmpty, true);
      expect(loginModel.isPasswordValid, false);
    });
    test('Non-empty passwords are valid', () {
      final loginModel = LoginModel();
      loginModel.password = 'password123';
      expect(loginModel.isPasswordValid, true);
      loginModel.password = 'pw345';
      expect(loginModel.isPasswordValid, true);
      loginModel.password = 'hellothisismypassword!';
      expect(loginModel.isPasswordValid, true);
    });
    test('Empty emails are invalid', () {
      final loginModel = LoginModel();
      loginModel.email = '';
      expect(loginModel.email.isEmpty, true);
      expect(loginModel.isEmailValid, false);
    });
    group('Valid emails are in the format exxxxxxx@u.nus.edu', () {
      test('Wrong domain (not u.nus.edu) is invalid', () {
        final loginModel = LoginModel();
        loginModel.email = 'email@email.com';
        expect(loginModel.isEmailValid, false);
      });
      test('Correct domain but wrong user id format is invalid', () {
        final loginModel = LoginModel();
        loginModel.email = 'e442@u.nus.edu';
        expect(loginModel.isEmailValid, false);
        loginModel.email = '1312109@u.nus.edu';
        expect(loginModel.isEmailValid, false);
        loginModel.email = 'hello@u.nus.edu';
        expect(loginModel.isEmailValid, false);
      });
      test('Correct format is valid', () {
        final loginModel = LoginModel();
        loginModel.email = 'e4423443@u.nus.edu';
        expect(loginModel.isEmailValid, true);
      });
    });
  });
}
