import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../repository/bus_repository.dart';
import 'bus/bus_arrival_info.dart';
import 'bus/bus_route.dart';
import 'bus/bus_stop.dart';

final yusofIshakHouseLatLng = LatLng(1.298775, 103.774605);

// Contains methods/variables representing user interactions in the
// login screen.
class BusModel extends ChangeNotifier {
  BusModel(this.busRepository) {
    update();
  }

  final BusRepository busRepository;

  BusStop? selectedBusStop;
  List<BusStop>? busStops;
  List<BusRoute>? busRoutes;
  BusArrivalInfo? arrivalInfo;
  BusStop? _nearestBusStop;
  LatLng userLocation = yusofIshakHouseLatLng;
  LatLng? _focusedLocation;

  LatLng get focusedLocation => _focusedLocation ?? userLocation;

  set focusedLocation(LatLng? focusedLocation) {
    _focusedLocation = focusedLocation;
  }

  BusStop? get nearestBusStop => _nearestBusStop;

  void selectBusStop(BusStop? busStop) {
    selectedBusStop = busStop;
    notifyListeners();
  }

  BusRoute? getRouteWithName(String name) {
    return busRoutes?.firstWhere((route) => route.name == name);
  }

  void update() async {
    busStops = await busRepository.fetchBusStops();
    busRoutes = await busRepository.fetchBusRoutes();

    // Sort bus stops by distance from user.
    busStops!.sort((busStop1, busStop2) => busStop1
        .distanceTo(userLocation)
        .compareTo(busStop2.distanceTo(userLocation)));
    _nearestBusStop = busStops!.first;
    // arrivalInfo = await busRepository.fetchBusArrivalInfo('COM2');
    notifyListeners();
  }
}

extension BusStopDistance on BusStop {
  double distanceTo(LatLng latLng) {
    return Path.from([latLng, LatLng(latitude, longitude)]).distance;
  }

  LatLng get location {
    return LatLng(latitude, longitude);
  }
}
