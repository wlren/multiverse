//Packages
import 'package:flutter/material.dart';

//Local files
import 'package:multiverse/view_model/user_model.dart';

// Contains methods/variables representing user interactions in the
// green pass screen.
class GreenPassModel extends ChangeNotifier {
  GreenPassModel({required this.userModel});

  final UserModel userModel;

  // TODO: Add other factors
  bool get isPassGreen {
    return userModel.isTemperatureAcceptable;
  }
}
