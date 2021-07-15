//Packages
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

//Local Files
import 'model/auth/session_cubit.dart';
import 'model/auth/session_state.dart';
import 'model/auth/user.dart';
import 'model/bus_model.dart';
import 'model/dining/dining_model.dart';
import 'model/green_pass_model.dart';
import 'model/temperature/temperature_model.dart';
import 'model/user_model.dart';
import 'repository/bus_repository.dart';
import 'repository/dining_repository.dart';
import 'repository/user_repository.dart';
import 'screens/dashboard_screen.dart';
import 'screens/loading_screen.dart';
import 'screens/login_screen.dart';

class AppNavigator extends StatelessWidget {
  AppNavigator({Key? key, required this.navigatorKey}) : super(key: key);

  final GlobalKey<NavigatorState> navigatorKey;
  final GlobalKey<NavigatorState> dashboardNavigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(builder: (context, state) {
      return Theme(
        data: Theme.of(context).copyWith(
            pageTransitionsTheme: const PageTransitionsTheme(builders: {
          TargetPlatform.android: SharedAxisPageTransitionsBuilder(
              transitionType: SharedAxisTransitionType.scaled),
          TargetPlatform.iOS: SharedAxisPageTransitionsBuilder(
              transitionType: SharedAxisTransitionType.scaled),
        })),
        child: Navigator(
          key: navigatorKey,
          // initialRoute: '/',
          // onGenerateRoute: (settings) {
          //   if (settings.name == '/') {

          //   }
          // },
          pages: [
            //Loading screen
            if (state is UnknownSessionState)
              const MaterialPage(
                name: '/',
                key: ValueKey(LoadingScreen),
                child: LoadingScreen(),
              ),

            //Show login screen
            if (state is Unauthenticated)
              const MaterialPage(
                name: '/',
                key: ValueKey(LoginScreen),
                child: LoginScreen(),
              ),

            //Show dashboard
            if (state is Authenticated)
              MaterialPage(
                name: '/',
                key: const ValueKey(DashboardScreen),
                child: _buildWithContext(
                    user: state.user, child: const DashboardScreen()),
              ),
          ],
          onPopPage: (route, result) => route.didPop(result),
        ),
      );
    });
  }

  Widget _buildWithContext({required AuthUser user, required Widget child}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserRepository(user)),
        RepositoryProvider(create: (context) => DiningRepository(user: user)),
        RepositoryProvider(create: (context) => BusRepository())
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (context) => UserModel(context.read<UserRepository>())),
          ChangeNotifierProvider(
              create: (context) =>
                  DiningModel(context.read<DiningRepository>())),
          ChangeNotifierProvider(
              create: (context) =>
                  GreenPassModel(context.read<UserRepository>())),
          ChangeNotifierProvider(
              create: (context) =>
                  TemperatureModel(context.read<UserRepository>())),
          ChangeNotifierProvider(
              create: (context) => BusModel(context.read<BusRepository>()))
        ],
        child: WillPopScope(
          // Handles system back navigation when in back navigation
          onWillPop: () async =>
              !await dashboardNavigatorKey.currentState!.maybePop(),
          child: Builder(
            builder: (context) => Theme(
              data: Theme.of(context)
                  .copyWith(pageTransitionsTheme: const PageTransitionsTheme()),
              child: Navigator(
                key: dashboardNavigatorKey,
                pages: [
                  MaterialPage(child: child),
                ],
                onPopPage: (route, result) => route.didPop(result),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
