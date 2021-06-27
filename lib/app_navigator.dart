//Packages
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

//Local Files
import '../model/user_model.dart';
import '../repository/dining_repository.dart';
import '../repository/user_repository.dart';
import '../screens/dashboard_screen.dart';
import '../screens/loading_screen.dart';
import '../screens/login_screen.dart';
import 'model/auth/auth_cubit.dart';
import 'model/auth/session_cubit.dart';
import 'model/auth/session_state.dart';
import 'model/dining/dining_model.dart';
import 'model/green_pass_model.dart';

class AppNavigator extends StatelessWidget {
  const AppNavigator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(builder: (context, state) {
      return Navigator(
        pages: [
          //Loading screen
          if (state is UnknownSessionState)
            const MaterialPage(child: LoadingScreen()),

          //Show login screeen
          if (state is Unauthenticated)
            MaterialPage(
                child: BlocProvider(
                    create: (context) =>
                        AuthCubit(sessionCubit: context.read<SessionCubit>()),
                    child: LoginScreen())),

          //Show dashboard
          if (state is Authenticated)
            MaterialPage(
                child: MultiRepositoryProvider(
              providers: [
                RepositoryProvider(
                    create: (context) => UserRepository(
                        userUID: context.read<SessionCubit>().userUID)),
                RepositoryProvider(
                    create: (context) => DiningRepository(
                        userUID: context.read<SessionCubit>().userUID)),
              ],
              child: MultiProvider(
                providers: [
                  ChangeNotifierProvider(
                      create: (context) =>
                          UserModel(context.read<UserRepository>())),
                  ChangeNotifierProvider(
                    create: (context) =>
                        DiningModel(context.read<DiningRepository>()),
                  ),
                  ChangeNotifierProvider(
                    create: (context) =>
                        GreenPassModel(context.read<UserRepository>()),
                  ),
                ],
                child: const DashboardScreen(),
              ),
            ))
        ],
        onPopPage: (route, result) => route.didPop(result),
      );
    });
  }
}
