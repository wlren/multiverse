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
  @override
  Widget build(BuildContext context) {
    // Providers inject dependencies into the app. Placed outside MaterialApp
    // to allow any screen to use this information.
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => AuthRepository()),
      ],
      child: MultiProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                SessionCubit(authRepository: context.read<AuthRepository>()),
          )
        ],
        child: MaterialApp(
          title: 'Multiverse',
          theme: ThemeDataMultiverse.lightThemeData,
          darkTheme: ThemeDataMultiverse.darkThemeData,
          themeMode: ThemeMode.system,
          home: const AppNavigator(),
          debugShowCheckedModeBanner: false, // Hide debug flag
        ),
      ),
    );
  }
}
