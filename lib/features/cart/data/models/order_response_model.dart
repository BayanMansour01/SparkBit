import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_response_model.freezed.dart';
part 'order_response_model.g.dart';

@freezed
abstract class OrderResponseModel with _$OrderResponseModel {
  const factory OrderResponseModel({
    required int id,
    @JsonKey(name: 'student_id') required int studentId,
    @JsonKey(name: 'total_amount') required String totalAmount,
    required String status,
    @JsonKey(name: 'payment_method') String? paymentMethod,
    @JsonKey(name: 'payment_status') String? paymentStatus,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') required String updatedAt,
  }) = _OrderResponseModel;

  factory OrderResponseModel.fromJson(Map<String, dynamic> json) =>
      _$OrderResponseModelFromJson(json);
}
