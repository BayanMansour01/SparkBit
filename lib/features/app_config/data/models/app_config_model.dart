import 'dart:io';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_config_model.freezed.dart';
part 'app_config_model.g.dart';

/// App configuration model from backend (Data Layer)
@freezed
abstract class AppConfigModel with _$AppConfigModel {
  const AppConfigModel._();

  const factory AppConfigModel({
    @JsonKey(name: 'latest_android_version')
    required String latestAndroidVersion,
    @JsonKey(name: 'latest_supported_android_version')
    required String latestSupportedAndroidVersion,
    @JsonKey(name: 'update_android_features')
    required String updateAndroidFeatures,
    @JsonKey(name: 'latest_ios_version') required String latestIosVersion,
    @JsonKey(name: 'latest_supported_ios_version')
    required String latestSupportedIosVersion,
    @JsonKey(name: 'update_ios_features') required String updateIosFeatures,
    @JsonKey(name: 'direct_android_link') required String directAndroidLink,
    @JsonKey(name: 'android_privacy_link') required String androidPrivacyLink,
    @JsonKey(name: 'ios_privacy_link') required String iosPrivacyLink,
  }) = _AppConfigModel;

  factory AppConfigModel.fromJson(Map<String, dynamic> json) =>
      _$AppConfigModelFromJson(json);

  // Computed properties for backward compatibility
  bool get isMaintenance => false;
  String? get maintenanceMessage => null;

  String get minVersion {
    if (Platform.isIOS) return latestSupportedIosVersion;
    return latestSupportedAndroidVersion;
  }

  String get latestVersion {
    if (Platform.isIOS) return latestIosVersion;
    return latestAndroidVersion;
  }

  String get privacyLink {
    if (Platform.isIOS) return iosPrivacyLink;
    return androidPrivacyLink;
  }

  bool get forceUpdate => true; // Still defaults to true for safety

  String? get updateMessage {
    if (Platform.isIOS) return updateIosFeatures;
    return updateAndroidFeatures;
  }

  String? get androidUrl => directAndroidLink;
  String? get iosUrl => iosPrivacyLink;
}
