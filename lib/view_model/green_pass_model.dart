//Packages
import 'package:flutter/material.dart';

//Local files
import 'package:multiverse/repository/user_repository.dart';

// Contains methods/variables representing user interactions in the
// green pass screen.
class GreenPassModel extends ChangeNotifier {
  GreenPassModel(this.userRepository);

  final UserRepository userRepository;
  bool _isTemperatureAcceptable = false;

  void update() async {
    _isTemperatureAcceptable = await userRepository.isTemperatureAcceptable();
    notifyListeners();
  }

  // TODO: Add other factors
  bool get isPassGreen {
    return _isTemperatureAcceptable;
  }
}
