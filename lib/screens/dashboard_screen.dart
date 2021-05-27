import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../view_model/user_model.dart';
import '../user_repository.dart';
import 'buses_screen.dart';
import 'dining_screen.dart';
import 'green_pass_screen.dart';
import 'nus_card_screen.dart';
import 'temperature_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final String logoName = 'assets/logo.svg';
  final DateFormat dateFormat = DateFormat('dd MMM (aa)');
  final ScrollController _scrollController = ScrollController();
  late final String dateString = dateFormat.format(DateTime.now());
  final String userName = 'John Smith';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
          body: NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  floating: true,
                  pinned: true,
                  backwardsCompatibility: false,
                  systemOverlayStyle: const SystemUiOverlayStyle(
                    statusBarColor: Colors.transparent,
                    statusBarIconBrightness: Brightness.dark,
                  ),
                  titleSpacing: 0,
                  title: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          logoName,
                          semanticsLabel: 'multiverse logo',
                          width: 32.0,
                        ),
                        const SizedBox(width: 8.0),
                        Text('multiverse',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.spartan(
                              textStyle: Theme.of(context).textTheme.headline5,
                            )),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Hello, $userName!',
                            style: Theme.of(context).textTheme.headline5),
                        _buildTemperatureButton(),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    _buildGreenPassCard(),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        Flexible(child: _buildDiningCard()),
                        const SizedBox(width: 8.0),
                        Expanded(child: _buildNUSDetailsCard()),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    _buildBusStopsCard(),
                    _buildNewsList(),
                  ],
                ),
              ),
            ),
          ),
    );
  }

  Widget _buildTemperatureButton() {
    return OpenContainer(
      closedElevation: 0,
      closedShape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      closedColor: Theme.of(context).canvasColor,
      closedBuilder: (_, openContainer) {
        return OutlinedButton.icon(
          onPressed: openContainer,
          icon: Stack(
            children: [
              Icon(Icons.thermostat,
                  color: context.watch<UserModel>().isTemperatureAcceptable
                      ? Theme.of(context).hintColor
                      : Theme.of(context).colorScheme.error),
              Transform.translate(
                offset: const Offset(12, 12),
                child: Icon(
                    context.watch<UserModel>().isTemperatureAcceptable ? Icons.check_circle : Icons.cancel,
                    size: 16,
                    color: context.watch<UserModel>().isTemperatureAcceptable
                        ? Colors.green
                        : Theme.of(context).colorScheme.error),
              )
            ],
          ),
          label: Text(
            context.watch<UserModel>().isTemperatureAcceptable ? 'Declared' : 'Not declared',
            style: TextStyle(
                color: context.watch<UserModel>().isTemperatureAcceptable
                    ? Theme.of(context).hintColor
                    : Theme.of(context).colorScheme.error),
          ),
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
          ),
        );
      },
      openBuilder: (_, closeContainer) => TemperatureScreen(),
    );
  }

  Widget _buildGreenPassCard() {
    return _buildCard(
      disabled: !context.watch<UserModel>().isTemperatureAcceptable,
      collapsedColor: context.watch<UserModel>().isTemperatureAcceptable
          ? Colors.green.shade300
          : Theme.of(context).colorScheme.onSurface.withOpacity(
              0.12), // Disabled background color chosen according to default ElevatedButton style.
      collapsed: Container(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.gpp_good,
                color: context.watch<UserModel>().isTemperatureAcceptable
                    ? null
                    : Theme.of(context).disabledColor),
            const SizedBox(width: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('View Green Pass',
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                          color: context.watch<UserModel>().isTemperatureAcceptable
                              ? null
                              : Theme.of(context).disabledColor,
                        )),
                Text('Declare temperature first',
                    style: Theme.of(context).textTheme.subtitle2?.copyWith(
                          color: context.watch<UserModel>().isTemperatureAcceptable
                              ? null
                              : Theme.of(context).disabledColor,
                        )),
              ],
            ),
          ],
        ),
      ),
      expanded: const GreenPassScreen(),
    );
  }

  Widget _buildDiningCard() {
    return _buildCard(
      expandedColor: const Color(0xFF424242),
      collapsedColor: const Color(0xFF424242),
      collapsed: Container(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.lunch_dining, color: Colors.white),
            const SizedBox(width: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Dinner',
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(color: Colors.white)),
                Text('10 credits',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        ?.copyWith(color: Colors.white)),
              ],
            ),
          ],
        ),
      ),
      expanded: const DiningScreen(),
    );
  }

  Widget _buildNUSDetailsCard() {
    return _buildCard(
      collapsedColor: NUSCardScreen.nusOrange,
      collapsed: Container(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.payment, color: Colors.white),
            const SizedBox(width: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('NUS Card',
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(color: Colors.white)),
                Text('View details',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        ?.copyWith(color: Colors.white)),
              ],
            ),
          ],
        ),
      ),
      expanded: const NUSCardScreen(),
    );
  }

  Widget _buildBusStopsCard() {
    return _buildCard(
      collapsedColor: const Color(0xFFF5DBCE),
      collapsed: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.directions_bus),
                const SizedBox(width: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Bus stops',
                        style: Theme.of(context).textTheme.headline6),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, position) {
                  // TODO: Update with actual bus stops
                  return ListTile(
                    contentPadding:
                        const EdgeInsets.only(left: 40.0, right: 16.0),
                    title: Text('Bus stop $position'),
                    subtitle: const Text('Some supplementary info'),
                  );
                },
                itemCount: 3,
              ),
            ),
          ],
        ),
      ),
      expanded: const BusesScreen(),
    );
  }

  /// A wrapper for a generic card in the dashboard that can expand to show
  /// a full page.
  Widget _buildCard({
    required Widget collapsed,
    required Widget expanded,
    required Color collapsedColor,
    Color? expandedColor,
    bool disabled = false,
  }) {
    // From Flutter animations library that animates a container from to and
    // from its open and closed states.

    // The collapsed (closed) widget is the card on the dashboard.
    // The expanded (open) widget is the full page.
    return OpenContainer(
      closedColor: collapsedColor,
      openColor: expandedColor ?? Theme.of(context).canvasColor,
      tappable: false, // To prevent interference with InkWell; to draw ripples
      openBuilder: (_, closeContainer) => InkWell(
        onTap: closeContainer,
        child: expanded,
      ),
      closedBuilder: (_, openContainer) => Material(
        color: collapsedColor,
        child: InkWell(
          onTap: disabled ? null : openContainer,
          child: collapsed,
        ),
      ),
      closedShape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      closedElevation: 0,
    );
  }

  Widget _buildNewsList() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Row(
            children: [
              const Icon(Icons.feed),
              const SizedBox(width: 16.0),
              Text('News', style: Theme.of(context).textTheme.headline6),
            ],
          ),
        ),
        const SizedBox(
          height: 1000,
          child: Text('This is a really tall container made to test scrolling'),
        ),
      ],
    );
  }
}
