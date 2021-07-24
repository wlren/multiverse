import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:provider/provider.dart';

import '../model/bus/bus_route.dart';
import '../model/bus_model.dart';
import '../widgets/bus_stop_view.dart';
import 'bus_route_screen.dart';

class BusSearchScreen extends StatefulWidget {
  const BusSearchScreen({Key? key}) : super(key: key);

  static const double horizontalPadding = 32.0;

  @override
  _BusSearchScreenState createState() => _BusSearchScreenState();
}

// TODO: Test out behaviour
class _BusSearchScreenState extends State<BusSearchScreen> {
  String _query = '';
  bool _isSearchOpen = false;

  bool get isSearchOpen => _isSearchOpen;

  set isSearchOpen(bool isSearchOpen) {
    _isSearchOpen = isSearchOpen;
    _scrollController.animateTo(0,
        duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  final TextEditingController _queryController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isSearchOpen) {
          setState(() {
            isSearchOpen = false;
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backwardsCompatibility: false,
          elevation: 0,
          titleSpacing: 0,
          title: isSearchOpen
              ? TextField(
                  autofocus: true,
                  controller: _queryController,
                  onChanged: (value) {
                    setState(() {
                      _query = value;
                    });
                  },
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    hintText: 'Search bus stops...',
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      color: Theme.of(context).hintColor,
                      icon: const Icon(Icons.clear_rounded),
                      onPressed: () {
                        setState(() {
                          _query = '';
                          _queryController.clear();
                        });
                      },
                    ),
                  ),
                )
              : null,
        ),
        body: CustomScrollView(
          controller: _scrollController,
          // clipBehavior:
          // clipBehavior: Clip.none,,
          clipBehavior: Clip.none,
          // padding: const EdgeInsets.symmetric(horizontal: 32.0),
          slivers: [
            if (!isSearchOpen) ...{
              SliverPadding(
                padding: const EdgeInsets.only(top: 16.0),
                sliver: SliverToBoxAdapter(
                  child: Container(),
                ),
              ),
              SliverStickyHeader.builder(
                builder: (context, state) => AppBar(
                  elevation: state.isPinned ? 4 : 0,
                  automaticallyImplyLeading: false,
                  titleSpacing: BusSearchScreen.horizontalPadding,
                  backwardsCompatibility: false,
                  title: Text('Bus routes',
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          ?.copyWith(fontWeight: FontWeight.bold)),
                ),
                sliver: SliverPadding(
                  padding: const EdgeInsets.only(
                    left: BusSearchScreen.horizontalPadding,
                    right: BusSearchScreen.horizontalPadding,
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
            },
            SliverStickyHeader.builder(
              builder: (context, state) => Material(
                elevation: state.isPinned ? 4 : 0,
                clipBehavior: Clip.antiAlias,
                child: SizedBox(
                  height: isSearchOpen ? 0 : kToolbarHeight,
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
                        onTap: () {
                          setState(() {
                            isSearchOpen = true;
                          });
                        },
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
                    if (_query.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: BusSearchScreen.horizontalPadding),
                        child: BusStopView(
                          overline: 'NEAREST',
                          expanded: true,
                          busStop: context.watch<BusModel>().busStops!.first,
                        ),
                      ),
                    for (var busStop in context
                        .watch<BusModel>()
                        .busStops!
                        .skip(_query.isEmpty ? 1 : 0)
                        .where((busStop) => busStop.shortDisplayName
                            .toLowerCase()
                            .contains(_query.toLowerCase()))) ...{
                      // ignore: prefer_const_constructors
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 16.0,
                          bottom: 8.0,
                          left: BusSearchScreen.horizontalPadding,
                          right: BusSearchScreen.horizontalPadding,
                        ),
                        child: BusStopView(
                          canExpand: true,
                          expanded: false,
                          busStop: busStop,
                          overline: busStop
                                  .distanceTo(context
                                      .watch<BusModel>()
                                      .currentLocation!)
                                  .toStringAsFixed(0) +
                              'm away',
                        ),
                      ),
                    },
                    Container(
                      height: MediaQuery.of(context).size.height,
                    )
                  },
                ]),
              ),
            ),
          ],
        ),
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
