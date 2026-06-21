import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/widgets/primary_button.dart';
import '../auth/presentation/providers/auth_provider.dart';
import '../wardrobe/presentation/providers/wardrobe_items_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final itemsAsync = ref.watch(
      wardrobeItemsProvider,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Profile', style: AppTypography.heading2),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Column(
            children: [
              // Avatar + Name
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: AppColors.primary,
                      backgroundImage: user?.avatarUrl != null
                          ? NetworkImage(user!.avatarUrl!)
                          : null,
                      child: user?.avatarUrl == null
                          ? Text(
                              user?.name?.substring(0, 1).toUpperCase() ?? '?',
                              style: AppTypography.heading1.copyWith(
                                color: AppColors.textInverse,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      user?.name ?? 'Fitted User',
                      style: AppTypography.heading3,
                    ),
                    if (user != null)
                      Text(
                        user.email,
                        style: AppTypography.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Style Identity
              _SettingsSection(
                title: 'Style Identity',
                children: [
                  _SettingsTile(
                    icon: Icons.palette,
                    title: 'Style Preferences',
                    subtitle: 'Set your preferred styles',
                    onTap: () {},
                  ),
                  _SettingsTile(
                    icon: Icons.color_lens,
                    title: 'Preferred Colors',
                    subtitle: 'Colors you love to wear',
                    onTap: () {},
                  ),
                  _SettingsTile(
                    icon: Icons.category,
                    title: 'Formality Level',
                    subtitle: 'Casual to formal range',
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // Wardrobe Stats
              _SettingsSection(
                title: 'Wardrobe',
                children: [
                  _SettingsTile(
                    icon: Icons.checkroom,
                    title: 'Your Wardrobe',
                    subtitle: itemsAsync.when(
                      data: (items) => '${items.length} items',
                      loading: () => 'Loading...',
                      error: (_, __) => 'Unknown',
                    ),
                    onTap: () {},
                  ),
                  _SettingsTile(
                    icon: Icons.favorite,
                    title: 'Saved Fits',
                    subtitle: 'Coming soon',
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // Account
              _SettingsSection(
                title: 'Account',
                children: [
                  _SettingsTile(
                    icon: Icons.notifications,
                    title: 'Notifications',
                    subtitle: 'Manage preferences',
                    onTap: () {},
                  ),
                  _SettingsTile(
                    icon: Icons.lock,
                    title: 'Privacy',
                    subtitle: 'Data and permissions',
                    onTap: () {},
                  ),
                  _SettingsTile(
                    icon: Icons.help_outline,
                    title: 'Help & Support',
                    subtitle: 'Get help using Fitted',
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),

              // Sign Out
              PrimaryButton(
                label: 'Sign Out',
                onPressed: () async {
                  await ref.read(authNotifierProvider.notifier).signOut();
                },
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.caption.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: 12,
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.textSecondary),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: AppTypography.caption.copyWith(
                        fontWeight: FontWeight.w500,
                      )),
                  Text(
                    subtitle,
                    style: AppTypography.metadata.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 18,
              color: AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}
