//Packages
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//Local Files
import '/screens/dashboard_screen.dart';
import '/screens/loading_screen.dart';
import '/screens/login_screen.dart';
import 'model/auth/auth_cubit.dart';
import 'model/auth/session_cubit.dart';
import 'model/auth/session_state.dart';

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
            const MaterialPage(child: DashboardScreen()),
        ],
        onPopPage: (route, result) => route.didPop(result),
      );
    });
  }
}
