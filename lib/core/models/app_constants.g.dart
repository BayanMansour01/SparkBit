// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_constants.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppConstants _$AppConstantsFromJson(Map<String, dynamic> json) =>
    _AppConstants(
      userRoles: (json['user_roles'] as List<dynamic>)
          .map((e) => ConstantValue.fromJson(e as Map<String, dynamic>))
          .toList(),
      userStatuses: (json['user_statuses'] as List<dynamic>)
          .map((e) => ConstantValue.fromJson(e as Map<String, dynamic>))
          .toList(),
      activityStatuses: (json['activity_statuses'] as List<dynamic>)
          .map((e) => ConstantValue.fromJson(e as Map<String, dynamic>))
          .toList(),
      paymentStatuses: (json['payment_statuses'] as List<dynamic>)
          .map((e) => ConstantValue.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AppConstantsToJson(_AppConstants instance) =>
    <String, dynamic>{
      'user_roles': instance.userRoles,
      'user_statuses': instance.userStatuses,
      'activity_statuses': instance.activityStatuses,
      'payment_statuses': instance.paymentStatuses,
    };
