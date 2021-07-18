import 'bus.dart';
import 'bus_api_extensions.dart';

// Sample response from API:
// {
//   "arrivalTime": "23",
//   "name": "A1",
//   "nextArrivalTime": "53",
//   "nextPassengers": "-",
//   "passengers": "-",
//   "arrivalTime_veh_plate": "",
//   "nextArrivalTime_veh_plate": ""
// },

/// Represents the bus arrival information from the API.
/// Contains bus timings for up to two buses of the same service.
class BusArrivalInfo {
  final String name;
  final List<Bus> buses;

  const BusArrivalInfo({required this.name, required this.buses});

  factory BusArrivalInfo.fromJson(Map<String, dynamic> json) {
    final name = json.getStringEntry('name')!;
    final firstBusArrivalTime = json.getIntEntry('arrivalTime');
    final firstBusVehiclePlate = json.getStringEntry('arrivalTime_veh_plate');

    final secondBusArrivalTime = json.getIntEntry('nextArrivalTime');
    final secondBusVehiclePlate =
        json.getStringEntry('nextArrivalTime_veh_plate');

    final buses = <Bus>[
      if (firstBusArrivalTime != null)
        Bus(
            arrivalTimeMins: firstBusArrivalTime,
            vehiclePlate: firstBusVehiclePlate),
      if (secondBusArrivalTime != null)
        Bus(
            arrivalTimeMins: secondBusArrivalTime,
            vehiclePlate: secondBusVehiclePlate),
    ];

    return BusArrivalInfo(name: name, buses: buses);
  }
}
