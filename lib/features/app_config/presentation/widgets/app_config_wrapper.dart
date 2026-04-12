import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    final hasInternet = ref.watch(internetAvailableProvider).valueOrNull;
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

        final selectedMinVersion =
            (Platform.isIOS
                    ? config.latestSupportedIosVersion
                    : config.latestSupportedAndroidVersion)
                .toString()
                .trim();
        final selectedLatestVersion =
            (Platform.isIOS
                    ? config.latestIosVersion
                    : config.latestAndroidVersion)
                .toString()
                .trim();

        dev.log(
          '⏭️  Maintenance mode OFF, checking updates...',
          name: 'AppConfigWrapper',
        );

        // 2. جلب نسخة التطبيق الحالية (تأكد أن البروفايدر جاهز)
        final currentVersion = ref.watch(currentAppVersionProvider).valueOrNull;

        if (currentVersion != null) {
          final normalizedCurrentVersion = currentVersion.trim();
          dev.log(
            '  - platform: ${Platform.operatingSystem}',
            name: 'AppConfigWrapper',
          );
          dev.log(
            '  - currentVersion: $normalizedCurrentVersion',
            name: 'AppConfigWrapper',
          );
          dev.log(
            '  - selectedMinVersion: $selectedMinVersion',
            name: 'AppConfigWrapper',
          );
          dev.log(
            '  - selectedLatestVersion: $selectedLatestVersion',
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
          final isUpdateRequired = !_isSameVersion(
            normalizedCurrentVersion,
            selectedMinVersion,
          );

          dev.log('🔍 [AppConfig Check]', name: 'AppConfigWrapper');
          dev.log(
            '   - Device App Version : "$normalizedCurrentVersion"',
            name: 'AppConfigWrapper',
          );
          dev.log(
            '   - Min Required (Min) : "$selectedMinVersion"',
            name: 'AppConfigWrapper',
          );
          dev.log(
            '   - Latest Version (New): "$selectedLatestVersion"',
            name: 'AppConfigWrapper',
          );
          dev.log(
            '   - Result: isUpdateRequired = $isUpdateRequired',
            name: 'AppConfigWrapper',
          );
          dev.log(
            '   - Result: hasNewerVersion  = ${_isVersionLower(normalizedCurrentVersion, selectedLatestVersion)} (Optional)',
            name: 'AppConfigWrapper',
          );

          // 3. Show update screen whenever device version is different from
          // the supported minimum version.
          if (isUpdateRequired) {
            if (hasInternet != true) {
              dev.log(
                '⚠️ Update required but device is offline. Allowing temporary access.',
                name: 'AppConfigWrapper',
              );
              return child;
            }

            dev.log(
              '✅ Device version is different from supported version, showing UpdateRequiredScreen',
              name: 'AppConfigWrapper',
            );
            return UpdateRequiredScreen(
              message: config.updateMessage,
              currentVersion: normalizedCurrentVersion,
              latestVersion: selectedLatestVersion,
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
        // Use routed child to avoid mounting SplashScreen twice at startup.
        return child;
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

  bool _isSameVersion(String a, String b) {
    return !_isVersionLower(a, b) && !_isVersionLower(b, a);
  }
}
