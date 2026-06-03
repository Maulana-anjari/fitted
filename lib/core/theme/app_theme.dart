import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_radius.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.aiAccent,
          surface: AppColors.surface,
          error: AppColors.error,
          onPrimary: AppColors.textInverse,
          onSecondary: AppColors.textInverse,
          onSurface: AppColors.textPrimary,
          onError: AppColors.textInverse,
        ),
        scaffoldBackgroundColor: AppColors.background,
        textTheme: AppTypography.textTheme,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          scrolledUnderElevation: 1,
          centerTitle: false,
          titleTextStyle: AppTypography.heading3,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: AppColors.surface,
          selectedItemColor: AppColors.navActive,
          unselectedItemColor: AppColors.navInactive,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedLabelStyle: AppTypography.metadata.copyWith(
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: AppTypography.metadata,
          selectedIconTheme: const IconThemeData(size: 24),
          unselectedIconTheme: const IconThemeData(size: 24),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textInverse,
            minimumSize: const Size.fromHeight(44),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.button),
            ),
            textStyle: AppTypography.textTheme.labelLarge,
            elevation: 0,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            minimumSize: const Size.fromHeight(44),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.button),
            ),
            side: const BorderSide(color: AppColors.border),
            textStyle: AppTypography.textTheme.labelLarge,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surface,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.input),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.input),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.input),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.input),
            borderSide: const BorderSide(color: AppColors.error),
          ),
          textStyle: AppTypography.body,
          labelStyle: AppTypography.caption.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        cardTheme: CardThemeData(
          color: AppColors.surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.card),
            side: const BorderSide(color: AppColors.border),
          ),
          margin: EdgeInsets.zero,
        ),
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.surface,
          selectedColor: AppColors.primary,
          labelStyle: AppTypography.caption,
          secondaryLabelStyle: AppTypography.caption.copyWith(
            color: AppColors.textInverse,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.chip),
            side: const BorderSide(color: AppColors.border),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.border,
          thickness: 1,
          space: 1,
        ),
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(
          primary: AppColors.textInverse,
          secondary: AppColors.aiAccentLight,
          surface: AppColors.darkSurface,
          error: AppColors.errorLight,
          onPrimary: AppColors.darkBackground,
          onSecondary: AppColors.textInverse,
          onSurface: AppColors.darkTextPrimary,
          onError: AppColors.darkBackground,
        ),
        scaffoldBackgroundColor: AppColors.darkBackground,
        textTheme: AppTypography.textTheme.apply(
          bodyColor: AppColors.darkTextPrimary,
          displayColor: AppColors.darkTextPrimary,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.darkBackground,
          foregroundColor: AppColors.darkTextPrimary,
          elevation: 0,
          scrolledUnderElevation: 1,
          centerTitle: false,
          titleTextStyle: AppTypography.heading3.copyWith(
            color: AppColors.darkTextPrimary,
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: AppColors.darkSurface,
          selectedItemColor: AppColors.textInverse,
          unselectedItemColor: AppColors.darkTextTertiary,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedLabelStyle: AppTypography.metadata.copyWith(
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: AppTypography.metadata,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.textInverse,
            foregroundColor: AppColors.darkBackground,
            minimumSize: const Size.fromHeight(44),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.button),
            ),
            textStyle: AppTypography.textTheme.labelLarge,
            elevation: 0,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.darkTextPrimary,
            minimumSize: const Size.fromHeight(44),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.button),
            ),
            side: const BorderSide(color: AppColors.darkBorder),
            textStyle: AppTypography.textTheme.labelLarge,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.darkSurface,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.input),
            borderSide: const BorderSide(color: AppColors.darkBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.input),
            borderSide: const BorderSide(color: AppColors.darkBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.input),
            borderSide: const BorderSide(color: AppColors.textInverse, width: 2),
          ),
          textStyle: AppTypography.body.copyWith(
            color: AppColors.darkTextPrimary,
          ),
        ),
        cardTheme: CardThemeData(
          color: AppColors.darkSurface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.card),
            side: const BorderSide(color: AppColors.darkBorder),
          ),
          margin: EdgeInsets.zero,
        ),
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.darkSurface,
          selectedColor: AppColors.textInverse,
          labelStyle: AppTypography.caption.copyWith(
            color: AppColors.darkTextPrimary,
          ),
          secondaryLabelStyle: AppTypography.caption.copyWith(
            color: AppColors.darkBackground,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.chip),
            side: const BorderSide(color: AppColors.darkBorder),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.darkBorder,
          thickness: 1,
          space: 1,
        ),
      );
}
