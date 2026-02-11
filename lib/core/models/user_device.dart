import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_device.freezed.dart';
part 'user_device.g.dart';

/// User device model
@freezed
abstract class UserDevice with _$UserDevice {
  const factory UserDevice({
    int? id,
    @JsonKey(name: 'fcm_token') required String fcmToken,
    @JsonKey(name: 'device_type') required String deviceType,
    @JsonKey(name: 'device_info') required String deviceInfo,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  }) = _UserDevice;

  factory UserDevice.fromJson(Map<String, dynamic> json) =>
      _$UserDeviceFromJson(json);
}
