import 'package:flutter/material.dart';

/// Design tokens from Stitch — Fitted Design System
/// Reference: projects/4081707793138547390
class AppColors {
  AppColors._();

  // Primary — Deep Charcoal
  static const Color primary = Color(0xFF111827);
  static const Color primaryLight = Color(0xFF374151);
  static const Color primaryDark = Color(0xFF0B111E);

  // AI Accent (Stitch: secondary) — Indigo, exclusively for AI features
  static const Color aiAccent = Color(0xFF6366F1);
  static const Color aiAccentLight = Color(0xFF818CF8);
  static const Color aiAccentDark = Color(0xFF4F46E5);

  // AI Gradient (from Stitch)
  static const Color gradientStart = Color(0xFF4648D4);
  static const Color gradientEnd = Color(0xFF6063EE);

  // Success
  static const Color success = Color(0xFF22C55E);
  static const Color successLight = Color(0xFF4ADE80);

  // Warning
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFBBF24);

  // Error (Stitch)
  static const Color error = Color(0xFFBA1A1A);
  static const Color errorLight = Color(0xFFFFB4AB);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);

  // Surface
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);

  // MD3 Surface Container hierarchy (from Stitch)
  static const Color surfaceDim = Color(0xFFDCD9DB);
  static const Color surfaceBright = Color(0xFFFCF8FA);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF6F3F4);
  static const Color surfaceContainer = Color(0xFFF0EDEE);
  static const Color surfaceContainerHigh = Color(0xFFEAE7E9);
  static const Color surfaceContainerHighest = Color(0xFFE5E2E3);

  // Border & Outline
  static const Color border = Color(0xFFE5E7EB);
  static const Color outline = Color(0xFF76777D);
  static const Color outlineVariant = Color(0xFFC6C6CD);

  // Text
  static const Color textPrimary = Color(0xFF1B1B1D);
  static const Color textSecondary = Color(0xFF45464C);
  static const Color textTertiary = Color(0xFF76777D);
  static const Color textInverse = Color(0xFFFFFFFF);

  // Navigation
  static const Color navActive = Color(0xFF111827);
  static const Color navInactive = Color(0xFF76777D);

  // Glass effect (from Stitch)
  static Color glassLight = const Color(0xFFFFFFFF).withValues(alpha: 0.7);
  static Color glassLightBorder =
      const Color(0xFFFFFFFF).withValues(alpha: 0.5);

  // AI glow
  static Color aiGlow = const Color(0xFF6366F1).withValues(alpha: 0.1);

  // Dark mode
  static const Color darkBackground = Color(0xFF0C1322);
  static const Color darkSurface = Color(0xFF191F2F);
  static const Color darkSurfaceContainer = Color(0xFF232A3A);
  static const Color darkSurfaceContainerHigh = Color(0xFF2E3545);
  static const Color darkBorder = Color(0xFF323949);
  static const Color darkTextPrimary = Color(0xFFDCE2F7);
  static const Color darkTextSecondary = Color(0xFFC7C4D7);
  static const Color darkTextTertiary = Color(0xFF908FA0);

  // Dark glass
  static Color darkGlass = const Color(0xFF1F2937).withValues(alpha: 0.6);
  static Color darkGlassBorder = const Color(0xFFFFFFFF).withValues(alpha: 0.1);
}
