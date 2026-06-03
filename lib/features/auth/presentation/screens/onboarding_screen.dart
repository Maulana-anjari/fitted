import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/router/route_names.dart';
import '../../../../shared/widgets/primary_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  final _pages = const [
    _OnboardingPage(
      icon: Icons.auto_awesome,
      title: 'AI-Powered Style',
      subtitle:
          'Fitted learns your style and recommends the perfect Fit every day.',
    ),
    _OnboardingPage(
      icon: Icons.checkroom,
      title: 'Digitize Your Wardrobe',
      subtitle:
          'Snap photos of your clothes and let AI categorize everything automatically.',
    ),
    _OnboardingPage(
      icon: Icons.calendar_month,
      title: 'Plan With Confidence',
      subtitle:
          'Schedule your Fits, track what you wear, and always know what to wear.',
    ),
    _OnboardingPage(
      icon: Icons.chat,
      title: 'Your Personal Stylist',
      subtitle:
          'Ask Fit Check for advice. Like having a stylist in your pocket.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

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
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (i) => setState(() => _currentPage = i),
                  itemBuilder: (_, i) => _pages[i],
                ),
              ),
              // Dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: i == _currentPage ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: i == _currentPage
                          ? AppColors.primary
                          : AppColors.border,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              PrimaryButton(
                label: _currentPage < _pages.length - 1
                    ? 'Continue'
                    : 'Create Your Account',
                onPressed: () {
                  if (_currentPage < _pages.length - 1) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    context.go(RouteNames.signup);
                  }
                },
              ),
              if (_currentPage < _pages.length - 1) ...[
                const SizedBox(height: AppSpacing.sm),
                TextButton(
                  onPressed: () => context.go(RouteNames.signup),
                  child: Text(
                    'Skip',
                    style: AppTypography.body.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _OnboardingPage({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(icon, size: 48, color: AppColors.textInverse),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            title,
            style: AppTypography.heading1,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            subtitle,
            style: AppTypography.body.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
