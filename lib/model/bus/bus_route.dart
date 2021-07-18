import 'package:flutter/material.dart';

import 'bus_api_extensions.dart';
// Sample response:
// {
//   "Route": "A1",
//   "RouteDescription": "PGP > KR MRT > CLB > BIZ > PGP"
// },

/// Represents a bus service/route (e.g., A1).
class BusRoute {
  const BusRoute({
    required this.name,
    required this.description,
    required this.color,
  });

  factory BusRoute.fromJson(Map<String, dynamic> json) {
    final name = json.getStringEntry('Route')!;
    final description = json.getStringEntry('RouteDescription')!;
    return BusRoute(
      name: name,
      description: description,
      color: _getRouteColor(name),
    );
  }

  final String name;
  final String description;
  final Color color;
  // late List<BusStop> _busStopList;

  // List<BusStop> get busStopList {
  //   return _busStopList;
  // }
}

// Self-defined some colors for each bus route. Because this is not
// provided by the API.
Color _getRouteColor(String routeName) {
  if (routeName == 'A1' || routeName == 'A2') {
    return Colors.green.withOpacity(0.25);
  }
  if (routeName == 'B1' || routeName == 'B2') {
    return Colors.orange.withOpacity(0.25);
  }
  if (routeName == 'C1') {
    return Colors.blue.withOpacity(0.25);
  }
  if (routeName == 'D1' || routeName == 'D2') {
    return Colors.purple.withOpacity(0.25);
  }
  if (routeName == 'BTC1' || routeName == 'BTC2') {
    return Colors.cyan.withOpacity(0.25);
  }
  if (routeName == 'A1E' || routeName == 'A2E') {
    return Colors.red.withOpacity(0.25);
  }
  return Colors.red.withOpacity(0.25);
}
