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

  factory BusRoute.fromJson(Map<String, String> json) {
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
}

// TODO: Self-defined some colors for each bus route. Because this is not
// provided by the API.
Color _getRouteColor(String routeName) {
  return Colors.white;
}
