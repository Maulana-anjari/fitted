import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  AppTypography._();

  static TextTheme get textTheme => GoogleFonts.interTextTheme().copyWith(
        displayLarge: GoogleFonts.inter(
          fontSize: 40,
          fontWeight: FontWeight.w700,
          height: 1.2,
          letterSpacing: -0.5,
        ),
        headlineLarge: GoogleFonts.inter(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          height: 1.25,
          letterSpacing: -0.3,
        ),
        headlineMedium: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          height: 1.3,
        ),
        headlineSmall: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          height: 1.35,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.45,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          height: 1.4,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          height: 1.4,
        ),
        labelMedium: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          height: 1.4,
        ),
        labelSmall: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          height: 1.4,
        ),
      );

  // Convenience aliases matching design system
  static TextStyle get display => textTheme.displayLarge!;
  static TextStyle get heading1 => textTheme.headlineLarge!;
  static TextStyle get heading2 => textTheme.headlineMedium!;
  static TextStyle get heading3 => textTheme.headlineSmall!;
  static TextStyle get body => textTheme.bodyLarge!;
  static TextStyle get caption => textTheme.bodyMedium!;
  static TextStyle get metadata => textTheme.bodySmall!;
}
