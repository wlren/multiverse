//Packages
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extend;

//Local Files
import '../classes/menu.dart';
import '../view_model/dining_model.dart';

class DiningScreen extends StatefulWidget {
  const DiningScreen({Key? key}) : super(key: key);

  static const Color topColor = Color(0xFF121212);
  static const Color bottomColor = Color(0xFF3D3D3D);

  @override
  _DiningScreenState createState() => _DiningScreenState();
}

class _DiningScreenState extends State<DiningScreen>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final double _expandedHeight = 320;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: Theme.of(context).colorScheme.copyWith(
              background: DiningScreen.bottomColor,
              surface: const Color(0xFF424242),
              onBackground: Colors.white,
              onSurface: Colors.white,
              onPrimary: Colors.white,
            ),
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
            ),
        tabBarTheme: Theme.of(context).tabBarTheme.copyWith(
              labelColor: Colors.white,
            ),
        scaffoldBackgroundColor: DiningScreen.bottomColor,
        dividerColor: Colors.white,
      ),
      child: Builder(
        builder: (context) => Scaffold(
          extendBodyBehindAppBar: true,
          body: DefaultTabController(
            length: 2,
            initialIndex: _getInitialTabIndex(context),
            child: extend.NestedScrollView(
              controller: _scrollController,
              headerSliverBuilder:
                  (BuildContext context, bool? innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    backwardsCompatibility: false,
                    backgroundColor: DiningScreen.bottomColor,
                    foregroundColor: Colors.white,
                    systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
                      statusBarColor: Colors.transparent,
                      statusBarIconBrightness: Brightness.light,
                    ),
                    pinned: true,
                    expandedHeight: _expandedHeight,
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.pin,
                      stretchModes: const [
                        StretchMode.fadeTitle,
                      ],
                      title: AnimatedBuilder(
                        animation: _scrollController,
                        builder: (BuildContext context, Widget? child) {
                          double collapsedPercentage =
                              // This is a hack to make sure error is not thrown
                              // ignore: invalid_use_of_protected_member
                              _scrollController.positions.length == 1
                                  ? _scrollController.offset
                                          .clamp(0, _expandedHeight) /
                                      _expandedHeight
                                  : 0;
                          return Transform.translate(
                            offset:
                                Offset(-24.0 * (1 - collapsedPercentage), 0),
                            child: child,
                          );
                        },
                        child: Text('Dining Menu',
                            style: Theme.of(context).textTheme.headline6),
                      ),
                      background: Container(
                        color: DiningScreen.topColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: kToolbarHeight +
                                      MediaQuery.of(context).padding.top,
                                  left: 72.0,
                                  bottom: 24.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (context
                                          .read<DiningModel>()
                                          .currentMealType !=
                                      MealType.none) ...{
                                    Text(
                                      '${context.read<DiningModel>().currentMealType!.toShortString()} · ${context.read<DiningModel>().mealLocation}',
                                      style:
                                          Theme.of(context).textTheme.headline4,
                                    ),
                                  } else ...{
                                    Text(
                                      'Meals closed',
                                      style:
                                          Theme.of(context).textTheme.headline4,
                                    ),
                                  },
                                  const SizedBox(height: 16.0),
                                  Text('You have:',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6),
                                  Text(
                                      '• ${context.read<DiningModel>().breakfastCreditCount} breakfast credits',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6),
                                  Text(
                                      '• ${context.read<DiningModel>().dinnerCreditCount} dinner credits',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6),
                                  const SizedBox(height: 16.0),
                                ],
                              ),
                            ),
                            Expanded(
                                child: Container(
                              decoration: const BoxDecoration(
                                color: DiningScreen.bottomColor,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16.0),
                                  topRight: Radius.circular(16.0),
                                ),
                              ),
                            ))
                          ],
                        ),
                      ),
                    ),
                  ),
                ];
              },
              pinnedHeaderSliverHeightBuilder: () {
                return MediaQuery.of(context).padding.top + kToolbarHeight;
              },
              body: Column(
                children: [
                  const TabBar(
                    tabs: [
                      Tab(
                        text: 'Breakfast',
                      ),
                      Tab(
                        text: 'Dinner',
                      ),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildMenu(context,
                            context.read<DiningModel>().menu.breakfast),
                        _buildMenu(
                            context, context.read<DiningModel>().menu.dinner),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton.extended(
            label: const Text('Scan QR'),
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () {},
          ),
        ),
      ),
    );
  }

  Widget _buildMenu(BuildContext context, Menu? menu) {
    if (menu == null) {
      return const Center(child: Text('No menu found'));
    } else {
      return CustomScrollView(slivers: [
        for (Meal meal in menu.meals) ...{
          SliverStickyHeader(
            sticky: false,
            header: Material(
              color: DiningScreen.bottomColor,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 32.0),
                child: Text(meal.cuisineName,
                    style: Theme.of(context).textTheme.headline6),
              ),
            ),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, position) => Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 48.0, vertical: 8.0),
                  child: Text(meal.mealItems[position].name),
                ),
                childCount: meal.mealItems.length,
              ),
            ),
          ),
          if (meal != menu.meals.last)
            const SliverToBoxAdapter(
              child: Divider(),
            ),
        },
        // To account for floating action button blocking last element
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 64.0,
          ),
        )
      ]);
    }
  }

  int _getInitialTabIndex(BuildContext context) {
    DiningModel diningModel = context.read<DiningModel>();
    switch (diningModel.currentMealType) {
      case MealType.breakfast:
        return 0;
      case MealType.dinner:
        return 1;
      case MealType.none:
        return 0;
      default:
        return 0;
    }
  }
}
