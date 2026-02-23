import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/resources/assets_manager.dart';
import '../../../../core/resources/values_manager.dart';

class UpdateRequiredScreen extends StatelessWidget {
  final String? message;
  final String currentVersion;
  final String latestVersion;
  final String? androidUrl;
  final String? iosUrl;

  const UpdateRequiredScreen({
    super.key,
    this.message,
    required this.currentVersion,
    required this.latestVersion,
    this.androidUrl,
    this.iosUrl,
  });

  Future<void> _openStore() async {
    String? storeUrl = Platform.isAndroid ? androidUrl : iosUrl;
    if (storeUrl != null) {
      final uri = Uri.parse(storeUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // خلفية بتدرج ناعم
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        theme.colorScheme.surface,
                        theme.colorScheme.surfaceContainer,
                      ]
                    : [
                        Colors.white,
                        theme.colorScheme.primary.withOpacity(0.08),
                      ],
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppPadding.p32),
              child: Column(
                children: [
                  const Spacer(),

                  // انيميشن التحديث مع تأثير ظل
                  Center(
                    child: Lottie.asset(
                      AppLotties.updateApp,
                      width: AppSize.s280,
                      height: AppSize.s280,
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(height: AppSize.s24),

                  // نصوص واضحة واحترافية
                  Text(
                    'New Version Available',
                    style: GoogleFonts.outfit(
                      fontSize: AppSize.s28,
                      fontWeight: FontWeight.w800,
                      color: theme.colorScheme.onSurface,
                      letterSpacing: -0.5,
                    ),
                  ),

                  const SizedBox(height: AppSize.s12),

                  Text(
                    message ??
                        "We've added new features and fixed some bugs to give you a better experience.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontSize: AppSize.s16,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: AppSize.s40),

                  // بطاقة الإصدارات بتصميم زجاجي (Card)
                  Container(
                    padding: const EdgeInsets.all(AppPadding.p20),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withOpacity(0.05)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(AppRadius.r24),
                      border: Border.all(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildVersionInfo(
                          context,
                          'Current',
                          currentVersion,
                          Colors.grey,
                        ),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: theme.colorScheme.primary.withOpacity(0.5),
                        ),
                        _buildVersionInfo(
                          context,
                          'Latest',
                          latestVersion,
                          theme.colorScheme.primary,
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // زر التحديث بتصميم عريض وبارز
                  ElevatedButton(
                    onPressed: _openStore,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 60),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.r20),
                      ),
                    ),
                    child: Text(
                      'Update Now',
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSize.s16),

                  Text(
                    'Your update is ready in the Store',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withOpacity(0.4),
                    ),
                  ),

                  const SizedBox(height: AppPadding.p24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVersionInfo(
    BuildContext context,
    String label,
    String version,
    Color color,
  ) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'v$version',
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
