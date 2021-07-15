import 'bus_api_extensions.dart';

// Sample response:
// {
//   "caption": "AS5",
//   "latitude": 1.29349994659424,
//   "longitude": 103.772102355957,
//   "name": "AS7",
//   "LongName": "AS 5",
//   "ShortName": "AS 5"
// },

/// Represents a bus stop as returned by the API.
class BusStop {
  /// The identifier of the bus stop, represented by "name" in the API.
  final String id;
  final String longDisplayName;
  final String shortDisplayName;
  final double latitude;
  final double longitude;

  const BusStop({
    required this.id,
    required this.longDisplayName,
    required this.shortDisplayName,
    required this.latitude,
    required this.longitude,
  });

  factory BusStop.fromJson(Map<String, String> json) {
    final id = json.getStringEntry('name')!;
    final latitude = json.getDoubleEntry('latitude')!;
    final longitude = json.getDoubleEntry('longitude')!;
    final longDisplayName = json.getStringEntry('LongName')!;
    final shortDisplayName = json.getStringEntry('ShortName')!;
    return BusStop(
      id: id,
      latitude: latitude,
      longitude: longitude,
      longDisplayName: longDisplayName,
      shortDisplayName: shortDisplayName,
    );
  }
}
