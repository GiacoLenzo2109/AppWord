import 'package:app_word/res/custom_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemeClass {
  static ThemeData lightTheme = ThemeData(
      scaffoldBackgroundColor: Colors.grey[100],
      colorScheme: const ColorScheme.light(),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        titleTextStyle: TextStyle(
            color: Colors.white, fontWeight: FontWeight.w900, fontSize: 25.0),
        backgroundColor: CustomColors.mediumBlue,
      ),
      primaryColorDark: Colors.grey[800],
      primaryColorLight: Colors.grey[100]);

  static ThemeData darkTheme = ThemeData(
      scaffoldBackgroundColor: CustomColors.darkGrey,
      colorScheme: const ColorScheme.dark(),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        titleTextStyle: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25.0),
        backgroundColor: CustomColors.mediumBlue,
      ),
      primaryColorDark: Colors.white,
      primaryColorLight: Colors.grey[800]);

  static CupertinoThemeData lightThemeCupertino = CupertinoThemeData(
    brightness: Brightness.light,
    primaryColor: CupertinoColors.activeBlue,
    primaryContrastingColor: Colors.grey[800],
    scaffoldBackgroundColor: Colors.grey[100],
    barBackgroundColor: Colors.white.withOpacity(0.50),
  );

  static CupertinoThemeData darkThemeCupertino = CupertinoThemeData(
    brightness: Brightness.dark,
    primaryColor: CupertinoColors.activeBlue,
    primaryContrastingColor: Colors.white,
    scaffoldBackgroundColor: CustomColors.darkGrey,
    barBackgroundColor: CustomColors.darkGrey.withOpacity(0.50),
  );
}
