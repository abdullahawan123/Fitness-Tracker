import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Primary Gradients
  static const List<Color> primaryGradient = [
    Color(0xFF6366F1), // Indigo
    Color(0xFFA855F7), // Purple
  ];

  static const Color primary = Color(0xFF6366F1);
  static const Color accent = Color(0xFF22C55E); // Success Green
  static const Color neonGreen = Color(0xFFADFF2F);

  // Dark Backgrounds
  static const Color background = Color(0xFF0F172A); // Slate 900
  static const Color surface = Color(0xFF1E293B); // Slate 800
  static const Color cardBg = Color(0xFF334155); // Slate 700

  // Light Backgrounds
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color surfaceLight = Colors.white;

  // Text
  static const Color textBody = Color(0xFF94A3B8); // Slate 400
  static const Color textBodyLight = Color(0xFF64748B);
  static const Color textHeading = Colors.white;
  static const Color textHeadingLight = Color(0xFF0F172A);

  // Special
  static const Color glassBorder = Color(0x33FFFFFF);
  static const Color glassHighlight = Color(0x1AFFFFFF);
  static const Color glassHighlightLight = Color(0x0D000000);
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.surface,
      ),
      textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme)
          .copyWith(
            displayLarge: GoogleFonts.outfit(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.textHeading,
            ),
            headlineMedium: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: AppColors.textHeading,
            ),
            bodyLarge: GoogleFonts.outfit(
              fontSize: 16,
              color: AppColors.textHeading,
            ),
            bodyMedium: GoogleFonts.outfit(
              fontSize: 14,
              color: AppColors.textBody,
            ),
          ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.surfaceLight,
      ),
      textTheme: GoogleFonts.outfitTextTheme(ThemeData.light().textTheme)
          .copyWith(
            displayLarge: GoogleFonts.outfit(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.textHeadingLight,
            ),
            headlineMedium: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: AppColors.textHeadingLight,
            ),
            bodyLarge: GoogleFonts.outfit(
              fontSize: 16,
              color: AppColors.textHeadingLight,
            ),
            bodyMedium: GoogleFonts.outfit(
              fontSize: 14,
              color: AppColors.textBodyLight,
            ),
          ),
    );
  }
}
