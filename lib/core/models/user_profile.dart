import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_device.dart';
import 'constant_value.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

/// User status model
@freezed
abstract class UserStatus with _$UserStatus {
  const factory UserStatus({required String value, required String label}) =
      _UserStatus;

  factory UserStatus.fromJson(Map<String, dynamic> json) =>
      _$UserStatusFromJson(json);
}

/// User profile model
@freezed
abstract class UserProfile with _$UserProfile {
  const factory UserProfile({
    required int id,
    required String name,
    required String email,
    @JsonKey(name: 'google_id') String? googleId,
    String? avatar,
    required String role,
    ConstantValue? status,
    @JsonKey(name: 'userDevice') UserDevice? userDevice,
    @JsonKey(name: 'fcm_topics') List<String>? fcmTopics,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}
