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
    userRepository.addListener(() {
      update();
    });
  }

  void update() async {
    temperatureState = await userRepository.getTemperatureState();
    userName = await userRepository.getName();
    admitTerm = await userRepository.getAdmitTerm();
    matric = await userRepository.getMatric();
    career = await userRepository.getCareer();
    notifyListeners();
  }

  final UserRepository userRepository;

  TemperatureState temperatureState = TemperatureState.undeclared;
  String userName = 'Default';
  String admitTerm = 'Default';
  String matric = 'Default';
  String career = 'Default';
}
