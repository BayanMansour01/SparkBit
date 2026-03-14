import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/providers/theme_provider.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../../core/widgets/app_loading_overlay.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/shimmers/app_page_skeleton.dart';
import 'package:sparkbit/core/widgets/app_button.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../app_config/presentation/providers/app_config_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/profile_provider.dart';
import '../../../../core/widgets/app_profile_avatar.dart';
import '../../../../core/widgets/main_screen_wrapper.dart';

/// Profile screen with user info and settings
/// Refactored to be Stateless (Clean Architecture)
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MainScreenWrapper(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOut,
        builder: (context, opacity, child) {
          return Opacity(opacity: opacity, child: child);
        },
        child: Column(
          children: [
            const SizedBox(height: AppSizes.paddingLg),
            _buildHeader(context, ref),
            const SizedBox(height: AppSizes.space24),
            _buildSettings(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);

    return profileAsync.when(
      data: (profile) {
        final isGuest = profile.id == -1;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingLg),
          child: Column(
            children: [
              // Title Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Profile',
                    style: GoogleFonts.outfit(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  if (!isGuest)
                    IconButton(
                      onPressed: () =>
                          context.pushNamed(AppRoutes.editProfileName),
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHighest,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.edit_rounded, size: 20),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 32),

              // Avatar with Ring
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.2),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.1),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: AppProfileAvatar(
                        radius: 60,
                        isGuest: isGuest,
                        imageUrl: profile.avatar,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Name & Email
              Text(
                profile.name,
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isGuest
                    ? 'Sign in to access courses & certificates'
                    : profile.email,
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),

              if (isGuest) ...[
                const SizedBox(height: 32),
                AppButton(
                  text: 'Login / Register',
                  onPressed: () => context.pushNamed(AppRoutes.signInName),
                ),
              ],
            ],
          ),
        );
      },
      loading: () => const AppPageSkeleton(itemCount: 3, cardHeight: 120),
      error: (err, stack) => ErrorView(
        error: err,
        onRetry: () => ref.refresh(userProfileProvider),
      ),
    );
  }

  Widget _buildSettings(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final profile = ref.watch(userProfileProvider).valueOrNull;
    final isGuest = profile?.id == -1;
    final config = ref.watch(appConfigProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 16),
            child: Text(
              'Settings',
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Theme.of(context).dividerColor.withOpacity(0.1),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // My Courses - Only for logged-in users
                if (!isGuest) ...[
                  _ActionTile(
                    icon: Icons.school_rounded,
                    title: 'My Courses',
                    subtitle: 'View your enrolled courses',
                    onTap: () => context.go(AppRoutes.myCourses),
                  ),
                  const Divider(indent: 50, height: 24, thickness: 0.5),
                  _ActionTile(
                    icon: Icons.receipt_long_rounded,
                    title: 'My Orders',
                    subtitle: 'Track your purchases',
                    onTap: () => context.pushNamed(AppRoutes.ordersName),
                  ),
                  const Divider(indent: 50, height: 24, thickness: 0.5),
                ],
                _SettingsTile(
                  icon: Icons.dark_mode_rounded,
                  title: 'Dark Mode',
                  trailing: Switch(
                    value: isDark,
                    onChanged: (value) {
                      ref
                          .read(themeModeProvider.notifier)
                          .toggleTheme(isDark: isDark);
                    },
                    activeThumbColor: AppColors.primary,
                  ),
                ),
                const Divider(indent: 50, height: 24, thickness: 0.5),
                _ActionTile(
                  icon: Icons.privacy_tip_rounded,
                  title: 'Privacy Policy',
                  subtitle: 'Read our policies',
                  onTap: () async {
                    final url = Uri.parse(AppStrings.privacyPolicyUrl);
                    try {
                      final launched = await launchUrl(
                        url,
                        mode: LaunchMode.externalApplication,
                      );
                      if (!launched) {
                        debugPrint(
                          'Could not launch ${AppStrings.privacyPolicyUrl}',
                        );
                      }
                    } catch (e) {
                      debugPrint('Error launching URL: $e');
                    }
                  },
                ),
                if (!isGuest) ...[
                  const Divider(indent: 50, height: 24, thickness: 0.5),
                  _ActionTile(
                    icon: Icons.logout_rounded,
                    title: 'Logout',
                    subtitle: 'Sign out of your account',
                    iconColor: AppColors.error,
                    textColor: AppColors.error,
                    onTap: () async {
                      // Show confirmation dialog
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Confirm Logout'),
                          content: const Text(
                            'Are you sure you want to log out?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: const Text('Cancel'),
                            ),
                            const SizedBox(width: 8),
                            AppButton(
                              text: 'Logout',
                              width: 120,
                              height: 44,
                              variant: AppButtonVariant.error,
                              onPressed: () => Navigator.pop(ctx, true),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true && context.mounted) {
                        // Capture references BEFORE async gap.
                        // IMPORTANT: Use rootNavigator: true because showDialog uses the root navigator by default.
                        final rootNavigator = Navigator.of(
                          context,
                          rootNavigator: true,
                        );
                        final goRouter = GoRouter.of(context);

                        // Show loading dialog
                        // Don't await this, as we want to programmatically close it later.
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          useRootNavigator: true, // Explicitly use root
                          builder: (ctx) => const AppLoadingOverlay(
                            title: 'Signing You Out',
                            subtitle:
                                'Saving your preferences and clearing session.',
                          ),
                        );

                        try {
                          // Perform logout
                          await ref
                              .read(authControllerProvider.notifier)
                              .logout();
                        } catch (e) {
                          debugPrint('Gracefully handling logout error: $e');
                        } finally {
                          // Close loading dialog using captured root navigator
                          if (rootNavigator.canPop()) {
                            rootNavigator.pop();
                          }

                          // Navigate to Home using captured router
                          goRouter.go(AppRoutes.home);
                        }
                      }
                    },
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 32),
          Center(
            child: ref
                .watch(currentAppVersionProvider)
                .when(
                  data: (version) => Text(
                    'Version $version',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.4),
                    ),
                  ),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? textColor;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: (iconColor ?? AppColors.primary).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor ?? AppColors.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: textColor ?? Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
            size: 20,
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget trailing;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary, size: 24),
        ),
        const SizedBox(width: 16),
        Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const Spacer(),
        trailing,
      ],
    );
  }
}
