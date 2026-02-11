import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/device_info_service.dart';

/// Provider for DeviceInfoService
final deviceInfoServiceProvider = Provider<DeviceInfoService>((ref) {
  return DeviceInfoService();
});

/// Provider to get device info
final deviceInfoProvider = FutureProvider<DeviceInfoModel>((ref) async {
  final service = ref.watch(deviceInfoServiceProvider);
  return service.getDeviceInfo();
});