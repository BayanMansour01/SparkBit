import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_request_model.freezed.dart';
part 'order_request_model.g.dart';

@freezed
abstract class OrderRequestModel with _$OrderRequestModel {
  const factory OrderRequestModel({
    @JsonKey(name: 'course_ids') required List<int> courseIds,
  }) = _OrderRequestModel;

  factory OrderRequestModel.fromJson(Map<String, dynamic> json) =>
      _$OrderRequestModelFromJson(json);
}
