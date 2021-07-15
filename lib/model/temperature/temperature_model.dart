//Packages
import 'package:flutter/material.dart';

//Local Files
import '../../repository/user_repository.dart';
import 'temperature_record.dart';
import 'temperature_state.dart';

// Contains methods/variables representing user interactions in the
// temperature screen.
class TemperatureModel extends ChangeNotifier {
  UserRepository userRepository;

  List<TemperatureRecord> temperatureRecords = [];
  TemperatureState temperatureState = TemperatureState.undeclared;

  TemperatureModel(this.userRepository) {
    update();
    userRepository.addListener(() {
      update();
    });
  }

  Future<void> update() async {
    temperatureRecords = await userRepository.getTemperatureRecords();
    temperatureState = await userRepository.getTemperatureState();
    notifyListeners();
  }

  Future<void> declareTemperature(double temperature, bool hasSymptoms) async {
    await userRepository.declareTemperature(temperature, hasSymptoms);
    update();
  }
}
