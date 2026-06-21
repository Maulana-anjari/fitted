import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/empty_state.dart';

class FitPlannerScreen extends StatelessWidget {
  const FitPlannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Fit Planner', style: AppTypography.heading2),
      ),
      body: SafeArea(
        child: EmptyState(
          icon: Icons.calendar_month_outlined,
          title: 'Plan your Fits',
          subtitle:
              'Schedule what to wear ahead of time. This feature will be available in Phase 2.',
          actionLabel: 'Create Your First Fit',
          onAction: () => context.push('/fits/builder'),
        ),
      ),
    );
  }
}
