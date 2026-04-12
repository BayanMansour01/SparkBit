import 'dart:io' show Platform;
import 'dart:io' show InternetAddress, SocketException;
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
  return '${packageInfo.version}+${packageInfo.buildNumber}';
});

/// Lightweight online check used to avoid blocking the app with force-update
/// screens when the user is offline.
final internetAvailableProvider = FutureProvider<bool>((ref) async {
  try {
    final result = await InternetAddress.lookup(
      'one.one.one.one',
    ).timeout(const Duration(seconds: 2));
    return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
  } on SocketException {
    return false;
  } catch (_) {
    return false;
  }
});

final updateRequiredProvider = FutureProvider<bool>((ref) async {
  final config = await ref.watch(appConfigProvider.future);
  final currentVersion = await ref.watch(currentAppVersionProvider.future);
  final hasInternet = await ref.watch(internetAvailableProvider.future);
  final selectedMinVersion =
      (Platform.isIOS
              ? config.latestSupportedIosVersion
              : config.latestSupportedAndroidVersion)
          .toString()
          .trim();

  final isVersionMismatch = !_isSameVersion(
    currentVersion.trim(),
    selectedMinVersion,
  );

  // Enforce update only when online. Offline users can continue temporarily.
  return isVersionMismatch && hasInternet;
});

/// دالة مساعدة لمقارنة الإصدارات بشكل آمن (تتعامل مع 1.0.0 و "1" و 1.2)
bool _isVersionLower(String current, String target) {
  try {
    // 1) Compare semantic parts (Major.Minor.Patch)
    final currentFull = current.split('+');
    final targetFull = target.split('+');

    final currentParts = currentFull[0]
        .split('.')
        .map((e) => int.tryParse(e.trim()) ?? 0)
        .toList();
    final targetParts = targetFull[0]
        .split('.')
        .map((e) => int.tryParse(e.trim()) ?? 0)
        .toList();

    final maxLength = currentParts.length > targetParts.length
        ? currentParts.length
        : targetParts.length;
    for (var i = 0; i < maxLength; i++) {
      final c = i < currentParts.length ? currentParts[i] : 0;
      final t = i < targetParts.length ? targetParts[i] : 0;
      if (c < t) return true;
      if (c > t) return false;
    }

    // 2) If semantic parts are equal, compare build number
    final currentBuild = currentFull.length > 1
        ? (int.tryParse(currentFull[1].trim()) ?? 0)
        : 0;
    final targetBuild = targetFull.length > 1
        ? (int.tryParse(targetFull[1].trim()) ?? 0)
        : 0;

    return currentBuild < targetBuild;
  } catch (e) {
    debugPrint('Error comparing versions: $e');
  }
  return false;
}

bool _isSameVersion(String a, String b) {
  return !_isVersionLower(a, b) && !_isVersionLower(b, a);
}

/// Provider to check if app is in maintenance mode
final maintenanceModeProvider = FutureProvider<bool>((ref) async {
  final config = await ref.watch(appConfigProvider.future);
  debugPrint('Maintenance mode: ${config.isMaintenance}');
  return config.isMaintenance;
});
