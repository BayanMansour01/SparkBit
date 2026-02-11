import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/models/constant_value.dart';

part 'order_model.freezed.dart';
part 'order_model.g.dart';

@freezed
abstract class OrderModel with _$OrderModel {
  const factory OrderModel({
    required int id,
    required ConstantValue status,
    @JsonKey(name: 'total_price') required num totalPrice,
    @JsonKey(name: 'payment_proof') String? paymentProof,
    @JsonKey(name: 'rejected_reason') String? rejectedReason,
    required List<OrderItemModel> items,
    @JsonKey(name: 'approved_at') String? approvedAt,
    @JsonKey(name: 'rejected_at') String? rejectedAt,
  }) = _OrderModel;

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);
}

@freezed
abstract class OrderItemModel with _$OrderItemModel {
  const factory OrderItemModel({
    required int id,
    required OrderCourseModel course,
    required num price,
  }) = _OrderItemModel;

  factory OrderItemModel.fromJson(Map<String, dynamic> json) =>
      _$OrderItemModelFromJson(json);
}

@freezed
abstract class OrderCourseModel with _$OrderCourseModel {
  const factory OrderCourseModel({
    required int id,
    required String title,
    required String image,
    required OrderInstructorModel instructor,
  }) = _OrderCourseModel;

  factory OrderCourseModel.fromJson(Map<String, dynamic> json) =>
      _$OrderCourseModelFromJson(json);
}

@freezed
abstract class OrderInstructorModel with _$OrderInstructorModel {
  const factory OrderInstructorModel({required int id, required String name}) =
      _OrderInstructorModel;

  factory OrderInstructorModel.fromJson(Map<String, dynamic> json) =>
      _$OrderInstructorModelFromJson(json);
}
