//Packages
import 'package:flutter/material.dart';

//Local Files
import '../classes/temperature_record.dart';
import '../repository/user_repository.dart';

// Contains methods/variables representing user interactions in the
// temperature screen.
class TemperatureModel extends ChangeNotifier {
  UserRepository userRepository;

  List<TemperatureRecord> temperatureRecords = [];
  bool isTemperatureDeclared = false;

  TemperatureModel(this.userRepository) {
    update();
  }

  Future<void> update() async {
    temperatureRecords = await userRepository.getTemperatureRecords();
    isTemperatureDeclared = await userRepository.isTemperatureDeclared();
    notifyListeners();
  }

  Future<void> declareTemperature(double temperature) async {
    await userRepository.declareTemperature(temperature);
    update();
  }
}
