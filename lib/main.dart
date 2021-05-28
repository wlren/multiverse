import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multiverse/dining_repository.dart';
import 'package:multiverse/view_model/dining_model.dart';
import 'package:multiverse/view_model/user_model.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multiverse/user_repository.dart';

import '../auth/auth_repository.dart';
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
    ThemeData lightThemeData = ThemeData(
      primarySwatch: Colors.deepOrange,
      accentColor: Colors.blueAccent,
      appBarTheme: AppBarTheme(
        backgroundColor: ThemeData.light().canvasColor,
      ),
      cardTheme: CardTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          )
      ),
      textTheme: GoogleFonts.senTextTheme(
        ThemeData.light().textTheme,
      ).copyWith(
        subtitle1: GoogleFonts.senTextTheme().subtitle1?.copyWith(
          fontWeight: FontWeight.w400,
        ),
      ),
    );
    ThemeData darkThemeData = ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.orange,
      accentColor: Colors.blueAccent,
      appBarTheme: AppBarTheme(
        backgroundColor: ThemeData.dark().canvasColor,
      ),
      cardTheme: CardTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        )
      ),
      textTheme: GoogleFonts.senTextTheme(
        ThemeData.dark().textTheme,
      ).copyWith(
        subtitle1: GoogleFonts.senTextTheme(
          ThemeData.dark().textTheme,
        ).subtitle1?.copyWith(
          fontWeight: FontWeight.w400,
        ),
      ),
    );
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => AuthRepository()),
        RepositoryProvider(create: (context) => UserRepository()),
        RepositoryProvider(create: (context) => DiningRepository()),
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => UserModel(context.read<UserRepository>())
          ),
          ChangeNotifierProvider(
              create: (context) => DiningModel(context.read<DiningRepository>()),
          ),
        ],
        child: MaterialApp(
          title: 'multiverse',
          theme: lightThemeData,
          darkTheme: darkThemeData,
          themeMode: ThemeMode.system,
          home: LoginScreen(),
          debugShowCheckedModeBanner: false, // Hide debug flag
        ),
      ),
    );
  }
}
