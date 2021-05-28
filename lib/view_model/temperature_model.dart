import 'package:flutter/material.dart';
import 'package:multiverse/temperature_record.dart';
import 'package:multiverse/user_repository.dart';

// Contains methods/variables representing user interactions in the
// temperature screen.
class TemperatureModel extends ChangeNotifier {
  UserRepository userRepository;

  List<TemperatureRecord> temperatureRecords = [];
  bool isTemperatureDeclared = false;

  TemperatureModel(this.userRepository) {
    update();
  }

  void update() async {
    temperatureRecords = await userRepository.getTemperatureRecords();
    isTemperatureDeclared = await userRepository.isTemperatureDeclared();
    notifyListeners();
  }

  void declareTemperature(double temperature) async {
    await userRepository.declareTemperature(temperature);
    update();
  }
}
