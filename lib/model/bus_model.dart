import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../model/bus/location_service.dart';
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
  LatLng userLocation = yusofIshakHouseLatLng;
  final Map<BusStop, List<BusArrivalInfo>?> _cachedBusArrivals = {};

  BusStop? get nearestBusStop {
    update();
    return _nearestBusStop;
  }

  LatLng get currentLocation => userLocation;

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

    notifyListeners();
  }

  Stream<List<BusArrivalInfo>> getArrivalInfoStream(BusStop busStop) {
    final stream = busRepository.getBusArrivalStream(busStop);
    stream.listen((event) {
      _cachedBusArrivals[busStop] = event;
    });
    return stream;
  }

  List<BusArrivalInfo>? getCachedArrivalInfo(BusStop busStop) {
    return _cachedBusArrivals[busStop];
  }

  Stream<LatLng> getLocationStream() {
    final stream = LocationService().locationStream;
    stream.listen((event) async {
      userLocation = event;
      await updateNearestBusStop();
      notifyListeners();
    });
    return stream;
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
