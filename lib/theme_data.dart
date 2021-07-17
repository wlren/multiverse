//Packages
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//Light and dark theme data for application
//#darkthemeftw
class ThemeDataMultiverse {
  static ThemeData lightThemeData = ThemeData(
    primarySwatch: Colors.deepOrange,
    accentColor: Colors.blueAccent,
    appBarTheme: AppBarTheme(
      backgroundColor: ThemeData.light().canvasColor,
      foregroundColor: ThemeData.light().colorScheme.onSurface,
    ),
    cardTheme: CardTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
    ),
    popupMenuTheme: PopupMenuThemeData(
        shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    )),
    textTheme: GoogleFonts.senTextTheme(
      ThemeData.light().textTheme,
    ).copyWith(
      subtitle1: GoogleFonts.senTextTheme().subtitle1?.copyWith(
            fontWeight: FontWeight.w400,
          ),
    ),
  );
  static ThemeData darkThemeData = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.orange,
    accentColor: Colors.blueAccent,
    appBarTheme: AppBarTheme(
      backgroundColor: ThemeData.dark().canvasColor,
    ),
    cardTheme: CardTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
    ),
    popupMenuTheme: PopupMenuThemeData(
        shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    )),
    textTheme: GoogleFonts.senTextTheme(
      ThemeData.dark().textTheme,
    ).copyWith(
      subtitle1: GoogleFonts.senTextTheme(ThemeData.dark().textTheme)
          .subtitle1
          ?.copyWith(
            fontWeight: FontWeight.w400,
          ),
    ),
  );
}
