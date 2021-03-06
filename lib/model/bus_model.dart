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
    _locationService = LocationService();
    update();
  }

  final BusRepository busRepository;
  LocationService? _locationService;

  BusStop? selectedBusStop;
  BusStop? _nearestBusStop;
  List<BusStop>? busStops;
  List<BusRoute>? busRoutes;
  LatLng? userLocation;
  final Map<BusStop, List<BusArrivalInfo>> _cachedBusArrivals = {};
  final Map<BusRoute, List<BusStop>> _cachedBusRoutes = {};

  BusStop? get nearestBusStop {
    update();
    return _nearestBusStop;
  }

  LatLng? get currentLocation => userLocation;

  void selectBusStop(BusStop? busStop) {
    selectedBusStop = busStop;
    update();
  }

  BusRoute? getRouteWithName(String name) {
    return busRoutes?.firstWhere((route) => route.name == name);
  }

  BusStop? getBusWithName(String name) {
    return busStops?.firstWhere((stop) => stop.shortDisplayName == name);
  }

  Future<List<BusStop>> getBusStopsInRoute(BusRoute route) async {
    if (_cachedBusRoutes.containsKey(route)) {
      return _cachedBusRoutes[route]!;
    } else {
      final busStopNames =
          await busRepository.fetchBusStopNamesInRoute(route.name);
      _cachedBusRoutes[route] = busStopNames
          .map((busStopLongName) => busStops!.firstWhere(
              (busStop) => busStop.longDisplayName == busStopLongName))
          .toList();
      return _cachedBusRoutes[route]!;
    }
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
    final stream = _locationService!.locationStream;
    stream.listen((event) {
      userLocation = event;
      update();
    });
    return stream;
  }

  Future<void> updateNearestBusStop() async {
    userLocation = await _locationService?.getLocation();

    // Sort bus stops by distance from user.
    await Future<void>(() => busStops!.sort((busStop1, busStop2) => busStop1
        .distanceTo(userLocation ?? yusofIshakHouseLatLng)
        .compareTo(
            busStop2.distanceTo(userLocation ?? yusofIshakHouseLatLng))));
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
