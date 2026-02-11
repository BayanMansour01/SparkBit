// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'add_review_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AddReviewRequest {

@JsonKey(name: 'lesson_id') String get lessonId; String? get rating; String? get comment;
/// Create a copy of AddReviewRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddReviewRequestCopyWith<AddReviewRequest> get copyWith => _$AddReviewRequestCopyWithImpl<AddReviewRequest>(this as AddReviewRequest, _$identity);

  /// Serializes this AddReviewRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddReviewRequest&&(identical(other.lessonId, lessonId) || other.lessonId == lessonId)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.comment, comment) || other.comment == comment));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lessonId,rating,comment);

@override
String toString() {
  return 'AddReviewRequest(lessonId: $lessonId, rating: $rating, comment: $comment)';
}


}

/// @nodoc
abstract mixin class $AddReviewRequestCopyWith<$Res>  {
  factory $AddReviewRequestCopyWith(AddReviewRequest value, $Res Function(AddReviewRequest) _then) = _$AddReviewRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'lesson_id') String lessonId, String? rating, String? comment
});




}
/// @nodoc
class _$AddReviewRequestCopyWithImpl<$Res>
    implements $AddReviewRequestCopyWith<$Res> {
  _$AddReviewRequestCopyWithImpl(this._self, this._then);

  final AddReviewRequest _self;
  final $Res Function(AddReviewRequest) _then;

/// Create a copy of AddReviewRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lessonId = null,Object? rating = freezed,Object? comment = freezed,}) {
  return _then(_self.copyWith(
lessonId: null == lessonId ? _self.lessonId : lessonId // ignore: cast_nullable_to_non_nullable
as String,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as String?,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AddReviewRequest].
extension AddReviewRequestPatterns on AddReviewRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AddReviewRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AddReviewRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AddReviewRequest value)  $default,){
final _that = this;
switch (_that) {
case _AddReviewRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AddReviewRequest value)?  $default,){
final _that = this;
switch (_that) {
case _AddReviewRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'lesson_id')  String lessonId,  String? rating,  String? comment)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AddReviewRequest() when $default != null:
return $default(_that.lessonId,_that.rating,_that.comment);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'lesson_id')  String lessonId,  String? rating,  String? comment)  $default,) {final _that = this;
switch (_that) {
case _AddReviewRequest():
return $default(_that.lessonId,_that.rating,_that.comment);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'lesson_id')  String lessonId,  String? rating,  String? comment)?  $default,) {final _that = this;
switch (_that) {
case _AddReviewRequest() when $default != null:
return $default(_that.lessonId,_that.rating,_that.comment);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AddReviewRequest implements AddReviewRequest {
  const _AddReviewRequest({@JsonKey(name: 'lesson_id') required this.lessonId, this.rating, this.comment});
  factory _AddReviewRequest.fromJson(Map<String, dynamic> json) => _$AddReviewRequestFromJson(json);

@override@JsonKey(name: 'lesson_id') final  String lessonId;
@override final  String? rating;
@override final  String? comment;

/// Create a copy of AddReviewRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddReviewRequestCopyWith<_AddReviewRequest> get copyWith => __$AddReviewRequestCopyWithImpl<_AddReviewRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AddReviewRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddReviewRequest&&(identical(other.lessonId, lessonId) || other.lessonId == lessonId)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.comment, comment) || other.comment == comment));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lessonId,rating,comment);

@override
String toString() {
  return 'AddReviewRequest(lessonId: $lessonId, rating: $rating, comment: $comment)';
}


}

/// @nodoc
abstract mixin class _$AddReviewRequestCopyWith<$Res> implements $AddReviewRequestCopyWith<$Res> {
  factory _$AddReviewRequestCopyWith(_AddReviewRequest value, $Res Function(_AddReviewRequest) _then) = __$AddReviewRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'lesson_id') String lessonId, String? rating, String? comment
});




}
/// @nodoc
class __$AddReviewRequestCopyWithImpl<$Res>
    implements _$AddReviewRequestCopyWith<$Res> {
  __$AddReviewRequestCopyWithImpl(this._self, this._then);

  final _AddReviewRequest _self;
  final $Res Function(_AddReviewRequest) _then;

/// Create a copy of AddReviewRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lessonId = null,Object? rating = freezed,Object? comment = freezed,}) {
  return _then(_AddReviewRequest(
lessonId: null == lessonId ? _self.lessonId : lessonId // ignore: cast_nullable_to_non_nullable
as String,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as String?,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
