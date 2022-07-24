import 'package:bayzat_pokedex/config/constants.dart';
import "package:flutter/material.dart";

final lightThemeData = ThemeData(
  primaryColor: AppColors.primaryColor,
  scaffoldBackgroundColor: AppColors.scaffoldColor,
  fontFamily: Fonts.primary,
);

class Fonts {
  static const primary = "NotoSans";
}

class Insets {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
}
