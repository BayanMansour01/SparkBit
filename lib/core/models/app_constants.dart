import 'package:freezed_annotation/freezed_annotation.dart';
import 'constant_value.dart';

part 'app_constants.freezed.dart';
part 'app_constants.g.dart';

@freezed
abstract class AppConstants with _$AppConstants {
  const factory AppConstants({
    @JsonKey(name: 'user_roles') required List<ConstantValue> userRoles,
    @JsonKey(name: 'user_statuses') required List<ConstantValue> userStatuses,
    @JsonKey(name: 'activity_statuses')
    required List<ConstantValue> activityStatuses,
    @JsonKey(name: 'order_statuses') required List<ConstantValue> orderStatuses,
  }) = _AppConstants;

  factory AppConstants.fromJson(Map<String, dynamic> json) =>
      _$AppConstantsFromJson(json);
}
