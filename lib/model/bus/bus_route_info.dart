import 'bus_route.dart';
import 'bus_stop.dart';

/// Represents the bus stops that is in a bus route.
class BusRouteInfo {
  final BusRoute route;
  final List<BusStop> busStops;

  const BusRouteInfo(this.route, this.busStops);
}
