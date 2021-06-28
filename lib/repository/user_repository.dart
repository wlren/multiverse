//Packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../model/auth/user.dart';

//Local Files
import '../model/temperature/temperature_record.dart';
import '../model/temperature/temperature_state.dart';

//User related repository which communicates with backend API to fetch user-related data
class UserRepository extends ChangeNotifier {
  AuthUser user;

  UserRepository(this.user);

  CollectionReference students =
      FirebaseFirestore.instance.collection('students');

  // Temporary variables to imitate server state
  static final List<TemperatureRecord> _temperatureRecords = [
    TemperatureRecord(time: DateTime(2021, 5, 26, 14), temperature: 36.4),
    TemperatureRecord(time: DateTime(2021, 5, 26, 9), temperature: 36.4),
  ];

  Future<TemperatureState> getTemperatureState() async {
    // TODO: Access server to fetch temperature
    return TemperatureState.undeclared;
  }

  Future<List<TemperatureRecord>> getTemperatureRecords() async {
    // TODO: Access server
    return _temperatureRecords;
  }

  Future<String> getName() async {
    final studentInfo = await students.doc(user.id).get();

    final studentData = studentInfo.data() as Map<String, dynamic>;
    return studentData['name'] as String;
  }

  Future<void> declareTemperature(double temperature) async {
    // TODO: Access server to declare temperature
    _temperatureRecords
        .add(TemperatureRecord(time: DateTime.now(), temperature: temperature));

    // Sort temperature records by temperature. This should be done by a
    // sorted SQL call.
    _temperatureRecords.sort((a, b) => -a.time.compareTo(b.time));
    notifyListeners();
  }
}
