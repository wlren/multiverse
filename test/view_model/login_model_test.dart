import 'package:flutter_test/flutter_test.dart';

import 'package:multiverse/view_model/login_model.dart';

void main() {
  group('Attribute setters call notifyListeners', () {
    test('shouldRememberPassword setter', () {
      bool testPassed = false;
      LoginModel loginModel = LoginModel();
      loginModel.addListener(() {
        testPassed = true;
      });
      loginModel.shouldRememberPassword = true;
      expect(testPassed, true);
    });
    test('email setter', () {
      bool testPassed = false;
      LoginModel loginModel = LoginModel();
      loginModel.addListener(() {
        testPassed = true;
      });
      loginModel.email = 'email@email.com';
      expect(testPassed, true);
    });
    test('password setter', () {
      bool testPassed = false;
      LoginModel loginModel = LoginModel();
      loginModel.addListener(() {
        testPassed = true;
      });
      loginModel.password = 'password';
      expect(testPassed, true);
    });
  });
}