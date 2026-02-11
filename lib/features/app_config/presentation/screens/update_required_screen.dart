import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/resources/assets_manager.dart';
import '../../../../core/resources/values_manager.dart';

/// Screen shown when app update is required
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
    String? storeUrl;

    if (Platform.isAndroid && androidUrl != null) {
      storeUrl = androidUrl;
    } else if (Platform.isIOS && iosUrl != null) {
      storeUrl = iosUrl;
    }

    if (storeUrl != null) {
      final uri = Uri.parse(storeUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppPadding.p24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Update Lottie Animation
              Lottie.asset(
                AppLotties.updateApp,
                width: AppSize.s250,
                height: AppSize.s250,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: AppSize.s32),

              // Title
              Text(
                'تحديث مطلوب',
                style: GoogleFonts.outfit(
                  fontSize: AppSize.s24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSize.s16),

              // Message
              Text(
                message ??
                    'يرجى تحديث التطبيق للحصول على أحدث الميزات والتحسينات.',
                style: GoogleFonts.outfit(
                  fontSize: AppSize.s16,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.7),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSize.s24),

              // Version info
              Container(
                padding: const EdgeInsets.all(AppPadding.p16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(AppRadius.r16),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.1),
                  ),
                ),
                child: Column(
                  children: [
                    _buildVersionRow(
                      context,
                      'الإصدار الحالي',
                      currentVersion,
                      Colors.orange,
                    ),
                    const SizedBox(height: AppSize.s12),
                    _buildVersionRow(
                      context,
                      'الإصدار المطلوب',
                      latestVersion,
                      AppColors.primary,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSize.s40),

              // Update button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _openStore,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.darkBackground,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppPadding.p16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.r16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.download_rounded),
                      const SizedBox(width: AppSize.s8),
                      Text(
                        'تحديث الآن',
                        style: GoogleFonts.outfit(
                          fontSize: AppSize.s16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVersionRow(
    BuildContext context,
    String label,
    String version,
    Color color,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: AppSize.s14,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppPadding.p12,
            vertical: AppPadding.p6,
          ),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppRadius.r8),
          ),
          child: Text(
            version,
            style: GoogleFonts.outfit(
              fontSize: AppSize.s14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
