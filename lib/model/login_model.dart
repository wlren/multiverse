//Packages
import 'package:flutter/material.dart';

// Contains methods/variables representing user interactions in the
// login screen.
class LoginModel extends ChangeNotifier {
  String _email = 'e0000000';
  String _password = 'test123';

  String get email => _email;
  String get password => _password;

  set email(String value) {
    _email = value;
    notifyListeners();
  }

  set password(String value) {
    _password = value;
    notifyListeners();
  }

  bool get isPasswordValid => password.isNotEmpty;

  // Check if username is exxxxxxx@u.nus.edu
  bool get isEmailValid {
    return RegExp(r'^e\d{7}@u.nus.edu$').hasMatch(email);
  }

  LoginModel() {
    update();
  }

  Future<void> update() async {
    notifyListeners();
  }
}
