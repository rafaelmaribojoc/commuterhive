import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static TextTheme _buildTextTheme() {
    final display = GoogleFonts.fredokaTextTheme();
    final body = GoogleFonts.quicksandTextTheme();

    return TextTheme(
      displayLarge: display.displayLarge!.copyWith(color: AppColors.textMain),
      displayMedium: display.displayMedium!.copyWith(color: AppColors.textMain),
      displaySmall: display.displaySmall!.copyWith(color: AppColors.textMain),
      headlineLarge: display.headlineLarge!.copyWith(
        color: AppColors.textMain,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: display.headlineMedium!.copyWith(
        color: AppColors.textMain,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: display.headlineSmall!.copyWith(
        color: AppColors.textMain,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: display.titleLarge!.copyWith(
        color: AppColors.textMain,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: display.titleMedium!.copyWith(
        color: AppColors.textMain,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: display.titleSmall!.copyWith(
        color: AppColors.textMain,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: body.bodyLarge!.copyWith(color: AppColors.textMain),
      bodyMedium: body.bodyMedium!.copyWith(color: AppColors.textMain),
      bodySmall: body.bodySmall!.copyWith(color: AppColors.textMuted),
      labelLarge: display.labelLarge!.copyWith(
        color: AppColors.textMain,
        fontWeight: FontWeight.bold,
      ),
      labelMedium: display.labelMedium!.copyWith(
        color: AppColors.textMain,
        fontWeight: FontWeight.bold,
      ),
      labelSmall: display.labelSmall!.copyWith(
        color: AppColors.textMuted,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  static ThemeData get lightTheme {
    final textTheme = _buildTextTheme();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      textTheme: textTheme,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.textMain,
        secondary: AppColors.accent,
        onSecondary: Colors.white,
        surface: AppColors.surface,
        onSurface: AppColors.textMain,
        error: AppColors.accent,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: AppColors.cardBorder),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: Colors.transparent, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.textMain,
        unselectedItemColor: AppColors.textMuted,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textMain,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
    );
  }
}
