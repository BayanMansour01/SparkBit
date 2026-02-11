// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserDevice _$UserDeviceFromJson(Map<String, dynamic> json) => _UserDevice(
  id: (json['id'] as num?)?.toInt(),
  fcmToken: json['fcm_token'] as String,
  deviceType: json['device_type'] as String,
  deviceInfo: json['device_info'] as String,
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
);

Map<String, dynamic> _$UserDeviceToJson(_UserDevice instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fcm_token': instance.fcmToken,
      'device_type': instance.deviceType,
      'device_info': instance.deviceInfo,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
