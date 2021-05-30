//Packages
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

//Local Files
import '../classes/theme_data.dart';
import '../repository/dining_repository.dart';
import '../repository/user_repository.dart';
import '../view_model/dining_model.dart';
import '../view_model/user_model.dart';
import 'repository/auth_repository.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Providers inject dependencies into the app. Placed outside MaterialApp
    // to allow any screen to use this information.
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => AuthRepository()),
        RepositoryProvider(create: (context) => UserRepository()),
        RepositoryProvider(create: (context) => DiningRepository()),
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (context) => UserModel(context.read<UserRepository>())),
          ChangeNotifierProvider(
            create: (context) => DiningModel(context.read<DiningRepository>()),
          ),
        ],
        child: MaterialApp(
          title: 'Multiverse',
          theme: ThemeDataMultiverse.lightThemeData,
          darkTheme: ThemeDataMultiverse.darkThemeData,
          themeMode: ThemeMode.system,
          home: LoginScreen(),
          debugShowCheckedModeBanner: false, // Hide debug flag
        ),
      ),
    );
  }
}
