import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sparkbit/features/auth/presentation/screens/splash_screen.dart';
import 'dart:developer' as dev;
import '../providers/app_config_provider.dart';
import '../screens/maintenance_screen.dart';
import '../screens/update_required_screen.dart';

/// Wrapper widget that checks app config before showing the app
class AppConfigWrapper extends ConsumerWidget {
  final Widget child;

  const AppConfigWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appConfigAsync = ref.watch(appConfigProvider);
    // نكتفي بمراقبة الموديل الرئيسي لأنه يحتوي بالفعل على كل المنطق

    return appConfigAsync.when(
      data: (config) {
        // Debug logs
        dev.log('🔧 AppConfig loaded:', name: 'AppConfigWrapper');
        dev.log(
          '  - maintenanceMode: ${config.maintenanceMode}',
          name: 'AppConfigWrapper',
        );
        dev.log(
          '  - isMaintenance: ${config.isMaintenance}',
          name: 'AppConfigWrapper',
        );
        dev.log(
          '  - minVersion: ${config.minVersion}',
          name: 'AppConfigWrapper',
        );
        dev.log(
          '  - latestVersion: ${config.latestVersion}',
          name: 'AppConfigWrapper',
        );

        // 1. فحص وضع الصيانة (الأولوية القصوى)
        if (config.isMaintenance) {
          dev.log('✅ Showing MaintenanceScreen', name: 'AppConfigWrapper');
          return MaintenanceScreen(message: config.maintenanceMessage);
        }

        dev.log(
          '⏭️  Maintenance mode OFF, checking updates...',
          name: 'AppConfigWrapper',
        );

        // 2. جلب نسخة التطبيق الحالية (تأكد أن البروفايدر جاهز)
        final currentVersion = ref.watch(currentAppVersionProvider).valueOrNull;

        if (currentVersion != null) {
          dev.log(
            '  - currentVersion: $currentVersion',
            name: 'AppConfigWrapper',
          );
          dev.log(
            '  - config.minVersion: ${config.minVersion}',
            name: 'AppConfigWrapper',
          );
          dev.log(
            '  - config.updateMessage (Android): ${config.updateAndroidFeatures}',
            name: 'AppConfigWrapper',
          );
          dev.log(
            '  - config.updateMessage (iOS): ${config.updateIosFeatures}',
            name: 'AppConfigWrapper',
          );
          dev.log(
            '  - config.directAndroidLink: ${config.directAndroidLink}',
            name: 'AppConfigWrapper',
          );
          dev.log(
            '  - config.iosPrivacyLink: ${config.iosPrivacyLink}',
            name: 'AppConfigWrapper',
          );

          // Robust comparison logic
          final isUpdateRequired = _isVersionLower(
            currentVersion,
            config.minVersion,
          );
          final hasNewerVersion = _isVersionLower(
            currentVersion,
            config.latestVersion,
          );

          dev.log('🔍 [AppConfig Check]', name: 'AppConfigWrapper');
          dev.log(
            '   - Device App Version : "$currentVersion"',
            name: 'AppConfigWrapper',
          );
          dev.log(
            '   - Min Required (Min) : "${config.minVersion}"',
            name: 'AppConfigWrapper',
          );
          dev.log(
            '   - Latest Version (New): "${config.latestVersion}"',
            name: 'AppConfigWrapper',
          );
          dev.log(
            '   - Result: isUpdateRequired = $isUpdateRequired',
            name: 'AppConfigWrapper',
          );
          dev.log(
            '   - Result: hasNewerVersion  = $hasNewerVersion (Optional)',
            name: 'AppConfigWrapper',
          );

          // 3. فحص التحديث (سنغيرها هنا لتبرز الشاشة بمجرد وجود نسخة أحدث)
          if (hasNewerVersion) {
            dev.log(
              '✅ Newer version available, showing UpdateRequiredScreen',
              name: 'AppConfigWrapper',
            );
            return UpdateRequiredScreen(
              message: config.updateMessage,
              currentVersion: currentVersion,
              latestVersion: config.latestVersion,
              androidUrl: config.directAndroidLink,
              iosUrl: config.iosPrivacyLink,
            );
          }
        }

        // كل الفحوصات سليمة
        dev.log(
          '✅ All checks passed, showing main app',
          name: 'AppConfigWrapper',
        );
        return child;
      },
      // أثناء التحميل: عرض Splash Screen مع تحميل جميل
      loading: () {
        dev.log('⏳ Loading config...', name: 'AppConfigWrapper');
        return const SplashScreen();
      },
      // في حالة الخطأ: Fail-safe (السماح بالدخول أو إظهار صفحة خطأ بسيطة)
      error: (error, stack) {
        dev.log('❌ Error loading config: $error', name: 'AppConfigWrapper');
        dev.log('Stack: $stack', name: 'AppConfigWrapper');
        return child;
      },
    );
  }

  /// دالة قوية لمقارنة الإصدارات (Major.Minor.Patch+Build)
  bool _isVersionLower(String current, String target) {
    try {
      // 1. فصل النسخة الأساسية عن الـ build number
      final currentFull = current.split('+');
      final targetFull = target.split('+');

      final currentParts = currentFull[0]
          .split('.')
          .map((e) => int.tryParse(e) ?? 0)
          .toList();
      final targetParts = targetFull[0]
          .split('.')
          .map((e) => int.tryParse(e) ?? 0)
          .toList();

      // 2. مقارنة الأجزاء الأساسية (1.0 vs 1.0.0)
      final maxLength = currentParts.length > targetParts.length
          ? currentParts.length
          : targetParts.length;
      for (var i = 0; i < maxLength; i++) {
        final v1 = i < currentParts.length ? currentParts[i] : 0;
        final v2 = i < targetParts.length ? targetParts[i] : 0;
        if (v1 < v2) return true;
        if (v1 > v2) return false;
      }

      // 3. إذا تساوت الأجزاء الأساسية، نقارن الـ Build Number إن وجد
      final currentBuild = currentFull.length > 1
          ? (int.tryParse(currentFull[1]) ?? 0)
          : 0;
      final targetBuild = targetFull.length > 1
          ? (int.tryParse(targetFull[1]) ?? 0)
          : 0;

      return currentBuild < targetBuild;
    } catch (e) {
      dev.log('⚠️ Error comparing versions "$current" and "$target": $e');
      return false;
    }
  }
}
