//Packages
import 'package:flutter/material.dart';
import 'package:multiverse/model/temperature/temperature_state.dart';

//Local Files
import '../../repository/user_repository.dart';
import 'temperature_record.dart';

// Contains methods/variables representing user interactions in the
// temperature screen.
class TemperatureModel extends ChangeNotifier {
  UserRepository userRepository;

  List<TemperatureRecord> temperatureRecords = [];
  TemperatureState temperatureState = TemperatureState.undeclared;

  TemperatureModel(this.userRepository) {
    update();
  }

  Future<void> update() async {
    temperatureRecords = await userRepository.getTemperatureRecords();
    temperatureState = await userRepository.getTemperatureState();
    notifyListeners();
  }

  Future<void> declareTemperature(double temperature) async {
    await userRepository.declareTemperature(temperature);
    update();
  }
}
