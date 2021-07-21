//Packages
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

//Local Files
import '../model/auth/session_cubit.dart';
import '../model/bus_model.dart';
import '../model/dining/dining_model.dart';
import '../model/dining/menu.dart';
import '../model/news/news.dart';
import '../model/temperature/temperature_state.dart';
import '../model/user_model.dart';
import '../repository/news_repository.dart';
import '../widgets/bus_stop_view.dart';
import 'bus_search_screen.dart';
import 'buses_screen.dart';
import 'dining_screen.dart';
import 'green_pass_screen.dart';
import 'news_article_screen.dart';
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

  @override
  Widget build(BuildContext context) {
    final userName = context.watch<UserModel>().userName;
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              floating: true,
              pinned: true,
              backwardsCompatibility: false,
              systemOverlayStyle: SystemUiOverlayStyle(
                systemNavigationBarColor: Colors.transparent,
                systemNavigationBarIconBrightness:
                    Theme.of(context).brightness == Brightness.light
                        ? Brightness.dark
                        : Brightness.light,
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
                    Text(
                      'multiverse',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.spartan(
                        textStyle: Theme.of(context).textTheme.headline5,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                //Temp sign out button
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 8.0),
                  child: TextButton(
                      onPressed: () => signOut(context),
                      child: const Text('Sign out')),
                ),
              ],
            ),
          ];
        },
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Hello, $userName!',
                        style: Theme.of(context).textTheme.headline5),
                    _buildTemperatureButton(),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _buildGreenPassCard(),
              ),
              const SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Flexible(child: _buildDiningCard()),
                    const SizedBox(width: 8.0),
                    Expanded(child: _buildNUSDetailsCard()),
                  ],
                ),
              ),
              const SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _buildBusStopsCard(),
              ),
              _buildNewsList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTemperatureButton() {
    final temperatureState = context.watch<UserModel>().temperatureState;
    final label = temperatureState == TemperatureState.acceptable
        ? 'Declared'
        : temperatureState == TemperatureState.undeclared
            ? 'Undeclared'
            : 'Unacceptable';
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
                  color: context.watch<UserModel>().temperatureState ==
                          TemperatureState.acceptable
                      ? Theme.of(context).hintColor
                      : Theme.of(context).colorScheme.error),
              Transform.translate(
                offset: const Offset(12, 12),
                child: Icon(
                    context.watch<UserModel>().temperatureState ==
                            TemperatureState.acceptable
                        ? Icons.check_circle
                        : Icons.cancel,
                    size: 16,
                    color: context.watch<UserModel>().temperatureState ==
                            TemperatureState.acceptable
                        ? Colors.green
                        : Theme.of(context).colorScheme.error),
              )
            ],
          ),
          label: Text(
            label,
            style: TextStyle(
                color: context.watch<UserModel>().temperatureState ==
                        TemperatureState.acceptable
                    ? Theme.of(context).hintColor
                    : Theme.of(context).colorScheme.error),
          ),
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
          ),
        );
      },
      openBuilder: (_, closeContainer) => const TemperatureScreen(),
    );
  }

  Widget _buildGreenPassCard() {
    final temperatureState = context.watch<UserModel>().temperatureState;
    final subtitle = temperatureState == TemperatureState.acceptable
        ? 'Temperature declared'
        : temperatureState == TemperatureState.undeclared
            ? 'Declare temperature first'
            : 'Temperature unacceptable';
    return _buildCard(
      disabled: context.watch<UserModel>().temperatureState !=
          TemperatureState.acceptable,
      collapsedColor: context.watch<UserModel>().temperatureState ==
              TemperatureState.acceptable
          ? (Theme.of(context).brightness == Brightness.light
              ? Colors.green.shade300
              : Colors.green.shade700)
          : Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
      // Disabled background color chosen according to default ElevatedButton style.
      collapsed: Container(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.gpp_good,
                color: context.watch<UserModel>().temperatureState ==
                        TemperatureState.acceptable
                    ? null
                    : Theme.of(context).disabledColor),
            const SizedBox(width: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('View Green Pass',
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                          color: context.watch<UserModel>().temperatureState ==
                                  TemperatureState.acceptable
                              ? null
                              : Theme.of(context).disabledColor,
                        )),
                Text(subtitle,
                    style: Theme.of(context).textTheme.subtitle2?.copyWith(
                          color: context.watch<UserModel>().temperatureState ==
                                  TemperatureState.acceptable
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
      expandedColor: DiningScreen.bottomColor,
      collapsedColor: DiningScreen.bottomColor,
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
                Text(
                    context
                            .watch<DiningModel>()
                            .currentMealType
                            ?.toShortString() ??
                        'Loading',
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(color: Colors.white)),
                Text(context.watch<DiningModel>().cardSubtitle,
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
    // return InkWell(
    //   onTap: () {
    //     print(Navigator.of(context));
    //     Navigator.of(context)
    //         .push(MaterialPageRoute<void>(builder: (context) => BusesScreen()));
    //   },
    //   child: Container(
    //     padding: const EdgeInsets.all(16.0),
    //     child: Column(
    //       mainAxisSize: MainAxisSize.min,
    //       children: [
    //         Row(
    //           crossAxisAlignment: CrossAxisAlignment.center,
    //           children: [
    //             const Icon(Icons.directions_bus),
    //             const SizedBox(width: 16.0),
    //             Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 Text('Bus stops',
    //                     style: Theme.of(context).textTheme.headline6),
    //               ],
    //             ),
    //           ],
    //         ),
    //         const SizedBox(height: 16.0),
    //         Hero(
    //           transitionOnUserGestures: true,
    //           tag: 'busStopCard',
    //           child: BusStopView(
    //               busStop: context.watch<BusModel>().nearestBusStop!),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
    return OpenContainer(
      closedShape: Theme.of(context).cardTheme.shape!,
      tappable: false,
      closedColor: Theme.of(context).cardColor,
      // collapsedBorder: Border.all(
      //   color: Theme.of(context).dividerColor,
      // ),
      closedBuilder: (context, openContainer) => GestureDetector(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  // mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.directions_bus),
                    const SizedBox(width: 16.0),
                    Text(
                      'Buses',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'GET AROUND NUS',
                  style: Theme.of(context).textTheme.overline,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.map_rounded),
                title: const Text('Campus map'),
                horizontalTitleGap: 0,
                onTap: openContainer,
              ),
              ListTile(
                leading: const Icon(Icons.format_list_bulleted_rounded),
                title: const Text('Bus routes and stops'),
                horizontalTitleGap: 0,
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const BusSearchScreen()));
                },
              ),
              if (context.watch<BusModel>().nearestBusStop != null) ...{
                const Divider(),
                const SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: BusStopView(
                      canExpand: true,
                      expanded: false,
                      busStop: context.watch<BusModel>().nearestBusStop!,
                      overline: 'NEAREST BUS STOP'),
                ),
              }
            ],
          ),
        ),
      ),
      openBuilder: (context, _) => const BusesScreen(),
    );
  }

  /// A wrapper for a generic card in the dashboard that can expand to show
  /// a full page.
  Widget _buildCard({
    required Widget collapsed,
    required Widget expanded,
    required Color collapsedColor,
    Color? expandedColor,
    Border? collapsedBorder,
    bool disabled = false,
  }) {
    // From Flutter animations library that animates a container from to and
    // from its open and closed states.

    // The collapsed (closed) widget is the card on the dashboard.
    // The expanded (open) widget is the full page.
    return OpenContainer(
      closedColor: collapsedColor,
      openColor: expandedColor ?? Theme.of(context).canvasColor,
      tappable: false,
      // To prevent interference with InkWell; to draw ripples
      openBuilder: (_, closeContainer) => expanded,
      closedBuilder: (_, openContainer) => Material(
        color: collapsedColor,
        child: InkWell(
          onTap: disabled ? null : openContainer,
          child: Container(
            decoration: BoxDecoration(
              borderRadius:
                  (Theme.of(context).cardTheme.shape as RoundedRectangleBorder)
                      .borderRadius,
              border: collapsedBorder,
            ),
            child: collapsed,
          ),
        ),
      ),
      closedShape: Theme.of(context).cardTheme.shape!,
      closedElevation: 0,
    );
  }

  Widget _buildNewsList() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 16.0),
          child: Row(
            children: [
              const Icon(Icons.feed),
              const SizedBox(width: 16.0),
              Text('News', style: Theme.of(context).textTheme.headline6),
            ],
          ),
        ),
        FutureBuilder<List<News>>(
          future: context.read<NewsRepository>().fetchNews(),
          builder: (context, snapshot) {
            // ignore: omit_local_variable_types
            final List<News?> data = snapshot.data ?? [null, null, null];
            return MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, position) {
                  final item = data[position];
                  final stack = Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 16.0),
                            ClipRRect(
                              clipBehavior: Clip.antiAlias,
                              borderRadius: BorderRadius.circular(8.0),
                              child: AspectRatio(
                                aspectRatio: 3,
                                child: item != null
                                    ? Image.network(
                                        item.coverImageUrl,
                                        fit: BoxFit.cover,
                                      )
                                    : Container(
                                        color: Colors.white,
                                      ),
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            if (item != null) ...{
                              Text(
                                DateFormat('dd MMMM yyyy').format(item.date),
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2
                                    ?.copyWith(
                                        color: Theme.of(context).hintColor),
                              ),
                            } else ...{
                              Container(
                                color: Colors.white,
                                child: Text(
                                  '12 3456 7890',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      ?.copyWith(color: Colors.transparent),
                                ),
                              ),
                            },
                            if (item != null) ...{
                              Text(
                                item.title,
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                            } else ...{
                              Container(
                                color: Colors.white,
                                child: Text(
                                  'Random text',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      ?.copyWith(color: Colors.transparent),
                                ),
                              )
                            },
                            const SizedBox(height: 16.0),
                          ],
                        ),
                      ),
                      if (item != null)
                        Positioned.fill(
                          child: Material(
                            type: MaterialType.transparency,
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        NewsArticleScreen(item)));
                              },
                            ),
                          ),
                        )
                    ],
                  );
                  return item == null
                      ? Shimmer.fromColors(
                          baseColor: Theme.of(context).scaffoldBackgroundColor,
                          highlightColor: Theme.of(context).highlightColor,
                          child: stack,
                        )
                      : stack;
                },
                itemCount: data.length,
              ),
            );
          },
        ),
      ],
    );
  }

  //temp
  void signOut(BuildContext context) {
    context.read<SessionCubit>().logout();
  }
}
