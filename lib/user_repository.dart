import 'package:multiverse/temperature_record.dart';

class UserRepository {
  // Temporary variables to imitate server state
  static bool _isTemperatureDeclared = false;
  static final List<TemperatureRecord> _temperatureRecords = [
    TemperatureRecord(time: DateTime(2021, 5, 26, 14), temperature: 36.4),
    TemperatureRecord(time: DateTime(2021, 5, 26, 9), temperature: 36.4),
  ];

  Future<bool> isTemperatureAcceptable() async {
    // TODO: Access server to fetch temperature
    return await isTemperatureDeclared() && _isTemperatureDeclared;
  }

  Future<bool> isTemperatureDeclared() async {
    // TODO: Access server to fetch temperature
    return _isTemperatureDeclared;
  }

  Future<void> declareTemperature(double temperature) async {
    // TODO: Access server to declare temperature
    _isTemperatureDeclared = true;
    _temperatureRecords.add(TemperatureRecord(time: DateTime.now(), temperature: temperature));

    // Sort temperature records by temperature. This should be done by a
    // sorted SQL call.
    _temperatureRecords.sort((a, b) => -a.time.compareTo(b.time));
  }

  Future<List<TemperatureRecord>> getTemperatureRecords() async {
    // TODO: Access server
    return _temperatureRecords;
  }
}