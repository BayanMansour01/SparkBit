import 'package:freezed_annotation/freezed_annotation.dart';

part 'data_wrapper.freezed.dart';
part 'data_wrapper.g.dart';

@Freezed(genericArgumentFactories: true)
abstract class DataWrapper<T> with _$DataWrapper<T> {
  const factory DataWrapper({required T data}) = _DataWrapper;

  factory DataWrapper.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$DataWrapperFromJson(json, fromJsonT);
}
