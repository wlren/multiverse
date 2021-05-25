import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../auth/auth_repo.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'multiverse',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32.0),
          ),
        ),
        textTheme: GoogleFonts.senTextTheme().copyWith(
          subtitle1: const TextStyle(
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      home: RepositoryProvider(
        create: (context) => AuthRepository(),
        child: LoginScreen(),
      ),
      debugShowCheckedModeBanner: false, // Hide debug flag
    );
  }
}
