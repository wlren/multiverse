import 'package:flutter/material.dart';
import 'package:multiverse/view_model/user_model.dart';

// Contains methods/variables representing user interactions in the
// green pass screen.
class GreenPassModel extends ChangeNotifier {
  GreenPassModel({required this.userModel});

  final UserModel userModel;

  bool get isPassGreen {
    // TODO: Add other factors
    return userModel.isTemperatureAcceptable;
  }
}