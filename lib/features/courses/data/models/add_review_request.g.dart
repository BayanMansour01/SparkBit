// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_review_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AddReviewRequest _$AddReviewRequestFromJson(Map<String, dynamic> json) =>
    _AddReviewRequest(
      lessonId: json['lesson_id'] as String,
      rating: json['rating'] as String?,
      comment: json['comment'] as String?,
    );

Map<String, dynamic> _$AddReviewRequestToJson(_AddReviewRequest instance) =>
    <String, dynamic>{
      'lesson_id': instance.lessonId,
      'rating': instance.rating,
      'comment': instance.comment,
    };
