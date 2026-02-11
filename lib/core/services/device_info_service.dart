import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

/// Model to hold device information
class DeviceInfoModel {
  final String deviceId;
  final String deviceName;
  final String deviceModel;
  final String platform;

  DeviceInfoModel({
    required this.deviceId,
    required this.deviceName,
    required this.deviceModel,
    required this.platform,
  });

  Map<String, dynamic> toJson() => {
    'device_id': deviceId,
    'device_name': deviceName,
    'device_model': deviceModel,
    'platform': platform,
  };

  @override
  String toString() =>
      'DeviceInfoModel(id: $deviceId, name: $deviceName, model: $deviceModel, platform: $platform)';
}

/// Service to get device information for authentication
class DeviceInfoService {
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  /// Get unique device identifier and info
  Future<DeviceInfoModel> getDeviceInfo() async {
    try {
      if (kIsWeb) {
        return await _getWebDeviceInfo();
      } else if (Platform.isAndroid) {
        return await _getAndroidDeviceInfo();
      } else if (Platform.isIOS) {
        return await _getIosDeviceInfo();
      } else if (Platform.isWindows) {
        return await _getWindowsDeviceInfo();
      } else if (Platform.isMacOS) {
        return await _getMacOsDeviceInfo();
      } else if (Platform.isLinux) {
        return await _getLinuxDeviceInfo();
      } else {
        return DeviceInfoModel(
          deviceId: 'unknown',
          deviceName: 'Unknown Device',
          deviceModel: 'Unknown',
          platform: 'unknown',
        );
      }
    } catch (e) {
      debugPrint('Error getting device info: $e');
      return DeviceInfoModel(
        deviceId: 'error',
        deviceName: 'Error',
        deviceModel: 'Error',
        platform: 'error',
      );
    }
  }

  Future<DeviceInfoModel> _getAndroidDeviceInfo() async {
    final info = await _deviceInfo.androidInfo;
    return DeviceInfoModel(
      // Android ID is unique per device (resets on factory reset)
      deviceId: info.id, // or info.androidId for older versions
      deviceName: info.device,
      deviceModel: '${info.brand} ${info.model}',
      platform: 'android',
    );
  }

  Future<DeviceInfoModel> _getIosDeviceInfo() async {
    final info = await _deviceInfo.iosInfo;
    return DeviceInfoModel(
      // identifierForVendor is unique per app installation
      deviceId: info.identifierForVendor ?? 'unknown',
      deviceName: info.name,
      deviceModel: info.model,
      platform: 'ios',
    );
  }

  Future<DeviceInfoModel> _getWindowsDeviceInfo() async {
    final info = await _deviceInfo.windowsInfo;
    return DeviceInfoModel(
      deviceId: info.deviceId,
      deviceName: info.computerName,
      deviceModel: info.productName,
      platform: 'windows',
    );
  }

  Future<DeviceInfoModel> _getMacOsDeviceInfo() async {
    final info = await _deviceInfo.macOsInfo;
    return DeviceInfoModel(
      deviceId: info.systemGUID ?? 'unknown',
      deviceName: info.computerName,
      deviceModel: info.model,
      platform: 'macos',
    );
  }

  Future<DeviceInfoModel> _getLinuxDeviceInfo() async {
    final info = await _deviceInfo.linuxInfo;
    return DeviceInfoModel(
      deviceId: info.machineId ?? 'unknown',
      deviceName: info.name,
      deviceModel: info.prettyName,
      platform: 'linux',
    );
  }

  Future<DeviceInfoModel> _getWebDeviceInfo() async {
    final info = await _deviceInfo.webBrowserInfo;
    // For web, create a pseudo-unique ID from browser info
    final webId =
        '${info.browserName.name}_${info.platform}_${info.userAgent.hashCode}';
    return DeviceInfoModel(
      deviceId: webId,
      deviceName: info.browserName.name,
      deviceModel: info.platform ?? 'Web',
      platform: 'web',
    );
  }
}
