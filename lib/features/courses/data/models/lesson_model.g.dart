// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LessonModel _$LessonModelFromJson(Map<String, dynamic> json) => _LessonModel(
  id: (json['id'] as num).toInt(),
  courseId: (json['course_id'] as num).toInt(),
  title: json['title'] as String,
  videoUrl: json['video_url'] as String?,
  attachmentPath: json['attachment_path'] as String?,
  isFree: json['is_free'] as bool,
  order: (json['order'] as num).toInt(),
  canAccess: json['can_access'] as bool,
  isCompleted: json['is_completed'] as bool?,
  progress: (json['progress'] as num?)?.toDouble(),
  avgRating: json['avg_rating'] as num? ?? 0,
);

Map<String, dynamic> _$LessonModelToJson(_LessonModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'course_id': instance.courseId,
      'title': instance.title,
      'video_url': instance.videoUrl,
      'attachment_path': instance.attachmentPath,
      'is_free': instance.isFree,
      'order': instance.order,
      'can_access': instance.canAccess,
      'is_completed': instance.isCompleted,
      'progress': instance.progress,
      'avg_rating': instance.avgRating,
    };
