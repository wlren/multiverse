import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => AuthRepository()),
        RepositoryProvider(create: (context) => UserRepository()),
      ],
      child: ChangeNotifierProvider(
        create: (context) => UserModel(context.read<UserRepository>()),
        child: MaterialApp(
          title: 'multiverse',
          theme: ThemeData(
            primarySwatch: Colors.orange,
            appBarTheme: AppBarTheme(
              backgroundColor: Theme.of(context).canvasColor,
            ),
            cardTheme: CardTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32.0),
              ),
            ),
            textTheme: GoogleFonts.senTextTheme().copyWith(
              subtitle1: GoogleFonts.senTextTheme().subtitle1?.copyWith(
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          home: LoginScreen(),
          debugShowCheckedModeBanner: false, // Hide debug flag
        ),
      ),
    );
  }
}
