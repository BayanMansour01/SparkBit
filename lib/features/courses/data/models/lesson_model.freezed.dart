// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lesson_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LessonModel {

 int get id;@JsonKey(name: 'course_id') int get courseId; String get title;@JsonKey(name: 'video_url') String? get videoUrl;@JsonKey(name: 'attachment_path') String? get attachmentPath;@JsonKey(name: 'is_free') bool get isFree; int get order;@JsonKey(name: 'can_access') bool get canAccess;@JsonKey(name: 'is_completed') bool? get isCompleted; double? get progress;@JsonKey(name: 'avg_rating', defaultValue: 0) num? get avgRating;
/// Create a copy of LessonModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LessonModelCopyWith<LessonModel> get copyWith => _$LessonModelCopyWithImpl<LessonModel>(this as LessonModel, _$identity);

  /// Serializes this LessonModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LessonModel&&(identical(other.id, id) || other.id == id)&&(identical(other.courseId, courseId) || other.courseId == courseId)&&(identical(other.title, title) || other.title == title)&&(identical(other.videoUrl, videoUrl) || other.videoUrl == videoUrl)&&(identical(other.attachmentPath, attachmentPath) || other.attachmentPath == attachmentPath)&&(identical(other.isFree, isFree) || other.isFree == isFree)&&(identical(other.order, order) || other.order == order)&&(identical(other.canAccess, canAccess) || other.canAccess == canAccess)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.avgRating, avgRating) || other.avgRating == avgRating));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,courseId,title,videoUrl,attachmentPath,isFree,order,canAccess,isCompleted,progress,avgRating);

@override
String toString() {
  return 'LessonModel(id: $id, courseId: $courseId, title: $title, videoUrl: $videoUrl, attachmentPath: $attachmentPath, isFree: $isFree, order: $order, canAccess: $canAccess, isCompleted: $isCompleted, progress: $progress, avgRating: $avgRating)';
}


}

/// @nodoc
abstract mixin class $LessonModelCopyWith<$Res>  {
  factory $LessonModelCopyWith(LessonModel value, $Res Function(LessonModel) _then) = _$LessonModelCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'course_id') int courseId, String title,@JsonKey(name: 'video_url') String? videoUrl,@JsonKey(name: 'attachment_path') String? attachmentPath,@JsonKey(name: 'is_free') bool isFree, int order,@JsonKey(name: 'can_access') bool canAccess,@JsonKey(name: 'is_completed') bool? isCompleted, double? progress,@JsonKey(name: 'avg_rating', defaultValue: 0) num? avgRating
});




}
/// @nodoc
class _$LessonModelCopyWithImpl<$Res>
    implements $LessonModelCopyWith<$Res> {
  _$LessonModelCopyWithImpl(this._self, this._then);

  final LessonModel _self;
  final $Res Function(LessonModel) _then;

/// Create a copy of LessonModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? courseId = null,Object? title = null,Object? videoUrl = freezed,Object? attachmentPath = freezed,Object? isFree = null,Object? order = null,Object? canAccess = null,Object? isCompleted = freezed,Object? progress = freezed,Object? avgRating = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,courseId: null == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,videoUrl: freezed == videoUrl ? _self.videoUrl : videoUrl // ignore: cast_nullable_to_non_nullable
as String?,attachmentPath: freezed == attachmentPath ? _self.attachmentPath : attachmentPath // ignore: cast_nullable_to_non_nullable
as String?,isFree: null == isFree ? _self.isFree : isFree // ignore: cast_nullable_to_non_nullable
as bool,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,canAccess: null == canAccess ? _self.canAccess : canAccess // ignore: cast_nullable_to_non_nullable
as bool,isCompleted: freezed == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool?,progress: freezed == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double?,avgRating: freezed == avgRating ? _self.avgRating : avgRating // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}

}


/// Adds pattern-matching-related methods to [LessonModel].
extension LessonModelPatterns on LessonModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LessonModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LessonModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LessonModel value)  $default,){
final _that = this;
switch (_that) {
case _LessonModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LessonModel value)?  $default,){
final _that = this;
switch (_that) {
case _LessonModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'course_id')  int courseId,  String title, @JsonKey(name: 'video_url')  String? videoUrl, @JsonKey(name: 'attachment_path')  String? attachmentPath, @JsonKey(name: 'is_free')  bool isFree,  int order, @JsonKey(name: 'can_access')  bool canAccess, @JsonKey(name: 'is_completed')  bool? isCompleted,  double? progress, @JsonKey(name: 'avg_rating', defaultValue: 0)  num? avgRating)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LessonModel() when $default != null:
return $default(_that.id,_that.courseId,_that.title,_that.videoUrl,_that.attachmentPath,_that.isFree,_that.order,_that.canAccess,_that.isCompleted,_that.progress,_that.avgRating);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'course_id')  int courseId,  String title, @JsonKey(name: 'video_url')  String? videoUrl, @JsonKey(name: 'attachment_path')  String? attachmentPath, @JsonKey(name: 'is_free')  bool isFree,  int order, @JsonKey(name: 'can_access')  bool canAccess, @JsonKey(name: 'is_completed')  bool? isCompleted,  double? progress, @JsonKey(name: 'avg_rating', defaultValue: 0)  num? avgRating)  $default,) {final _that = this;
switch (_that) {
case _LessonModel():
return $default(_that.id,_that.courseId,_that.title,_that.videoUrl,_that.attachmentPath,_that.isFree,_that.order,_that.canAccess,_that.isCompleted,_that.progress,_that.avgRating);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'course_id')  int courseId,  String title, @JsonKey(name: 'video_url')  String? videoUrl, @JsonKey(name: 'attachment_path')  String? attachmentPath, @JsonKey(name: 'is_free')  bool isFree,  int order, @JsonKey(name: 'can_access')  bool canAccess, @JsonKey(name: 'is_completed')  bool? isCompleted,  double? progress, @JsonKey(name: 'avg_rating', defaultValue: 0)  num? avgRating)?  $default,) {final _that = this;
switch (_that) {
case _LessonModel() when $default != null:
return $default(_that.id,_that.courseId,_that.title,_that.videoUrl,_that.attachmentPath,_that.isFree,_that.order,_that.canAccess,_that.isCompleted,_that.progress,_that.avgRating);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LessonModel extends LessonModel {
  const _LessonModel({required this.id, @JsonKey(name: 'course_id') required this.courseId, required this.title, @JsonKey(name: 'video_url') this.videoUrl, @JsonKey(name: 'attachment_path') this.attachmentPath, @JsonKey(name: 'is_free') required this.isFree, required this.order, @JsonKey(name: 'can_access') required this.canAccess, @JsonKey(name: 'is_completed') this.isCompleted, this.progress, @JsonKey(name: 'avg_rating', defaultValue: 0) this.avgRating}): super._();
  factory _LessonModel.fromJson(Map<String, dynamic> json) => _$LessonModelFromJson(json);

@override final  int id;
@override@JsonKey(name: 'course_id') final  int courseId;
@override final  String title;
@override@JsonKey(name: 'video_url') final  String? videoUrl;
@override@JsonKey(name: 'attachment_path') final  String? attachmentPath;
@override@JsonKey(name: 'is_free') final  bool isFree;
@override final  int order;
@override@JsonKey(name: 'can_access') final  bool canAccess;
@override@JsonKey(name: 'is_completed') final  bool? isCompleted;
@override final  double? progress;
@override@JsonKey(name: 'avg_rating', defaultValue: 0) final  num? avgRating;

/// Create a copy of LessonModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LessonModelCopyWith<_LessonModel> get copyWith => __$LessonModelCopyWithImpl<_LessonModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LessonModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LessonModel&&(identical(other.id, id) || other.id == id)&&(identical(other.courseId, courseId) || other.courseId == courseId)&&(identical(other.title, title) || other.title == title)&&(identical(other.videoUrl, videoUrl) || other.videoUrl == videoUrl)&&(identical(other.attachmentPath, attachmentPath) || other.attachmentPath == attachmentPath)&&(identical(other.isFree, isFree) || other.isFree == isFree)&&(identical(other.order, order) || other.order == order)&&(identical(other.canAccess, canAccess) || other.canAccess == canAccess)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.avgRating, avgRating) || other.avgRating == avgRating));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,courseId,title,videoUrl,attachmentPath,isFree,order,canAccess,isCompleted,progress,avgRating);

@override
String toString() {
  return 'LessonModel(id: $id, courseId: $courseId, title: $title, videoUrl: $videoUrl, attachmentPath: $attachmentPath, isFree: $isFree, order: $order, canAccess: $canAccess, isCompleted: $isCompleted, progress: $progress, avgRating: $avgRating)';
}


}

/// @nodoc
abstract mixin class _$LessonModelCopyWith<$Res> implements $LessonModelCopyWith<$Res> {
  factory _$LessonModelCopyWith(_LessonModel value, $Res Function(_LessonModel) _then) = __$LessonModelCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'course_id') int courseId, String title,@JsonKey(name: 'video_url') String? videoUrl,@JsonKey(name: 'attachment_path') String? attachmentPath,@JsonKey(name: 'is_free') bool isFree, int order,@JsonKey(name: 'can_access') bool canAccess,@JsonKey(name: 'is_completed') bool? isCompleted, double? progress,@JsonKey(name: 'avg_rating', defaultValue: 0) num? avgRating
});




}
/// @nodoc
class __$LessonModelCopyWithImpl<$Res>
    implements _$LessonModelCopyWith<$Res> {
  __$LessonModelCopyWithImpl(this._self, this._then);

  final _LessonModel _self;
  final $Res Function(_LessonModel) _then;

/// Create a copy of LessonModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? courseId = null,Object? title = null,Object? videoUrl = freezed,Object? attachmentPath = freezed,Object? isFree = null,Object? order = null,Object? canAccess = null,Object? isCompleted = freezed,Object? progress = freezed,Object? avgRating = freezed,}) {
  return _then(_LessonModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,courseId: null == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,videoUrl: freezed == videoUrl ? _self.videoUrl : videoUrl // ignore: cast_nullable_to_non_nullable
as String?,attachmentPath: freezed == attachmentPath ? _self.attachmentPath : attachmentPath // ignore: cast_nullable_to_non_nullable
as String?,isFree: null == isFree ? _self.isFree : isFree // ignore: cast_nullable_to_non_nullable
as bool,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,canAccess: null == canAccess ? _self.canAccess : canAccess // ignore: cast_nullable_to_non_nullable
as bool,isCompleted: freezed == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool?,progress: freezed == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double?,avgRating: freezed == avgRating ? _self.avgRating : avgRating // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}


}

// dart format on
