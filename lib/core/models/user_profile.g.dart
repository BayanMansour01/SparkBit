// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserStatus _$UserStatusFromJson(Map<String, dynamic> json) =>
    _UserStatus(value: json['value'] as String, label: json['label'] as String);

Map<String, dynamic> _$UserStatusToJson(_UserStatus instance) =>
    <String, dynamic>{'value': instance.value, 'label': instance.label};

_UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => _UserProfile(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  email: json['email'] as String,
  googleId: json['google_id'] as String?,
  avatar: json['avatar'] as String?,
  role: json['role'] as String,
  status: json['status'] == null
      ? null
      : ConstantValue.fromJson(json['status'] as Map<String, dynamic>),
  userDevice: json['userDevice'] == null
      ? null
      : UserDevice.fromJson(json['userDevice'] as Map<String, dynamic>),
  fcmTopics: (json['fcm_topics'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
);

Map<String, dynamic> _$UserProfileToJson(_UserProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'google_id': instance.googleId,
      'avatar': instance.avatar,
      'role': instance.role,
      'status': instance.status,
      'userDevice': instance.userDevice,
      'fcm_topics': instance.fcmTopics,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
