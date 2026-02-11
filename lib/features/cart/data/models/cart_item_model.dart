import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../courses/data/models/course_model.dart';

part 'cart_item_model.freezed.dart';
part 'cart_item_model.g.dart';

@freezed
abstract class CartItemModel with _$CartItemModel {
  const factory CartItemModel({
    required String id, // Unique cart item ID (using course ID)
    required CourseModel course,
    required DateTime addedAt,
  }) = _CartItemModel;

  factory CartItemModel.fromJson(Map<String, dynamic> json) =>
      _$CartItemModelFromJson(json);
}
