// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'course_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CourseModel {

 int get id;@JsonKey(name: 'sub_category_id') int get subCategoryId;@JsonKey(name: 'instructor_id') int get instructorId; String get title; String get description; String get price;@JsonKey(name: 'is_free') bool get isFree;@JsonKey(name: 'cover_image_url') String get coverImageUrl;@JsonKey(name: 'lessons_count') int get lessonsCount; InstructorModel get instructor; int get order;@JsonKey(name: 'completion_percentage', defaultValue: 0) int get completionPercentage;@JsonKey(name: 'avg_rating', defaultValue: 0) num get avgRating;@JsonKey(name: 'is_purchased', defaultValue: false) bool get isPurchased;
/// Create a copy of CourseModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CourseModelCopyWith<CourseModel> get copyWith => _$CourseModelCopyWithImpl<CourseModel>(this as CourseModel, _$identity);

  /// Serializes this CourseModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CourseModel&&(identical(other.id, id) || other.id == id)&&(identical(other.subCategoryId, subCategoryId) || other.subCategoryId == subCategoryId)&&(identical(other.instructorId, instructorId) || other.instructorId == instructorId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.price, price) || other.price == price)&&(identical(other.isFree, isFree) || other.isFree == isFree)&&(identical(other.coverImageUrl, coverImageUrl) || other.coverImageUrl == coverImageUrl)&&(identical(other.lessonsCount, lessonsCount) || other.lessonsCount == lessonsCount)&&(identical(other.instructor, instructor) || other.instructor == instructor)&&(identical(other.order, order) || other.order == order)&&(identical(other.completionPercentage, completionPercentage) || other.completionPercentage == completionPercentage)&&(identical(other.avgRating, avgRating) || other.avgRating == avgRating)&&(identical(other.isPurchased, isPurchased) || other.isPurchased == isPurchased));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,subCategoryId,instructorId,title,description,price,isFree,coverImageUrl,lessonsCount,instructor,order,completionPercentage,avgRating,isPurchased);

@override
String toString() {
  return 'CourseModel(id: $id, subCategoryId: $subCategoryId, instructorId: $instructorId, title: $title, description: $description, price: $price, isFree: $isFree, coverImageUrl: $coverImageUrl, lessonsCount: $lessonsCount, instructor: $instructor, order: $order, completionPercentage: $completionPercentage, avgRating: $avgRating, isPurchased: $isPurchased)';
}


}

/// @nodoc
abstract mixin class $CourseModelCopyWith<$Res>  {
  factory $CourseModelCopyWith(CourseModel value, $Res Function(CourseModel) _then) = _$CourseModelCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'sub_category_id') int subCategoryId,@JsonKey(name: 'instructor_id') int instructorId, String title, String description, String price,@JsonKey(name: 'is_free') bool isFree,@JsonKey(name: 'cover_image_url') String coverImageUrl,@JsonKey(name: 'lessons_count') int lessonsCount, InstructorModel instructor, int order,@JsonKey(name: 'completion_percentage', defaultValue: 0) int completionPercentage,@JsonKey(name: 'avg_rating', defaultValue: 0) num avgRating,@JsonKey(name: 'is_purchased', defaultValue: false) bool isPurchased
});


$InstructorModelCopyWith<$Res> get instructor;

}
/// @nodoc
class _$CourseModelCopyWithImpl<$Res>
    implements $CourseModelCopyWith<$Res> {
  _$CourseModelCopyWithImpl(this._self, this._then);

  final CourseModel _self;
  final $Res Function(CourseModel) _then;

/// Create a copy of CourseModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? subCategoryId = null,Object? instructorId = null,Object? title = null,Object? description = null,Object? price = null,Object? isFree = null,Object? coverImageUrl = null,Object? lessonsCount = null,Object? instructor = null,Object? order = null,Object? completionPercentage = null,Object? avgRating = null,Object? isPurchased = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,subCategoryId: null == subCategoryId ? _self.subCategoryId : subCategoryId // ignore: cast_nullable_to_non_nullable
as int,instructorId: null == instructorId ? _self.instructorId : instructorId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as String,isFree: null == isFree ? _self.isFree : isFree // ignore: cast_nullable_to_non_nullable
as bool,coverImageUrl: null == coverImageUrl ? _self.coverImageUrl : coverImageUrl // ignore: cast_nullable_to_non_nullable
as String,lessonsCount: null == lessonsCount ? _self.lessonsCount : lessonsCount // ignore: cast_nullable_to_non_nullable
as int,instructor: null == instructor ? _self.instructor : instructor // ignore: cast_nullable_to_non_nullable
as InstructorModel,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,completionPercentage: null == completionPercentage ? _self.completionPercentage : completionPercentage // ignore: cast_nullable_to_non_nullable
as int,avgRating: null == avgRating ? _self.avgRating : avgRating // ignore: cast_nullable_to_non_nullable
as num,isPurchased: null == isPurchased ? _self.isPurchased : isPurchased // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of CourseModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InstructorModelCopyWith<$Res> get instructor {
  
  return $InstructorModelCopyWith<$Res>(_self.instructor, (value) {
    return _then(_self.copyWith(instructor: value));
  });
}
}


/// Adds pattern-matching-related methods to [CourseModel].
extension CourseModelPatterns on CourseModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CourseModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CourseModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CourseModel value)  $default,){
final _that = this;
switch (_that) {
case _CourseModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CourseModel value)?  $default,){
final _that = this;
switch (_that) {
case _CourseModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'sub_category_id')  int subCategoryId, @JsonKey(name: 'instructor_id')  int instructorId,  String title,  String description,  String price, @JsonKey(name: 'is_free')  bool isFree, @JsonKey(name: 'cover_image_url')  String coverImageUrl, @JsonKey(name: 'lessons_count')  int lessonsCount,  InstructorModel instructor,  int order, @JsonKey(name: 'completion_percentage', defaultValue: 0)  int completionPercentage, @JsonKey(name: 'avg_rating', defaultValue: 0)  num avgRating, @JsonKey(name: 'is_purchased', defaultValue: false)  bool isPurchased)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CourseModel() when $default != null:
return $default(_that.id,_that.subCategoryId,_that.instructorId,_that.title,_that.description,_that.price,_that.isFree,_that.coverImageUrl,_that.lessonsCount,_that.instructor,_that.order,_that.completionPercentage,_that.avgRating,_that.isPurchased);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'sub_category_id')  int subCategoryId, @JsonKey(name: 'instructor_id')  int instructorId,  String title,  String description,  String price, @JsonKey(name: 'is_free')  bool isFree, @JsonKey(name: 'cover_image_url')  String coverImageUrl, @JsonKey(name: 'lessons_count')  int lessonsCount,  InstructorModel instructor,  int order, @JsonKey(name: 'completion_percentage', defaultValue: 0)  int completionPercentage, @JsonKey(name: 'avg_rating', defaultValue: 0)  num avgRating, @JsonKey(name: 'is_purchased', defaultValue: false)  bool isPurchased)  $default,) {final _that = this;
switch (_that) {
case _CourseModel():
return $default(_that.id,_that.subCategoryId,_that.instructorId,_that.title,_that.description,_that.price,_that.isFree,_that.coverImageUrl,_that.lessonsCount,_that.instructor,_that.order,_that.completionPercentage,_that.avgRating,_that.isPurchased);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'sub_category_id')  int subCategoryId, @JsonKey(name: 'instructor_id')  int instructorId,  String title,  String description,  String price, @JsonKey(name: 'is_free')  bool isFree, @JsonKey(name: 'cover_image_url')  String coverImageUrl, @JsonKey(name: 'lessons_count')  int lessonsCount,  InstructorModel instructor,  int order, @JsonKey(name: 'completion_percentage', defaultValue: 0)  int completionPercentage, @JsonKey(name: 'avg_rating', defaultValue: 0)  num avgRating, @JsonKey(name: 'is_purchased', defaultValue: false)  bool isPurchased)?  $default,) {final _that = this;
switch (_that) {
case _CourseModel() when $default != null:
return $default(_that.id,_that.subCategoryId,_that.instructorId,_that.title,_that.description,_that.price,_that.isFree,_that.coverImageUrl,_that.lessonsCount,_that.instructor,_that.order,_that.completionPercentage,_that.avgRating,_that.isPurchased);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CourseModel implements CourseModel {
  const _CourseModel({required this.id, @JsonKey(name: 'sub_category_id') required this.subCategoryId, @JsonKey(name: 'instructor_id') required this.instructorId, required this.title, required this.description, required this.price, @JsonKey(name: 'is_free') required this.isFree, @JsonKey(name: 'cover_image_url') required this.coverImageUrl, @JsonKey(name: 'lessons_count') required this.lessonsCount, required this.instructor, required this.order, @JsonKey(name: 'completion_percentage', defaultValue: 0) required this.completionPercentage, @JsonKey(name: 'avg_rating', defaultValue: 0) required this.avgRating, @JsonKey(name: 'is_purchased', defaultValue: false) required this.isPurchased});
  factory _CourseModel.fromJson(Map<String, dynamic> json) => _$CourseModelFromJson(json);

@override final  int id;
@override@JsonKey(name: 'sub_category_id') final  int subCategoryId;
@override@JsonKey(name: 'instructor_id') final  int instructorId;
@override final  String title;
@override final  String description;
@override final  String price;
@override@JsonKey(name: 'is_free') final  bool isFree;
@override@JsonKey(name: 'cover_image_url') final  String coverImageUrl;
@override@JsonKey(name: 'lessons_count') final  int lessonsCount;
@override final  InstructorModel instructor;
@override final  int order;
@override@JsonKey(name: 'completion_percentage', defaultValue: 0) final  int completionPercentage;
@override@JsonKey(name: 'avg_rating', defaultValue: 0) final  num avgRating;
@override@JsonKey(name: 'is_purchased', defaultValue: false) final  bool isPurchased;

/// Create a copy of CourseModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CourseModelCopyWith<_CourseModel> get copyWith => __$CourseModelCopyWithImpl<_CourseModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CourseModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CourseModel&&(identical(other.id, id) || other.id == id)&&(identical(other.subCategoryId, subCategoryId) || other.subCategoryId == subCategoryId)&&(identical(other.instructorId, instructorId) || other.instructorId == instructorId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.price, price) || other.price == price)&&(identical(other.isFree, isFree) || other.isFree == isFree)&&(identical(other.coverImageUrl, coverImageUrl) || other.coverImageUrl == coverImageUrl)&&(identical(other.lessonsCount, lessonsCount) || other.lessonsCount == lessonsCount)&&(identical(other.instructor, instructor) || other.instructor == instructor)&&(identical(other.order, order) || other.order == order)&&(identical(other.completionPercentage, completionPercentage) || other.completionPercentage == completionPercentage)&&(identical(other.avgRating, avgRating) || other.avgRating == avgRating)&&(identical(other.isPurchased, isPurchased) || other.isPurchased == isPurchased));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,subCategoryId,instructorId,title,description,price,isFree,coverImageUrl,lessonsCount,instructor,order,completionPercentage,avgRating,isPurchased);

@override
String toString() {
  return 'CourseModel(id: $id, subCategoryId: $subCategoryId, instructorId: $instructorId, title: $title, description: $description, price: $price, isFree: $isFree, coverImageUrl: $coverImageUrl, lessonsCount: $lessonsCount, instructor: $instructor, order: $order, completionPercentage: $completionPercentage, avgRating: $avgRating, isPurchased: $isPurchased)';
}


}

/// @nodoc
abstract mixin class _$CourseModelCopyWith<$Res> implements $CourseModelCopyWith<$Res> {
  factory _$CourseModelCopyWith(_CourseModel value, $Res Function(_CourseModel) _then) = __$CourseModelCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'sub_category_id') int subCategoryId,@JsonKey(name: 'instructor_id') int instructorId, String title, String description, String price,@JsonKey(name: 'is_free') bool isFree,@JsonKey(name: 'cover_image_url') String coverImageUrl,@JsonKey(name: 'lessons_count') int lessonsCount, InstructorModel instructor, int order,@JsonKey(name: 'completion_percentage', defaultValue: 0) int completionPercentage,@JsonKey(name: 'avg_rating', defaultValue: 0) num avgRating,@JsonKey(name: 'is_purchased', defaultValue: false) bool isPurchased
});


@override $InstructorModelCopyWith<$Res> get instructor;

}
/// @nodoc
class __$CourseModelCopyWithImpl<$Res>
    implements _$CourseModelCopyWith<$Res> {
  __$CourseModelCopyWithImpl(this._self, this._then);

  final _CourseModel _self;
  final $Res Function(_CourseModel) _then;

/// Create a copy of CourseModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? subCategoryId = null,Object? instructorId = null,Object? title = null,Object? description = null,Object? price = null,Object? isFree = null,Object? coverImageUrl = null,Object? lessonsCount = null,Object? instructor = null,Object? order = null,Object? completionPercentage = null,Object? avgRating = null,Object? isPurchased = null,}) {
  return _then(_CourseModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,subCategoryId: null == subCategoryId ? _self.subCategoryId : subCategoryId // ignore: cast_nullable_to_non_nullable
as int,instructorId: null == instructorId ? _self.instructorId : instructorId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as String,isFree: null == isFree ? _self.isFree : isFree // ignore: cast_nullable_to_non_nullable
as bool,coverImageUrl: null == coverImageUrl ? _self.coverImageUrl : coverImageUrl // ignore: cast_nullable_to_non_nullable
as String,lessonsCount: null == lessonsCount ? _self.lessonsCount : lessonsCount // ignore: cast_nullable_to_non_nullable
as int,instructor: null == instructor ? _self.instructor : instructor // ignore: cast_nullable_to_non_nullable
as InstructorModel,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,completionPercentage: null == completionPercentage ? _self.completionPercentage : completionPercentage // ignore: cast_nullable_to_non_nullable
as int,avgRating: null == avgRating ? _self.avgRating : avgRating // ignore: cast_nullable_to_non_nullable
as num,isPurchased: null == isPurchased ? _self.isPurchased : isPurchased // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of CourseModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InstructorModelCopyWith<$Res> get instructor {
  
  return $InstructorModelCopyWith<$Res>(_self.instructor, (value) {
    return _then(_self.copyWith(instructor: value));
  });
}
}


/// @nodoc
mixin _$InstructorModel {

 int get id; String get name; String get bio;@JsonKey(name: 'image_url') String get imageUrl;
/// Create a copy of InstructorModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InstructorModelCopyWith<InstructorModel> get copyWith => _$InstructorModelCopyWithImpl<InstructorModel>(this as InstructorModel, _$identity);

  /// Serializes this InstructorModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InstructorModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,bio,imageUrl);

@override
String toString() {
  return 'InstructorModel(id: $id, name: $name, bio: $bio, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class $InstructorModelCopyWith<$Res>  {
  factory $InstructorModelCopyWith(InstructorModel value, $Res Function(InstructorModel) _then) = _$InstructorModelCopyWithImpl;
@useResult
$Res call({
 int id, String name, String bio,@JsonKey(name: 'image_url') String imageUrl
});




}
/// @nodoc
class _$InstructorModelCopyWithImpl<$Res>
    implements $InstructorModelCopyWith<$Res> {
  _$InstructorModelCopyWithImpl(this._self, this._then);

  final InstructorModel _self;
  final $Res Function(InstructorModel) _then;

/// Create a copy of InstructorModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? bio = null,Object? imageUrl = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,bio: null == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [InstructorModel].
extension InstructorModelPatterns on InstructorModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InstructorModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InstructorModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InstructorModel value)  $default,){
final _that = this;
switch (_that) {
case _InstructorModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InstructorModel value)?  $default,){
final _that = this;
switch (_that) {
case _InstructorModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String bio, @JsonKey(name: 'image_url')  String imageUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InstructorModel() when $default != null:
return $default(_that.id,_that.name,_that.bio,_that.imageUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String bio, @JsonKey(name: 'image_url')  String imageUrl)  $default,) {final _that = this;
switch (_that) {
case _InstructorModel():
return $default(_that.id,_that.name,_that.bio,_that.imageUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String bio, @JsonKey(name: 'image_url')  String imageUrl)?  $default,) {final _that = this;
switch (_that) {
case _InstructorModel() when $default != null:
return $default(_that.id,_that.name,_that.bio,_that.imageUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InstructorModel implements InstructorModel {
  const _InstructorModel({required this.id, required this.name, required this.bio, @JsonKey(name: 'image_url') required this.imageUrl});
  factory _InstructorModel.fromJson(Map<String, dynamic> json) => _$InstructorModelFromJson(json);

@override final  int id;
@override final  String name;
@override final  String bio;
@override@JsonKey(name: 'image_url') final  String imageUrl;

/// Create a copy of InstructorModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InstructorModelCopyWith<_InstructorModel> get copyWith => __$InstructorModelCopyWithImpl<_InstructorModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InstructorModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InstructorModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,bio,imageUrl);

@override
String toString() {
  return 'InstructorModel(id: $id, name: $name, bio: $bio, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class _$InstructorModelCopyWith<$Res> implements $InstructorModelCopyWith<$Res> {
  factory _$InstructorModelCopyWith(_InstructorModel value, $Res Function(_InstructorModel) _then) = __$InstructorModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String bio,@JsonKey(name: 'image_url') String imageUrl
});




}
/// @nodoc
class __$InstructorModelCopyWithImpl<$Res>
    implements _$InstructorModelCopyWith<$Res> {
  __$InstructorModelCopyWithImpl(this._self, this._then);

  final _InstructorModel _self;
  final $Res Function(_InstructorModel) _then;

/// Create a copy of InstructorModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? bio = null,Object? imageUrl = null,}) {
  return _then(_InstructorModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,bio: null == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
