//Packages
import 'package:flutter/material.dart';

//Local Files
import '../repository/user_repository.dart';
import 'temperature/temperature_state.dart';

/// Responsible for communicating between UI and UserRepository.
/// Provides synchronous versions of the async methods found in the corresponding
/// repository. This is to allow the UI to use StatelessWidgets without using
/// FutureBuilders.
class UserModel extends ChangeNotifier {
  UserModel(this.userRepository) {
    update();
  }

  void update() async {
    temperatureState = await userRepository.getTemperatureState();
    notifyListeners();
  }

  final UserRepository userRepository;

  TemperatureState temperatureState = TemperatureState.undeclared;
}
