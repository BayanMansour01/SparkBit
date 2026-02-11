import 'package:freezed_annotation/freezed_annotation.dart';

part 'constant_value.freezed.dart';
part 'constant_value.g.dart';

@freezed
sealed class ConstantValue with _$ConstantValue {
  const ConstantValue._();

  const factory ConstantValue({required String value, required String label}) =
      _ConstantValue;

  /// Returns a cleaned version of the label, fixing known typos from backend
  String get displayLabel {
    if (label.contains('Pyment')) {
      return label.replaceAll('Pyment', 'Payment');
    }
    return label;
  }

  factory ConstantValue.fromJson(Map<String, dynamic> json) =>
      _$ConstantValueFromJson(json);
}
