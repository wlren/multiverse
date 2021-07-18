import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/bus/bus.dart';
import '../model/bus/bus_arrival_info.dart';
import '../model/bus/bus_route.dart';
import '../model/bus/bus_stop.dart';
import '../model/bus_model.dart';

final List<BusArrivalInfo> allBusArrivals = [
  const BusArrivalInfo(name: 'A1', buses: [
    Bus(arrivalTimeMins: 9, vehiclePlate: 'A1BUS'),
    Bus(arrivalTimeMins: 12, vehiclePlate: 'A1BUS'),
  ]),
  const BusArrivalInfo(name: 'A2', buses: [
    Bus(arrivalTimeMins: 3, vehiclePlate: 'A1BUS'),
    Bus(arrivalTimeMins: 4, vehiclePlate: 'A1BUS'),
  ]),
];

class BusStopView extends StatefulWidget {
  const BusStopView(
      {Key? key, required this.busStop, this.overline, this.compact = true})
      : super(key: key);

  final BusStop busStop;
  final String? overline;

  /// Whether to display compact/detailed information
  final bool compact;

  @override
  _BusStopViewState createState() => _BusStopViewState();
}

class _BusStopViewState extends State<BusStopView>
    with SingleTickerProviderStateMixin {
  final List<BusArrivalInfo> busArrivals = allBusArrivals;

  @override
  Widget build(BuildContext context) {
    final title = widget.busStop.shortDisplayName;
    // final subtitle = widget.busStop.longDisplayName;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.overline != null)
          Text(widget.overline!, style: Theme.of(context).textTheme.overline),
        SizedBox(
          width: MediaQuery.of(context).size.width - 128,
          child: AutoSizeText(
            title,
            maxLines: 1,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        const SizedBox(height: 16.0),
        AnimatedSize(
          vsync: this,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _buildDetails(context),
          ),
        ),
      ],
    );
  }

  Widget _buildDetails(BuildContext context) {
    if (!widget.compact) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (BusArrivalInfo info in busArrivals)
            _buildBusArrivalInfo(context, info),
        ],
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          children: [
            for (BusArrivalInfo info in busArrivals) ...{
              _buildRouteName(
                  context.watch<BusModel>().getRouteWithName(info.name)!),
              const SizedBox(width: 8.0),
            }
          ],
        ),
      );
    }
  }

  Widget _buildBusArrivalInfo(
      BuildContext context, BusArrivalInfo busArrivalInfo) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.,
      children: [
        _buildRouteName(
            context.read<BusModel>().getRouteWithName(busArrivalInfo.name)!),
        Row(
          children: [
            for (Bus bus in busArrivalInfo.buses) ...{
              const SizedBox(width: 32.0),
              Text(
                '${bus.arrivalTimeMins} min',
                style: Theme.of(context).textTheme.subtitle1,
              ),
            },
          ],
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: () {},
        )
      ],
    );
  }

  Widget _buildRouteName(BusRoute route) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: route.color,
      ),
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Text(route.name),
    );
  }
}
