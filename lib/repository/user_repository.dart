//Packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

//Local Files
import '../model/auth/user.dart';
import '../model/temperature/temperature_record.dart';
import '../model/temperature/temperature_state.dart';
import '../screens/temperature_screen.dart';

//User related repository which communicates with backend API to fetch user-related data
class UserRepository extends ChangeNotifier {
  AuthUser user;

  UserRepository(this.user);

  CollectionReference students =
      FirebaseFirestore.instance.collection('students');

  CollectionReference temp = FirebaseFirestore.instance.collection('temp');

  List<TemperatureRecord> _temperatureRecords = [];
  bool changed = false;

  // Temporary variable
  TemperatureState _temperatureState = TemperatureState.undeclared;

  Future<TemperatureState> getTemperatureState() async {
    await getTemperatureRecords();
    // TODO: Access server to fetch temperature
    return _temperatureState;
  }

  Future<List<TemperatureRecord>> getTemperatureRecords() async {
    //memoization
    if (changed == false && _temperatureRecords.isNotEmpty) {
      return _temperatureRecords;
    }
    changed = false;
    _temperatureRecords.clear();
    //fetch data
    final tempInfo = await temp
        .doc('records')
        .collection(user.id)
        .orderBy('time', descending: true)
        .limit(10)
        .get();

    for (var i = 0; i < tempInfo.docs.length; i++) {
      final healthData = tempInfo.docs[i].data();
      final tempDate = healthData['time'] as String;
      final dateWithT = tempDate.substring(0, 8) + 'T' + tempDate.substring(8);
      final dateTime = DateTime.parse(dateWithT);
      _temperatureRecords.add(TemperatureRecord(
          time: dateTime,
          temperature: healthData['temp'] as double,
          hasSymptoms: healthData['hasSymptops'] as bool));
    }

    //print(tempInfo.docs.toString());
    return _temperatureRecords;
  }

  Future<void> declareTemperature(double temperature, bool hasSymptoms) async {
    final timeStamp = DateFormat('yyyyMMddhhmmss').format(DateTime.now());
    // print(timeStamp);
    // print(user.id);
    await temp.doc('records').collection(user.id).doc(timeStamp).set(
        {'temp': temperature, 'hasSymptoms': hasSymptoms, 'time': timeStamp});

    if (temperature < TemperatureScreen.unacceptableTemperature &&
        !hasSymptoms) {
      _temperatureState = TemperatureState.acceptable;
    } else {
      _temperatureState = TemperatureState.unacceptable;
    }
    changed = true;
    await getTemperatureRecords();
    notifyListeners();
  }

  Future<String> getName() async {
    final studentInfo = await students.doc(user.id).get();

    final studentData = studentInfo.data() as Map<String, dynamic>;
    return studentData['name'] as String;
  }
}
