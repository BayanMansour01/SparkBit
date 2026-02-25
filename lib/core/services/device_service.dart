import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/api/student_api.dart';

import '../services/firebase_messaging_service.dart';

/// Service to manage device information and registration
class DeviceService {
  final StudentApi _studentApi;
  final SharedPreferences _prefs;
  final FirebaseMessagingService _firebaseMessagingService;

  static const String _keyDeviceType = 'last_device_type';
  static const String _keyDeviceInfo = 'last_device_info';
  static const String _keyFcmToken = 'last_fcm_token';

  DeviceService(this._studentApi, this._prefs, this._firebaseMessagingService) {
    _monitorTokenRefresh();
  }

  void _monitorTokenRefresh() {
    _firebaseMessagingService.onTokenRefresh.listen((newToken) async {
      final accessToken = _prefs.getString('access_token');
      if (accessToken != null && accessToken.isNotEmpty) {
        await registerDeviceIfChanged(fcmToken: newToken);
      }
    });
  }

  /// Get current device type
  Future<String> getDeviceType() async {
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    if (Platform.isWindows) return 'windows';
    if (Platform.isMacOS) return 'macos';
    if (Platform.isLinux) return 'linux';
    return 'unknown';
  }

  /// Get current device info
  /// Returns format: "version | manufacturer | model | androidVersion"
  /// Example: "1.0.0+1 | samsung | a01q | 12"
  Future<String> getDeviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();
    final packageInfo = await PackageInfo.fromPlatform();
    final version = '${packageInfo.version}+${packageInfo.buildNumber}';

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      // Format: version | manufacturer | model | androidVersion
      return '$version | ${androidInfo.manufacturer.toLowerCase()} | ${androidInfo.model.toLowerCase()} | ${androidInfo.version.release}';
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      // Format: version | manufacturer | model | osVersion
      return '$version | apple | ${iosInfo.model.toLowerCase()} | ${iosInfo.systemVersion}';
    } else if (Platform.isWindows) {
      final windowsInfo = await deviceInfo.windowsInfo;
      // Format: version | manufacturer | model | osVersion
      return '$version | microsoft | ${windowsInfo.computerName.toLowerCase()} | windows';
    }

    return '$version | unknown | unknown | unknown';
  }

  /// Register or update device if information changed
  /// If [fcmToken] is provided, it uses it. Otherwise, it fetches it from FirebaseMessagingService.
  Future<bool> registerDeviceIfChanged({
    String? fcmToken,
    bool force = false,
  }) async {
    // Get actual FCM token if not provided
    final String token =
        fcmToken ?? (await _firebaseMessagingService.getToken() ?? '');

    if (token.isEmpty) {
      // Cannot register without token
      return false;
    }

    // Get current device information
    final currentDeviceType = await getDeviceType();
    final currentDeviceInfo = await getDeviceInfo();

    // Get last saved device information
    final lastDeviceType = _prefs.getString(_keyDeviceType);
    final lastDeviceInfo = _prefs.getString(_keyDeviceInfo);
    final lastFcmToken = _prefs.getString(_keyFcmToken);

    // Check if any information changed
    final hasChanged =
        lastDeviceType != currentDeviceType ||
        lastDeviceInfo != currentDeviceInfo ||
        lastFcmToken != token;

    if (!hasChanged && !force) {
      // Nothing changed and force is false, skip API call
      return false;
    }

    // Information changed, update on server
    try {
      await _studentApi.updateOrCreateDevice(
        fcmToken: token,
        deviceType: currentDeviceType,
        deviceInfo: currentDeviceInfo,
      );

      // Save current information
      await _prefs.setString(_keyDeviceType, currentDeviceType);
      await _prefs.setString(_keyDeviceInfo, currentDeviceInfo);
      await _prefs.setString(_keyFcmToken, token);

      return true;
    } catch (e) {
      // Log error but don't crash app flow
      return false;
    }
  }

  /// Clear saved device information (useful for logout)
  Future<void> clearDeviceInfo() async {
    await _prefs.remove(_keyDeviceType);
    await _prefs.remove(_keyDeviceInfo);
    await _prefs.remove(_keyFcmToken);
  }
}
