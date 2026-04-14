import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primary = Color(0xFF2D861B);
  static const Color primaryLight = Color(0xFF95C427);
  static const Color textDark = Color(0xFF252422);
  static const Color textBody = Color(0xFF212121);
  static const Color white = Colors.white;
  static const Color background = Color(0xFFF5F5F5);
  static const Color cardBg = Colors.white;

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}

ThemeData appTheme() {
  return ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
    ),
    textTheme: GoogleFonts.firaSansTextTheme().copyWith(
      headlineLarge: GoogleFonts.firaSans(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: AppColors.textDark,
      ),
      headlineMedium: GoogleFonts.firaSans(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.textDark,
      ),
      titleLarge: GoogleFonts.firaSans(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
      ),
      titleMedium: GoogleFonts.firaSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
      ),
      bodyLarge: GoogleFonts.firaSans(
        fontSize: 16,
        color: AppColors.textBody,
        height: 1.6,
      ),
      bodyMedium: GoogleFonts.firaSans(
        fontSize: 14,
        color: AppColors.textBody,
        height: 1.5,
      ),
      labelSmall: GoogleFonts.firaSans(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: AppColors.white,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.white,
      foregroundColor: AppColors.textDark,
      elevation: 1,
      titleTextStyle: GoogleFonts.firaSans(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.textDark,
      ),
    ),
  );
}
