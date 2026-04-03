import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: AppColors.scaffoldBackground,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryBlue),
      useMaterial3: true,
      textTheme: GoogleFonts.interTextTheme(),
      fontFamily: 'Inter',
    );
  }
}

class AppConstants {
  AppConstants._();

  static const String fontFamily = 'Inter';
}
