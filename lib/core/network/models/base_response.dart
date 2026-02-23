import 'package:freezed_annotation/freezed_annotation.dart';

part 'base_response.freezed.dart';

@Freezed(genericArgumentFactories: true)
abstract class BaseResponse<T> with _$BaseResponse<T> {
  const factory BaseResponse({
    required bool success,
    required String message,
    T? data,
    required int code,
  }) = _BaseResponse;

  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    return BaseResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'] == null ? null : fromJsonT(json['data']),
      code: (json['code'] as num).toInt(),
    );
  }
}
