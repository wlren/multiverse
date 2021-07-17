import 'package:flutter/material.dart';
import '../model/bus/bus_route.dart';

class BusRouteScreen extends StatelessWidget {
  const BusRouteScreen({Key? key, required this.route}) : super(key: key);

  final BusRoute route;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.alphaBlend(
            route.color, Theme.of(context).scaffoldBackgroundColor),
        elevation: 0,
      ),
      backgroundColor: Color.alphaBlend(
          route.color, Theme.of(context).scaffoldBackgroundColor),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(route.name, style: Theme.of(context).textTheme.headline5),
            Text(route.description),
          ],
        ),
      ),
    );
  }
}
