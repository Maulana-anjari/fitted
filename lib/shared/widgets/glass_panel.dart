import 'dart:ui';

import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';

/// Glass-morphism panel — matches Stitch `.glass-panel` design
class GlassPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;

  const GlassPanel({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkGlass : AppColors.glassLight;
    final border = isDark ? AppColors.darkGlassBorder : AppColors.glassLightBorder;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: padding ?? const EdgeInsets.all(16),
          margin: margin,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: border),
          ),
          child: child,
        ),
      ),
    );
  }
}

/// AI gradient accent — matches Stitch `.ai-gradient-text`
class AiGradientText extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const AiGradientText(this.text, {super.key, this.style});

  @override
  Widget build(BuildContext context) {
    final baseStyle = style ?? Theme.of(context).textTheme.bodyLarge;
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [AppColors.gradientStart, AppColors.gradientEnd],
      ).createShader(bounds),
      child: Text(
        text,
        style: baseStyle!.copyWith(
          color: Colors.white,
        ),
      ),
    );
  }
}

/// AI glow container — matches Stitch `.ai-glow` box shadow
class AiGlow extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const AiGlow({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: AppColors.aiGlow,
            blurRadius: 40,
            spreadRadius: 10,
          ),
        ],
      ),
      child: child,
    );
  }
}
