// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OrderModel _$OrderModelFromJson(Map<String, dynamic> json) => _OrderModel(
  id: (json['id'] as num).toInt(),
  status: ConstantValue.fromJson(json['status'] as Map<String, dynamic>),
  totalPrice: json['total_price'] as num,
  paymentProof: json['payment_proof'] as String?,
  rejectedReason: json['rejected_reason'] as String?,
  items: (json['items'] as List<dynamic>)
      .map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  approvedAt: json['approved_at'] as String?,
  rejectedAt: json['rejected_at'] as String?,
);

Map<String, dynamic> _$OrderModelToJson(_OrderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'total_price': instance.totalPrice,
      'payment_proof': instance.paymentProof,
      'rejected_reason': instance.rejectedReason,
      'items': instance.items,
      'approved_at': instance.approvedAt,
      'rejected_at': instance.rejectedAt,
    };

_OrderItemModel _$OrderItemModelFromJson(Map<String, dynamic> json) =>
    _OrderItemModel(
      id: (json['id'] as num).toInt(),
      course: OrderCourseModel.fromJson(json['course'] as Map<String, dynamic>),
      price: json['price'] as num,
    );

Map<String, dynamic> _$OrderItemModelToJson(_OrderItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'course': instance.course,
      'price': instance.price,
    };

_OrderCourseModel _$OrderCourseModelFromJson(Map<String, dynamic> json) =>
    _OrderCourseModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      image: json['image'] as String,
      instructor: OrderInstructorModel.fromJson(
        json['instructor'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$OrderCourseModelToJson(_OrderCourseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'image': instance.image,
      'instructor': instance.instructor,
    };

_OrderInstructorModel _$OrderInstructorModelFromJson(
  Map<String, dynamic> json,
) => _OrderInstructorModel(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
);

Map<String, dynamic> _$OrderInstructorModelToJson(
  _OrderInstructorModel instance,
) => <String, dynamic>{'id': instance.id, 'name': instance.name};
