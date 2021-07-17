import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:provider/provider.dart';

import '../model/bus/bus_route.dart';
import '../model/bus_model.dart';
import '../widgets/bus_stop_view.dart';
import 'bus_route_screen.dart';

class BusSearchScreen extends StatelessWidget {
  const BusSearchScreen({Key? key}) : super(key: key);

  static const double horizontalPadding = 32.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backwardsCompatibility: false,
        elevation: 0,
      ),
      body: CustomScrollView(
        // clipBehavior:
        // clipBehavior: Clip.none,,
        clipBehavior: Clip.none,
        // padding: const EdgeInsets.symmetric(horizontal: 32.0),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.only(top: 16.0),
            sliver: SliverToBoxAdapter(
              child: Container(),
            ),
          ),
          // SliverAppBar(
          //   title: Text(
          //     'Bus routes',
          //     style: Theme.of(context)
          //         .textTheme
          //         .headline5
          //         ?.copyWith(fontWeight: FontWeight.bold),
          //   ),
          //   titleSpacing: horizontalPadding,
          //   backwardsCompatibility: false,
          //   floating: true,
          //   // pinned: true,
          //   automaticallyImplyLeading: false,
          // ),
          SliverStickyHeader.builder(
            builder: (context, state) => AppBar(
              elevation: state.isPinned ? 4 : 0,
              automaticallyImplyLeading: false,
              titleSpacing: horizontalPadding,
              backwardsCompatibility: false,
              title: Text('Bus routes',
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      ?.copyWith(fontWeight: FontWeight.bold)),
            ),
            sliver: SliverPadding(
              padding: const EdgeInsets.only(
                left: horizontalPadding,
                right: horizontalPadding,
                bottom: 32.0,
              ),
              sliver: SliverGrid.count(
                crossAxisCount: 3,
                childAspectRatio: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                children: [
                  for (BusRoute route
                      in context.watch<BusModel>().busRoutes ?? []) ...{
                    _buildRouteName(context, route),
                  },
                ],
              ),
            ),
          ),
          SliverStickyHeader.builder(
            builder: (context, state) => Material(
              elevation: state.isPinned ? 4 : 0,
              child: SizedBox(
                height: kToolbarHeight,
                child: Row(
                  children: [
                    const SizedBox(width: 32.0),
                    Text('Bus stops',
                        style: Theme.of(context)
                            .textTheme
                            .headline5
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const Spacer(),
                    InkWell(
                      borderRadius: BorderRadius.circular(32.0),
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32.0),
                          border: Border.all(
                              color: state.isPinned
                                  ? Colors.transparent
                                  : Theme.of(context).dividerColor),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Icon(Icons.search),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                  ],
                ),
              ),
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                if (context.watch<BusModel>().busStops != null) ...{
                  const SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: horizontalPadding),
                    child: BusStopView(
                      overline: 'NEAREST',
                      compact: false,
                      busStop: context.watch<BusModel>().busStops!.first,
                    ),
                  ),
                  for (var busStop
                      in context.watch<BusModel>().busStops!.skip(1)) ...{
                    // ignore: prefer_const_constructors
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: horizontalPadding),
                      child: BusStopView(
                        busStop: busStop,
                        overline: busStop
                                .distanceTo(
                                    context.watch<BusModel>().userLocation)
                                .toStringAsFixed(0) +
                            'm away',
                      ),
                    ),
                  },
                },
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteName(BuildContext context, BusRoute route) {
    return OpenContainer(
      openColor: Color.alphaBlend(
          route.color, Theme.of(context).scaffoldBackgroundColor),
      closedColor: Color.alphaBlend(
          route.color, Theme.of(context).scaffoldBackgroundColor),
      closedBuilder: (context, openContainer) => InkWell(
        splashColor: route.color,
        borderRadius: BorderRadius.circular(8.0),
        onTap: openContainer,
        child: Center(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Hero(
              tag: route.name,
              child: Text(
                route.name,
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
          ),
        ),
      ),
      openBuilder: (context, _) => BusRouteScreen(route: route),
    );
  }
}
