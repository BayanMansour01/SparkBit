// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OrderRequestModel _$OrderRequestModelFromJson(Map<String, dynamic> json) =>
    _OrderRequestModel(
      courseIds: (json['course_ids'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$OrderRequestModelToJson(_OrderRequestModel instance) =>
    <String, dynamic>{'course_ids': instance.courseIds};
