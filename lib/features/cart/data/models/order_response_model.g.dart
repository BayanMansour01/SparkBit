// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OrderResponseModel _$OrderResponseModelFromJson(Map<String, dynamic> json) =>
    _OrderResponseModel(
      id: (json['id'] as num).toInt(),
      studentId: (json['student_id'] as num).toInt(),
      totalAmount: json['total_amount'] as String,
      status: json['status'] as String,
      paymentMethod: json['payment_method'] as String?,
      paymentStatus: json['payment_status'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$OrderResponseModelToJson(_OrderResponseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'student_id': instance.studentId,
      'total_amount': instance.totalAmount,
      'status': instance.status,
      'payment_method': instance.paymentMethod,
      'payment_status': instance.paymentStatus,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
