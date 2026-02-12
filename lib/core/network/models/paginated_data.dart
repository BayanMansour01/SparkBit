import 'package:freezed_annotation/freezed_annotation.dart';
import 'pagination_model.dart';

part 'paginated_data.freezed.dart';
part 'paginated_data.g.dart';

@Freezed(genericArgumentFactories: true)
abstract class PaginatedData<T> with _$PaginatedData<T> {
  const factory PaginatedData({
    required List<T> data,
    required PaginationModel pagination,
  }) = _PaginatedData;

  factory PaginatedData.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$PaginatedDataFromJson(json, fromJsonT);
}
