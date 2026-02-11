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
final appConfigProvider = FutureProvider.autoDispose<AppConfigModel>((ref) async {
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

/// Provider to check if update is required
final updateRequiredProvider = FutureProvider<bool>((ref) async {
  final config = await ref.watch(appConfigProvider.future);
  final currentVersion = await ref.watch(currentAppVersionProvider.future);

  if (config.forceUpdate) {
    return _isVersionLower(currentVersion, config.minVersion);
  }

  return false;
});

/// Provider to check if app is in maintenance mode
final maintenanceModeProvider = FutureProvider<bool>((ref) async {
  final config = await ref.watch(appConfigProvider.future);
  return config.isMaintenance;
});

/// Check if version1 is lower than version2
bool _isVersionLower(String version1, String version2) {
  final v1Parts = version1.split('.').map(int.parse).toList();
  final v2Parts = version2.split('.').map(int.parse).toList();

  for (int i = 0; i < 3; i++) {
    final v1Part = i < v1Parts.length ? v1Parts[i] : 0;
    final v2Part = i < v2Parts.length ? v2Parts[i] : 0;

    if (v1Part < v2Part) return true;
    if (v1Part > v2Part) return false;
  }

  return false;
}
