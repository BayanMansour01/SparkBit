import 'dart:io';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_config_model.freezed.dart';
part 'app_config_model.g.dart';

// Custom converter for maintenance_mode to handle bool, int, and string
class MaintenanceModeConverter implements JsonConverter<bool, dynamic> {
  const MaintenanceModeConverter();

  @override
  bool fromJson(dynamic value) {
    if (value is bool) {
      return value;
    } else if (value is int) {
      return value == 1;
    } else if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }
    return false;
  }

  @override
  dynamic toJson(bool value) => value;
}

@freezed
abstract class AppConfigModel with _$AppConfigModel {
  const AppConfigModel._();

  const factory AppConfigModel({
    @JsonKey(name: 'latest_android_version')
    required dynamic latestAndroidVersion,
    @JsonKey(name: 'latest_supported_android_version')
    required dynamic latestSupportedAndroidVersion,
    @JsonKey(name: 'update_android_features')
    required String updateAndroidFeatures,
    @JsonKey(name: 'latest_ios_version') required dynamic latestIosVersion,
    @JsonKey(name: 'latest_supported_ios_version')
    required dynamic latestSupportedIosVersion,
    @JsonKey(name: 'update_ios_features') required String updateIosFeatures,
    @JsonKey(name: 'direct_android_link') required String directAndroidLink,
    @JsonKey(name: 'android_privacy_link') required String androidPrivacyLink,
    @JsonKey(name: 'ios_privacy_link') required String iosPrivacyLink,
    // إضافة حقول الصيانة القادمة من الـ JSON
    @JsonKey(name: 'maintenance_mode', defaultValue: false)
    @MaintenanceModeConverter()
    required bool maintenanceMode,
    @JsonKey(name: 'maintenance_message') String? maintenanceMessageField,
  }) = _AppConfigModel;

  factory AppConfigModel.fromJson(Map<String, dynamic> json) =>
      _$AppConfigModelFromJson(json);

  // تحويل القيم إلى String بأمان لتجنب تعارض الأنواع (Type Mismatch)
  String get _latestAndroid => latestAndroidVersion.toString();
  String get _minAndroid => latestSupportedAndroidVersion.toString();
  String get _latestIos => latestIosVersion.toString();
  String get _minIos => latestSupportedIosVersion.toString();

  bool get isMaintenance => maintenanceMode;

  // رسالة الصيانة (إذا موجودة في API أو رسالة افتراضية)
  String get maintenanceMessage =>
      maintenanceMessageField ??
      "We're currently improving your experience. We'll be back shortly!";

  // رسالة التحديث (ملاحظات التحديث حسب المنصة)
  String get updateMessage =>
      Platform.isIOS ? updateIosFeatures : updateAndroidFeatures;

  String get minVersion => Platform.isIOS ? _minIos : _minAndroid;
  String get latestVersion => Platform.isIOS ? _latestIos : _latestAndroid;

  // تصحيح: رابط الـ iOS غالباً يكون App Store وليس الخصوصية فقط
  String get updateUrl => Platform.isIOS ? iosPrivacyLink : directAndroidLink;
}
