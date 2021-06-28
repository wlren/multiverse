//Packages
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

//Local Files
import 'app_navigator.dart';
import 'model/auth/session_cubit.dart';
import 'repository/auth_repository.dart';
import 'theme_data.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    // Providers inject dependencies into the app. Placed outside MaterialApp
    // to allow any screen to use this information.
    return RepositoryProvider(
      create: (context) => AuthRepository(),
      child: BlocProvider(
        create: (context) =>
            SessionCubit(authRepository: context.read<AuthRepository>()),
        child: MaterialApp(
          navigatorKey:
              _navigatorKey, // Used to assign AppNavigator as the root navigator
          onGenerateRoute: (_) => null,
          title: 'Multiverse',
          theme: ThemeDataMultiverse.lightThemeData,
          darkTheme: ThemeDataMultiverse.darkThemeData,
          themeMode: ThemeMode.system,
          builder: (context, _) => AppNavigator(navigatorKey: _navigatorKey),
          debugShowCheckedModeBanner: false, // Hide debug flag
        ),
      ),
    );
  }
}
