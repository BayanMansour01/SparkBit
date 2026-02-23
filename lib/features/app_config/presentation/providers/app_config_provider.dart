import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../data/models/app_config_model.dart';
import '../../domain/repositories/app_config_repository.dart';
import '../../domain/usecases/get_app_config_usecase.dart';
import '../../../../core/di/service_locator.dart';

/// Provider for AppConfigRepository
final appConfigRepositoryProvider = Provider<AppConfigRepository>((ref) {
  return getIt<AppConfigRepository>();
});

/// Provider for GetAppConfigUseCase
final getAppConfigUseCaseProvider = Provider<GetAppConfigUseCase>((ref) {
  final repository = ref.watch(appConfigRepositoryProvider);
  return GetAppConfigUseCase(repository);
});

/// Provider for app configuration
final appConfigProvider = FutureProvider.autoDispose<AppConfigModel>((
  ref,
) async {
  // Keep alive to prevent re-fetching/re-building unnecessarily
  ref.keepAlive();

  final useCase = ref.watch(getAppConfigUseCaseProvider);
  return await useCase();
});

/// Provider for current app version
final currentAppVersionProvider = FutureProvider<String>((ref) async {
  final packageInfo = await PackageInfo.fromPlatform();
  return packageInfo.version;
});
final updateRequiredProvider = FutureProvider<bool>((ref) async {
  final config = await ref.watch(appConfigProvider.future);
  final currentVersion = await ref.watch(currentAppVersionProvider.future);

  // بما أن الـ getter غير موجود، سنقوم بالمقارنة مباشرة
  // أو يمكنك وضع شرط منطقي خاص بك هنا
  return _isVersionLower(currentVersion, config.minVersion);
});

/// دالة مساعدة لمقارنة الإصدارات بشكل آمن (تتعامل مع 1.0.0 و "1" و 1.2)
bool _isVersionLower(String current, String min) {
  try {
    // تنظيف النصوص من أي رموز غير رقمية باستثناء النقاط
    final v1 = current.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    final v2 = min.split('.').map((e) => int.tryParse(e) ?? 0).toList();

    // المقارنة السلسة لكل جزء من أجزاء الإصدار (Major.Minor.Patch)
    for (var i = 0; i < v2.length; i++) {
      int v1Part = i < v1.length ? v1[i] : 0;
      int v2Part = v2[i];

      if (v1Part < v2Part) return true;
      if (v1Part > v2Part) return false;
    }
  } catch (e) {
    debugPrint('Error comparing versions: $e');
  }
  return false;
}

/// Provider to check if app is in maintenance mode
final maintenanceModeProvider = FutureProvider<bool>((ref) async {
  final config = await ref.watch(appConfigProvider.future);
  debugPrint('Maintenance mode: ${config.isMaintenance}');
  return config.isMaintenance;
});
