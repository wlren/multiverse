import 'package:flutter/material.dart';
import 'package:multiverse/temperature_record.dart';
import 'package:multiverse/user_repository.dart';

// Contains methods/variables representing user interactions in the
// temperature screen.
class TemperatureModel extends ChangeNotifier {
  UserRepository userRepository;
  List<TemperatureRecord> temperatureRecords = [];

  TemperatureModel(this.userRepository) {
    update();
  }

  void update() async {
    temperatureRecords = await userRepository.getTemperatureRecords();
  }

  void declareTemperature(double temperature) async {
    await userRepository.declareTemperature(temperature);
    temperatureRecords = await userRepository.getTemperatureRecords();
    notifyListeners();
  }
}
