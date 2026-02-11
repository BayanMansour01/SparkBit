import 'package:freezed_annotation/freezed_annotation.dart';
part 'course_model.freezed.dart';
part 'course_model.g.dart';

@freezed
abstract class CourseModel with _$CourseModel {
  const factory CourseModel({
    required int id,
    @JsonKey(name: 'sub_category_id') required int subCategoryId,
    @JsonKey(name: 'instructor_id') required int instructorId,
    required String title,
    required String description,
    required String price,
    @JsonKey(name: 'is_free') required bool isFree,
    @JsonKey(name: 'cover_image_url') required String coverImageUrl,
    @JsonKey(name: 'lessons_count') required int lessonsCount,
    required InstructorModel instructor,
    required int order,
    @JsonKey(name: 'completion_percentage', defaultValue: 0)
    required int completionPercentage,
    @JsonKey(name: 'avg_rating', defaultValue: 0) required num avgRating,
    @JsonKey(name: 'is_purchased', defaultValue: false)
    required bool isPurchased,
  }) = _CourseModel;

  factory CourseModel.fromJson(Map<String, dynamic> json) =>
      _$CourseModelFromJson(json);
}

@freezed
abstract class InstructorModel with _$InstructorModel {
  const factory InstructorModel({
    required int id,
    required String name,
    required String bio,
    @JsonKey(name: 'image_url') required String imageUrl,
  }) = _InstructorModel;

  factory InstructorModel.fromJson(Map<String, dynamic> json) =>
      _$InstructorModelFromJson(json);
}
