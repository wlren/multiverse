//Packages
import 'package:flutter/material.dart';

//Local Files
import '../repository/user_repository.dart';

/// Responsible for communicating between UI and UserRepository.
/// Provides synchronous versions of the async methods found in the corresponding
/// repository. This is to allow the UI to use StatelessWidgets without using
/// FutureBuilders.
class UserModel extends ChangeNotifier {
  UserModel(this.userRepository) {
    update();
  }

  void update() async {
    isTemperatureAcceptable = await userRepository.isTemperatureAcceptable();
    notifyListeners();
  }

  final UserRepository userRepository;

  bool isTemperatureAcceptable = false;
}
