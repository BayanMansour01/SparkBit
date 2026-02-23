// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppConfigModel _$AppConfigModelFromJson(Map<String, dynamic> json) =>
    _AppConfigModel(
      latestAndroidVersion: json['latest_android_version'],
      latestSupportedAndroidVersion: json['latest_supported_android_version'],
      updateAndroidFeatures: json['update_android_features'] as String,
      latestIosVersion: json['latest_ios_version'],
      latestSupportedIosVersion: json['latest_supported_ios_version'],
      updateIosFeatures: json['update_ios_features'] as String,
      directAndroidLink: json['direct_android_link'] as String,
      androidPrivacyLink: json['android_privacy_link'] as String,
      iosPrivacyLink: json['ios_privacy_link'] as String,
      maintenanceMode: json['maintenance_mode'] == null
          ? false
          : const MaintenanceModeConverter().fromJson(json['maintenance_mode']),
      maintenanceMessageField: json['maintenance_message'] as String?,
    );

Map<String, dynamic> _$AppConfigModelToJson(
  _AppConfigModel instance,
) => <String, dynamic>{
  'latest_android_version': instance.latestAndroidVersion,
  'latest_supported_android_version': instance.latestSupportedAndroidVersion,
  'update_android_features': instance.updateAndroidFeatures,
  'latest_ios_version': instance.latestIosVersion,
  'latest_supported_ios_version': instance.latestSupportedIosVersion,
  'update_ios_features': instance.updateIosFeatures,
  'direct_android_link': instance.directAndroidLink,
  'android_privacy_link': instance.androidPrivacyLink,
  'ios_privacy_link': instance.iosPrivacyLink,
  'maintenance_mode': const MaintenanceModeConverter().toJson(
    instance.maintenanceMode,
  ),
  'maintenance_message': instance.maintenanceMessageField,
};
