import 'package:freezed_annotation/freezed_annotation.dart';

part 'lesson_model.freezed.dart';
part 'lesson_model.g.dart';

enum LessonType { video, file }

@freezed
abstract class LessonModel with _$LessonModel {
  const LessonModel._();

  const factory LessonModel({
    required int id,
    @JsonKey(name: 'course_id') required int courseId,
    required String title,
    @JsonKey(name: 'video_url') String? videoUrl,
    @JsonKey(name: 'attachment_path') String? attachmentPath,
    @JsonKey(name: 'is_free') required bool isFree,
    required int order,
    @JsonKey(name: 'can_access') required bool canAccess,
    @JsonKey(name: 'is_completed') bool? isCompleted,
    double? progress,
    @JsonKey(name: 'avg_rating', defaultValue: 0) num? avgRating,
  }) = _LessonModel;

  factory LessonModel.fromJson(Map<String, dynamic> json) =>
      _$LessonModelFromJson(json);

  LessonType get type {
    if (videoUrl != null && videoUrl!.isNotEmpty) {
      return LessonType.video;
    }
    return LessonType.file;
  }

  bool get hasVideo => type == LessonType.video;
}
