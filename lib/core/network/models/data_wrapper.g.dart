// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_wrapper.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DataWrapper<T> _$DataWrapperFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => _DataWrapper<T>(data: fromJsonT(json['data']));

Map<String, dynamic> _$DataWrapperToJson<T>(
  _DataWrapper<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{'data': toJsonT(instance.data)};
