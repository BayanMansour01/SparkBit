// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CourseModel _$CourseModelFromJson(Map<String, dynamic> json) => _CourseModel(
  id: (json['id'] as num).toInt(),
  subCategoryId: (json['sub_category_id'] as num).toInt(),
  instructorId: (json['instructor_id'] as num).toInt(),
  title: json['title'] as String,
  description: json['description'] as String,
  price: json['price'] as String,
  isFree: json['is_free'] as bool,
  coverImageUrl: json['cover_image_url'] as String,
  lessonsCount: (json['lessons_count'] as num).toInt(),
  instructor: InstructorModel.fromJson(
    json['instructor'] as Map<String, dynamic>,
  ),
  order: (json['order'] as num).toInt(),
  completionPercentage: (json['completion_percentage'] as num?)?.toInt() ?? 0,
  avgRating: json['avg_rating'] as num? ?? 0,
  isPurchased: json['is_purchased'] as bool? ?? false,
);

Map<String, dynamic> _$CourseModelToJson(_CourseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sub_category_id': instance.subCategoryId,
      'instructor_id': instance.instructorId,
      'title': instance.title,
      'description': instance.description,
      'price': instance.price,
      'is_free': instance.isFree,
      'cover_image_url': instance.coverImageUrl,
      'lessons_count': instance.lessonsCount,
      'instructor': instance.instructor,
      'order': instance.order,
      'completion_percentage': instance.completionPercentage,
      'avg_rating': instance.avgRating,
      'is_purchased': instance.isPurchased,
    };

_InstructorModel _$InstructorModelFromJson(Map<String, dynamic> json) =>
    _InstructorModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      bio: json['bio'] as String,
      imageUrl: json['image_url'] as String,
    );

Map<String, dynamic> _$InstructorModelToJson(_InstructorModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'bio': instance.bio,
      'image_url': instance.imageUrl,
    };
