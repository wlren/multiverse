//Format for a temperature record
class TemperatureRecord {
  //TODO add bool for symptoms etc
  TemperatureRecord({required this.time, required this.temperature});

  final DateTime time;
  final double temperature;
}
