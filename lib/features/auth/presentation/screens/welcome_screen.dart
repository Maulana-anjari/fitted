import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/router/route_names.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/secondary_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.checkroom,
                          size: 40,
                          color: AppColors.textInverse,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'Fitted',
                        style: AppTypography.display.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Find Your Perfect Fit Every Day.',
                        style: AppTypography.body.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              PrimaryButton(
                label: 'Get Started',
                onPressed: () => context.go(RouteNames.onboarding),
              ),
              const SizedBox(height: AppSpacing.sm),
              SecondaryButton(
                label: 'I have an account',
                onPressed: () => context.go(RouteNames.login),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
