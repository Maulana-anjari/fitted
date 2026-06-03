import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/widgets/empty_state.dart';
import '../auth/presentation/providers/auth_provider.dart';
import '../wardrobe/presentation/providers/wardrobe_items_provider.dart';

class DailyFitScreen extends ConsumerWidget {
  const DailyFitScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final itemsAsync = ref.watch(wardrobeItemsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.checkroom,
                size: 18,
                color: AppColors.textInverse,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'Daily Fit',
              style: AppTypography.heading2,
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: itemsAsync.when(
          data: (items) {
            if (items.isEmpty) {
              return EmptyState(
                icon: Icons.auto_awesome,
                title: 'Your Daily Fit awaits',
                subtitle:
                    'Add items to your wardrobe and Fitted will recommend the perfect Fit every day.',
                actionLabel: 'Add Your First Item',
                onAction: () => context.push('/wardrobe/upload'),
              );
            }

            return _DailyFitContent(
              userName: user?.name ?? 'there',
              itemCount: items.length,
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 2,
            ),
          ),
          error: (error, _) => Center(
            child: Text(
              'Could not load wardrobe',
              style: AppTypography.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DailyFitContent extends StatelessWidget {
  final String userName;
  final int itemCount;

  const _DailyFitContent({
    required this.userName,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting
          Text(
            'Good morning, $userName',
            style: AppTypography.heading1,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            "Here's what's happening with your wardrobe today.",
            style: AppTypography.body.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Hero card - Today's Fit
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppRadius.hero),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.auto_awesome,
                      color: AppColors.aiAccentLight,
                      size: 20,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      'TODAY\'S FIT',
                      style: AppTypography.metadata.copyWith(
                        color: AppColors.aiAccentLight,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'AI recommendations coming soon',
                  style: AppTypography.heading2.copyWith(
                    color: AppColors.textInverse,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Add more items to your wardrobe to unlock personalized daily Fit recommendations.',
                  style: AppTypography.body.copyWith(
                    color: AppColors.textInverse.withOpacity(0.8),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.textInverse.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(AppRadius.chip),
                  ),
                  child: Text(
                    '$itemCount items in wardrobe',
                    style: AppTypography.metadata.copyWith(
                      color: AppColors.textInverse,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Quick stats
          Text(
            'Wardrobe Summary',
            style: AppTypography.heading3,
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.checkroom,
                  label: 'Items',
                  value: '$itemCount',
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _StatCard(
                  icon: Icons.auto_awesome,
                  label: 'AI Ready',
                  value: '$itemCount',
                  accent: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool accent;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    this.accent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: accent
              ? AppColors.aiAccent.withOpacity(0.3)
              : AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: accent
                  ? AppColors.aiAccent.withOpacity(0.1)
                  : AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 20,
              color: accent ? AppColors.aiAccent : AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: AppTypography.heading3,
              ),
              Text(
                label,
                style: AppTypography.metadata.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
