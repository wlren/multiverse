import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/bus/bus_route.dart';
import '../model/bus/bus_stop.dart';
import '../model/bus_model.dart';
import '../widgets/bus_stop_view.dart';

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
      body: Theme(
        data: Theme.of(context).copyWith(
          scaffoldBackgroundColor: Color.alphaBlend(
              route.color, Theme.of(context).scaffoldBackgroundColor),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(route.name, style: Theme.of(context).textTheme.headline5),
                Text(route.description),
                const SizedBox(height: 32.0),
                FutureBuilder<List<BusStop>>(
                    future: context.watch<BusModel>().getBusStopsInRoute(route),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (BusStop busStop in snapshot.data!) ...{
                              // ignore: prefer_const_constructors
                              Divider(),
                              BusStopView(
                                busStop: busStop,
                                expanded: false,
                                canExpand: true,
                              ),
                            }
                          ],
                        );
                      } else {
                        return Container();
                      }
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
