import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparkbit/core/utils/snackbar_utils.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../providers/auth_provider.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../../core/widgets/app_loading_overlay.dart';
import '../../../../core/widgets/responsive/responsive_center.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../../../courses/presentation/providers/courses_provider.dart';
import '../../../home/presentation/providers/home_provider.dart';
import 'package:sparkbit/core/widgets/app_button.dart';

/// Sign In screen matching the premium design
class SignInScreen extends ConsumerWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Listen to authentication state changes
    ref.listen(authControllerProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stackTrace) {
          log(error.toString());
          AppSnackBar.showError(context, 'Login failed: $error');
        },
        data: (_) {
          if (previous?.isLoading == true) {
            // Login successful - invalidate ALL cached providers to fetch fresh data
            ref.invalidate(userProfileProvider);
            ref.invalidate(myCoursesProvider);
            ref.invalidate(coursesProvider);
            ref.invalidate(categoriesProvider);
            ref.invalidate(homeDataProvider);
            context.go(AppRoutes.home);
          }
        },
      );
    });

    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          SafeArea(
            child: ResponsiveCenter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const Spacer(flex: 2),

                    // Title
                    Text(
                      'Sign In',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: isDark
                            ? AppColors.darkText
                            : AppColors.lightText,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Subtitle
                    Text(
                      'Continue your learning journey.',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),

                    const Spacer(flex: 2),

                    AppButton(
                      text: 'Continue with Google',
                      onPressed: authState.isLoading
                          ? null
                          : () {
                              ref
                                  .read(authControllerProvider.notifier)
                                  .loginWithGoogle();
                            },
                      icon: Icons
                          .login_rounded, // Better to use a generic icon if Image.network is too complex for AppButton right now
                    ),
                    const SizedBox(height: 16),

                    AppButton(
                      text: 'Continue as Guest',
                      variant: AppButtonVariant.secondary,
                      onPressed: authState.isLoading
                          ? null
                          : () {
                              context.go(AppRoutes.home);
                            },
                    ),

                    const SizedBox(height: 32),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
          if (authState.isLoading)
            const Positioned.fill(
              child: IgnorePointer(
                child: AppLoadingOverlay(
                  title: 'Signing You In',
                  subtitle: 'Please wait while we prepare your session.',
                ),
              ),
            ),
        ],
      ),
    );
  }
}
