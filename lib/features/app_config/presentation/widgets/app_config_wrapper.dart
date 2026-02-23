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

          // تحويل النسخ لأرقام للمقارنة الدقيقة (مثال: 1.0.0 -> 100)
          final currentV = _parseVersion(currentVersion);
          final minV = _parseVersion(config.minVersion);

          dev.log('  - Parsed currentV: $currentV', name: 'AppConfigWrapper');
          dev.log('  - Parsed minV: $minV', name: 'AppConfigWrapper');
          dev.log(
            '  - Need update? ${currentV < minV}',
            name: 'AppConfigWrapper',
          );

          // 3. فحص التحديث الإجباري
          if (currentV < minV) {
            dev.log(
              '✅ Update required, showing UpdateRequiredScreen',
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

  // دالة مساعدة لتحويل النسخة (String) إلى (int) للمقارنة الصحيحة
  // يدعم: 1.0.0, 1.0.0+1, 1.2.3+45
  int _parseVersion(String v) {
    try {
      // إزالة build number إن وجد (كل شيء بعد +)
      final versionOnly = v.split('+').first;
      // إزالة النقاط وتحويله لرقم: 1.2.3 -> 123
      final cleaned = versionOnly.replaceAll('.', '');
      return int.tryParse(cleaned) ?? 0;
    } catch (e) {
      dev.log('⚠️  Error parsing version "$v": $e', name: 'AppConfigWrapper');
      return 0;
    }
  }
}
