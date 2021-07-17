//Packages
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../model/bus/bus_stop.dart';
import '../model/bus_model.dart';
import '../widgets/bus_stop_view.dart';
import 'bus_search_screen.dart';

class BusesScreen extends StatelessWidget {
  const BusesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            _buildMap(context),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: OpenContainer(
                  tappable: false,
                  openBuilder: (context, _) => const BusSearchScreen(),
                  closedBuilder: _buildInfoCard,
                  closedColor: Theme.of(context).cardColor,
                  closedShape: Theme.of(context).cardTheme.shape!,
                  openColor: Theme.of(context).cardColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, VoidCallback expandContainer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 16.0,
            bottom: 8.0,
          ),
          child:
              _buildBusStop(context, context.watch<BusModel>().selectedBusStop),
        ),
        // ListTile(
        //   contentPadding: const EdgeInsets.all(0),
        //   horizontalTitleGap: 0,
        //   leading: Icon(Icons.search),
        //   title: Text('Search stops/services',
        //       style: Theme.of(context).textTheme.headline6),
        // ),
        ListTile(
          // contentPadding: const EdgeInsets.all(0),
          horizontalTitleGap: 0,
          leading: const Icon(Icons.expand_less),
          onTap: expandContainer,
          title: Text(
            'View all stops/services',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
      ],
    );
  }

  Widget _buildMap(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
          center: context.watch<BusModel>().userLocation,
          zoom: 16.0,
          onTap: (latlng) {
            context.read<BusModel>().selectBusStop(null);
          }),
      children: [
        Container(
          height: 100,
          width: 100,
          color: Colors.green,
        ),
      ],
      layers: [
        TileLayerOptions(
            urlTemplate: Theme.of(context).brightness == Brightness.light
                ? 'https://cartodb-basemaps-{s}.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png'
                : 'https://cartodb-basemaps-{s}.global.ssl.fastly.net/dark_all/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c']),
        MarkerLayerOptions(
          rotate: true,
          markers: [
            for (BusStop stop in context.watch<BusModel>().busStops ?? []) ...{
              Marker(
                width: 160.0,
                height: 160.0,
                point: LatLng(stop.latitude, stop.longitude),
                builder: (ctx) => Column(
                  children: [
                    Material(
                      type: MaterialType.card,
                      borderRadius: BorderRadius.circular(8.0),
                      child: InkWell(
                        onTap: () {
                          context.read<BusModel>().selectBusStop(stop);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(stop.shortDisplayName),
                        ),
                      ),
                    ),
                    Material(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16.0),
                      child: InkWell(
                        onTap: () {
                          context.read<BusModel>().selectBusStop(stop);
                        },
                        child: const Icon(Icons.directions_bus),
                      ),
                    ),
                  ],
                ),
              ),
            },
            Marker(
              width: 32.0,
              height: 32.0,
              point: context.watch<BusModel>().userLocation,
              builder: (ctx) => Material(
                color: Colors.red,
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBusStop(BuildContext context, BusStop? selectedBusStop) {
    final busStop = selectedBusStop ?? context.watch<BusModel>().nearestBusStop;
    return Builder(
      builder: (context) => Hero(
        tag: 'busStopCard',
        child: busStop != null
            ? BusStopView(
                busStop: busStop,
                compact: selectedBusStop == null,
                overline: selectedBusStop != null
                    ? 'SELECTED BUS STOP'
                    : 'NEAREST BUS STOP',
              )
            : Container(),
      ),
    );
  }
}
