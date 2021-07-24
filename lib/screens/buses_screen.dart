//Packages
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../model/bus/bus_stop.dart';
import '../model/bus_model.dart';
import '../widgets/bus_stop_view.dart';
import 'bus_search_screen.dart';

class BusesScreen extends StatefulWidget {
  const BusesScreen({Key? key}) : super(key: key);

  @override
  _BusesScreenState createState() => _BusesScreenState();
}

class _BusesScreenState extends State<BusesScreen>
    with TickerProviderStateMixin {
  static const double maxPullOffset = 100;

  late AnimationController controller = AnimationController(
    vsync: this,
  );

  late final MapController _mapController;
  double pulledPercentage = 0;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
      floatingActionButton: FloatingActionButton(
        mini: true,
        child: const Icon(Icons.arrow_back),
        foregroundColor: Colors.black,
        backgroundColor: Theme.of(context).cardColor,
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.expand_less,
                          size: 24,
                        ),
                        Text(
                          'View all stops/routes',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(shadows: [
                            Shadow(
                                blurRadius: 4,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor)
                          ]),
                        ),
                      ],
                    ),
                    OpenContainer(
                      tappable: false,
                      openBuilder: (context, _) => const BusSearchScreen(),
                      closedBuilder: _buildInfoCard,
                      closedColor: Color.alphaBlend(
                          (context.watch<BusModel>().selectedBusStop != null
                                  ? Theme.of(context).colorScheme.secondary
                                  : Theme.of(context).colorScheme.primary)
                              .withOpacity(0.25),
                          Theme.of(context).cardColor),
                      closedShape: Theme.of(context).cardTheme.shape!,
                      openColor: Theme.of(context).cardColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // From https://github.com/fleaflet/flutter_map/blob/master/example/lib/pages/animated_map_controller.dart
  void _animatedMapMove(LatLng destLocation, double destZoom) {
    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.
    final _latTween = Tween<double>(
        begin: _mapController.center.latitude, end: destLocation.latitude);
    final _lngTween = Tween<double>(
        begin: _mapController.center.longitude, end: destLocation.longitude);
    final _zoomTween = Tween<double>(begin: _mapController.zoom, end: destZoom);

    // Create a animation controller that has a duration and a TickerProvider.
    final controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    // The animation determines what path the animation will take. You can try different Curves values, although I found
    // fastOutSlowIn to be my favorite.
    final animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      _mapController.move(
          LatLng(_latTween.evaluate(animation), _lngTween.evaluate(animation)),
          _zoomTween.evaluate(animation));
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

  void _focusOnBusStop(BusStop? busStop) {
    if (busStop == null) return;
    _animatedMapMove(busStop.location, 16.0);
  }

  Widget _buildInfoCard(BuildContext context, VoidCallback expandContainer) {
    final busStop = context.watch<BusModel>().selectedBusStop ??
        context.watch<BusModel>().nearestBusStop;
    final isSelected = context.watch<BusModel>().selectedBusStop != null;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onVerticalDragDown: (_) {
        controller.stop();
      },
      onVerticalDragUpdate: (details) {
        setState(() {
          pulledPercentage =
              (pulledPercentage - details.primaryDelta! / maxPullOffset)
                  .clamp(0, double.infinity);

          final maxPullPercentage =
              MediaQuery.of(context).size.height / maxPullOffset;
          const increasedResistanceThreshold = 0;
          controller.value = pulledPercentage > increasedResistanceThreshold
              ? increasedResistanceThreshold +
                  (1 - increasedResistanceThreshold) *
                      (pulledPercentage - increasedResistanceThreshold) /
                      (maxPullPercentage - increasedResistanceThreshold)
              : pulledPercentage;
        });
      },
      onVerticalDragEnd: (details) {
        final spring =
            SpringDescription.withDampingRatio(mass: 11, stiffness: 1000);
        pulledPercentage = 0;

        // If the card is dragged fast enough, or is dragged far enough
        if (controller.value > 0.4 || details.primaryVelocity!.abs() > 5) {
          expandContainer();
          controller.value = 0;
        } else {
          final simulation = SpringSimulation(
              spring,
              controller.value,
              0,
              details.primaryVelocity!.clamp(double.negativeInfinity, 0) /
                  maxPullOffset);
          if (controller.value != 0) controller.animateWith(simulation);
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: _buildBusStop(
                context,
                busStop,
                isSelected,
              ),
            ),
          ),
          AnimatedBuilder(
            animation: controller,
            builder: (context, child) =>
                Container(height: controller.value * maxPullOffset),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
            child: OutlinedButton.icon(
              label: const Text('Show on map'),
              icon: const Icon(Icons.gps_fixed_outlined),
              style: OutlinedButton.styleFrom(
                primary: Theme.of(context).hintColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0)),
              ),
              // tooltip: 'Show on map',
              onPressed: () {
                _focusOnBusStop(busStop);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMap(BuildContext context) {
    final selectedBusStop = context.watch<BusModel>().selectedBusStop;
    final nearestBusStop = context.watch<BusModel>().nearestBusStop;
    return StreamBuilder<LatLng>(
        stream: context.watch<BusModel>().getLocationStream(),
        builder: (context, snapshot) {
          return FlutterMap(
            key: ValueKey(MediaQuery.of(context).orientation),
            mapController: _mapController,
            options: MapOptions(
                center: context.read<BusModel>().userLocation,
                zoom: 17.0,
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
                  for (BusStop stop
                      in context.watch<BusModel>().busStops ?? []) ...{
                    Marker(
                      anchorPos: AnchorPos.align(AnchorAlign.top),
                      // rotateAlignment: Alignment.center,
                      // rotateOrigin: ,
                      rotateAlignment: Alignment.bottomCenter,
                      width: 160.0,
                      height: 64.0,
                      point: LatLng(stop.latitude, stop.longitude),
                      builder: (ctx) => Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Material(
                            elevation: 4.0,
                            color: Color.alphaBlend(
                                (selectedBusStop == stop
                                        ? Theme.of(context)
                                            .colorScheme
                                            .secondary
                                        : selectedBusStop == null &&
                                                nearestBusStop == stop
                                            ? Theme.of(context)
                                                .colorScheme
                                                .primary
                                            : Colors.transparent)
                                    .withOpacity(0.25),
                                Theme.of(context).cardColor),
                            type: MaterialType.card,
                            borderRadius: BorderRadius.circular(8.0),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(8.0),
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
                            type: MaterialType.transparency,
                            // color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(8.0),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(8.0),
                              onTap: () {
                                context.read<BusModel>().selectBusStop(stop);
                              },
                              child: const Icon(Icons.place_rounded),
                            ),
                          ),
                        ],
                      ),
                    ),
                  },
                  Marker(
                    width: 16.0,
                    height: 16.0,
                    point: snapshot.data ??
                        context.watch<BusModel>().currentLocation!,
                    builder: (ctx) => Material(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                ],
              ),
            ],
          );
        });
  }

  Widget _buildBusStop(
      BuildContext context, BusStop? busStop, bool isSelected) {
    return Builder(
      builder: (context) => Hero(
        tag: 'busStopCard',
        child: busStop != null
            ? AnimatedSize(
                vsync: this,
                duration: const Duration(milliseconds: 100),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 100),
                  child: BusStopView(
                    key: ValueKey(busStop),
                    busStop: busStop,
                    canExpand: true,
                    expanded: isSelected,
                    overline:
                        isSelected ? 'SELECTED BUS STOP' : 'NEAREST BUS STOP',
                  ),
                ),
              )
            : Container(),
      ),
    );
  }
}
