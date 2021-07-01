//Packages
import 'package:flutter/material.dart';

//Local files
import '../repository/user_repository.dart';
import 'temperature/temperature_state.dart';

// Contains methods/variables representing user interactions in the
// green pass screen.
class GreenPassModel extends ChangeNotifier {
  GreenPassModel(this.userRepository);

  final UserRepository userRepository;
  bool _isTemperatureAcceptable = false;

  void update() async {
    _isTemperatureAcceptable = (await userRepository.getTemperatureState()) ==
        TemperatureState.acceptable;
    notifyListeners();
  }

  // TODO: Add other factors
  bool get isPassGreen {
    update();
    return _isTemperatureAcceptable;
  }
}
