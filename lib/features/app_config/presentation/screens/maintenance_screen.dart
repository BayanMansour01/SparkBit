import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/resources/assets_manager.dart';
import '../../../../core/resources/values_manager.dart';

/// Screen shown when app is in maintenance mode
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/resources/assets_manager.dart';
import '../../../../core/resources/values_manager.dart';
import '../../../../core/widgets/app_loading_indicator.dart'; // افترضت وجوده بناءً على تعليقك

class MaintenanceScreen extends StatelessWidget {
  final String? message;

  const MaintenanceScreen({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          // تدرج لوني خفيف للخلفية ليعطي عمقاً للتصميم
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
                    theme.colorScheme.surface,
                    theme.colorScheme.surfaceContainer,
                  ]
                : [Colors.white, theme.colorScheme.primary.withOpacity(0.05)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.p32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // الجزء العلوي: الأنميشن مع خلفية دائرية خفيفة
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: AppSize.s200,
                      height: AppSize.s200,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.05),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Lottie.asset(
                      AppLotties.underMaintenance,
                      width: AppSize.s280,
                      height: AppSize.s280,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),

                const SizedBox(height: AppSize.s40),

                // العنوان باللغة الإنجليزية
                Text(
                  'System Maintenance',
                  style: GoogleFonts.outfit(
                    fontSize: AppSize.s28,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    color: theme.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppSize.s16),

                // الرسالة باللغة الإنجليزية مع تحسين التباين
                Text(
                  message ??
                      "We're currently updating our systems to improve your experience. We'll be back shortly!",
                  style: GoogleFonts.outfit(
                    fontSize: AppSize.s16,
                    fontWeight: FontWeight.w400,
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppSize.s48),

                // مؤشر التحميل بتصميم مخصص إذا وجد
                const AppLoadingIndicator(),

                const SizedBox(height: AppSize.s24),

                // نص إضافي يعطي طمأنينة للمستخدم
                Text(
                  'Thank you for your patience',
                  style: GoogleFonts.outfit(
                    fontSize: AppSize.s14,
                    fontStyle: FontStyle.italic,
                    color: theme.colorScheme.primary.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
