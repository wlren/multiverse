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
  BusStop? _nearestBusStop;
  List<BusStop>? busStops;
  List<BusRoute>? busRoutes;
  Stream<List<BusArrivalInfo>>? _currArrivalInfoStream;
  LatLng userLocation = yusofIshakHouseLatLng;

  BusStop? get nearestBusStop {
    update();
    return _nearestBusStop;
  }

  Stream<List<BusArrivalInfo>>? get currArrivalInfoStream {
    update();
    return _currArrivalInfoStream;
  }

  void selectBusStop(BusStop? busStop) {
    selectedBusStop = busStop;
    //currArrivalInfoStream = getArrivalInfoStream(selectedBusStop!);
    update();
  }

  BusRoute? getRouteWithName(String name) {
    return busRoutes?.firstWhere((route) => route.name == name);
  }

  BusStop? getBusWithName(String name) {
    return busStops?.firstWhere((stop) => stop.shortDisplayName == name);
  }

  void update() async {
    busStops ??= await busRepository.fetchBusStops();
    busRoutes ??= await busRepository.fetchBusRoutes();

    await updateNearestBusStop();
    if (selectedBusStop == null) {
      _currArrivalInfoStream = getArrivalInfoStream(nearestBusStop!);
    } else {
      _currArrivalInfoStream = getArrivalInfoStream(selectedBusStop!);
    }

    notifyListeners();
  }

  Stream<List<BusArrivalInfo>> getArrivalInfoStream(BusStop busStop) {
    return busRepository.getBusArrivalStream(busStop);
  }

  Future<void> updateNearestBusStop() async {
    // Sort bus stops by distance from user.
    await Future<void>(() => busStops!.sort((busStop1, busStop2) => busStop1
        .distanceTo(userLocation)
        .compareTo(busStop2.distanceTo(userLocation))));
    _nearestBusStop = busStops!.first;
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
