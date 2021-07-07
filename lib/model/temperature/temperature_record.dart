//Format for a temperature record
class TemperatureRecord {
  TemperatureRecord(
      {required this.time,
      required this.temperature,
      required this.hasSymptoms});

  final DateTime time;
  final double temperature;
  final bool hasSymptoms;
}
