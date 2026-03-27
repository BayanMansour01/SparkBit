import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:device_info_plus/device_info_plus.dart';

/// Comprehensive security checker for emulator detection.
/// Blocks the app from running on emulators/simulators.
class SecurityChecker {
  SecurityChecker._();

  /// Returns null if device is real, or a reason string if emulator detected.
  static Future<String?> checkIfEmulator() async {
    // Skip check in debug mode for development convenience
    if (kDebugMode) {
      debugPrint('🛡️ Security: Debug mode — skipping emulator check');
      return null;
    }

    try {
      final deviceInfo = DeviceInfoPlugin();

      if (Platform.isAndroid) {
        return await _checkAndroid(deviceInfo);
      } else if (Platform.isIOS) {
        return await _checkIOS(deviceInfo);
      }
    } catch (e) {
      debugPrint('🛡️ Security: Emulator check error: $e');
    }

    return null;
  }

  static Future<String?> _checkAndroid(DeviceInfoPlugin deviceInfo) async {
    final info = await deviceInfo.androidInfo;

    final String brand = info.brand.toLowerCase();
    final String model = info.model.toLowerCase();
    final String product = info.product.toLowerCase();
    final String device = info.device.toLowerCase();
    final String hardware = info.hardware.toLowerCase();
    final String host = info.host.toLowerCase();
    final String fingerprint = info.fingerprint.toLowerCase();

    // Known real device brands — used for weak checks only
    const realBrands = [
      'samsung', 'xiaomi', 'redmi', 'oppo', 'vivo', 'huawei',
      'honor', 'realme', 'oneplus', 'motorola', 'nokia', 'sony',
      'lg', 'asus', 'lenovo', 'google', 'htc', 'tcl', 'poco',
      'infinix', 'tecno', 'itel', 'nothing',
    ];
    final isKnownBrand = realBrands.any((b) => brand.contains(b));

    // ══════════════════════════════════════════════
    // STRONG CHECKS — Block regardless of brand
    // ══════════════════════════════════════════════

    // 1. Known emulator file paths
    final emulatorPaths = [
      '/storage/emulated/0/storage/secure',
      '/storage/emulated/0/Android/data/com.android.ld.appstore', // LDPlayer
      '/dev/socket/genyd',       // Genymotion
      '/dev/socket/baseband_genyd',
    ];
    for (final path in emulatorPaths) {
      if (await Directory(path).exists() || await File(path).exists()) {
        return 'Emulator path detected: $path';
      }
    }

    // 2. Ubuntu host + AOSP device (common in emulators)
    if (host == 'ubuntu' && device == 'aosp') {
      return 'Ubuntu/AOSP combination detected';
    }

    // 3. Explicit emulator signatures in product/model/hardware
    if (product.contains('sdk') ||
        product.contains('emulator') ||
        product.contains('google_sdk') ||
        product.contains('sdk_gphone') ||
        product.contains('vbox86p') ||
        product.contains('genymotion') ||
        product.contains('nox') ||
        model.contains('emulator') ||
        model.contains('android sdk') ||
        model.contains('bluestacks') ||
        model.contains('bs2') ||
        model.contains('ldplayer') ||
        model.contains('mumu') ||
        model.contains('nox') ||
        hardware.contains('goldfish') ||
        hardware.contains('ranchu') ||
        hardware.contains('vbox86') ||
        fingerprint.contains('generic/')) {
      return 'Emulator signature detected in device info';
    }

    // ══════════════════════════════════════════════
    // WEAK CHECKS — Allow if known brand
    // ══════════════════════════════════════════════

    // 4. test-keys in fingerprint
    if (fingerprint.contains('test-keys') && !isKnownBrand) {
      return 'test-keys detected on unknown brand';
    }

    // 5. generic in fingerprint
    if (fingerprint.contains('generic') && !isKnownBrand) {
      return 'Generic fingerprint on unknown brand';
    }

    // 6. isPhysicalDevice check (only for unknown brands)
    if (!info.isPhysicalDevice && !isKnownBrand) {
      return 'Non-physical device with unknown brand';
    }

    return null; // Device is real
  }

  static Future<String?> _checkIOS(DeviceInfoPlugin deviceInfo) async {
    final info = await deviceInfo.iosInfo;
    if (!info.isPhysicalDevice) {
      return 'iOS Simulator detected';
    }
    return null;
  }

  /// Get device info string for support/debugging
  static Future<String> getDeviceInfoString() async {
    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final info = await deviceInfo.androidInfo;
      return '''
Device: ${info.brand} ${info.model}
Product: ${info.product}
Hardware: ${info.hardware}
Host: ${info.host}
Android: ${info.version.release} (SDK ${info.version.sdkInt})
Physical: ${info.isPhysicalDevice ? 'Yes' : 'No'}
Fingerprint: ${info.fingerprint.length > 60 ? '${info.fingerprint.substring(0, 60)}...' : info.fingerprint}''';
    } else if (Platform.isIOS) {
      final info = await deviceInfo.iosInfo;
      return '''
Device: ${info.name} (${info.model})
System: ${info.systemName} ${info.systemVersion}
Physical: ${info.isPhysicalDevice ? 'Yes' : 'No'}''';
    }

    return 'Unknown platform';
  }
}
