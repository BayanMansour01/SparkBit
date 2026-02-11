// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OrderRequestModel {

@JsonKey(name: 'course_ids') List<int> get courseIds;
/// Create a copy of OrderRequestModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderRequestModelCopyWith<OrderRequestModel> get copyWith => _$OrderRequestModelCopyWithImpl<OrderRequestModel>(this as OrderRequestModel, _$identity);

  /// Serializes this OrderRequestModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderRequestModel&&const DeepCollectionEquality().equals(other.courseIds, courseIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(courseIds));

@override
String toString() {
  return 'OrderRequestModel(courseIds: $courseIds)';
}


}

/// @nodoc
abstract mixin class $OrderRequestModelCopyWith<$Res>  {
  factory $OrderRequestModelCopyWith(OrderRequestModel value, $Res Function(OrderRequestModel) _then) = _$OrderRequestModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'course_ids') List<int> courseIds
});




}
/// @nodoc
class _$OrderRequestModelCopyWithImpl<$Res>
    implements $OrderRequestModelCopyWith<$Res> {
  _$OrderRequestModelCopyWithImpl(this._self, this._then);

  final OrderRequestModel _self;
  final $Res Function(OrderRequestModel) _then;

/// Create a copy of OrderRequestModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? courseIds = null,}) {
  return _then(_self.copyWith(
courseIds: null == courseIds ? _self.courseIds : courseIds // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderRequestModel].
extension OrderRequestModelPatterns on OrderRequestModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderRequestModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderRequestModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderRequestModel value)  $default,){
final _that = this;
switch (_that) {
case _OrderRequestModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderRequestModel value)?  $default,){
final _that = this;
switch (_that) {
case _OrderRequestModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'course_ids')  List<int> courseIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderRequestModel() when $default != null:
return $default(_that.courseIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'course_ids')  List<int> courseIds)  $default,) {final _that = this;
switch (_that) {
case _OrderRequestModel():
return $default(_that.courseIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'course_ids')  List<int> courseIds)?  $default,) {final _that = this;
switch (_that) {
case _OrderRequestModel() when $default != null:
return $default(_that.courseIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrderRequestModel implements OrderRequestModel {
  const _OrderRequestModel({@JsonKey(name: 'course_ids') required final  List<int> courseIds}): _courseIds = courseIds;
  factory _OrderRequestModel.fromJson(Map<String, dynamic> json) => _$OrderRequestModelFromJson(json);

 final  List<int> _courseIds;
@override@JsonKey(name: 'course_ids') List<int> get courseIds {
  if (_courseIds is EqualUnmodifiableListView) return _courseIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_courseIds);
}


/// Create a copy of OrderRequestModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderRequestModelCopyWith<_OrderRequestModel> get copyWith => __$OrderRequestModelCopyWithImpl<_OrderRequestModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderRequestModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderRequestModel&&const DeepCollectionEquality().equals(other._courseIds, _courseIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_courseIds));

@override
String toString() {
  return 'OrderRequestModel(courseIds: $courseIds)';
}


}

/// @nodoc
abstract mixin class _$OrderRequestModelCopyWith<$Res> implements $OrderRequestModelCopyWith<$Res> {
  factory _$OrderRequestModelCopyWith(_OrderRequestModel value, $Res Function(_OrderRequestModel) _then) = __$OrderRequestModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'course_ids') List<int> courseIds
});




}
/// @nodoc
class __$OrderRequestModelCopyWithImpl<$Res>
    implements _$OrderRequestModelCopyWith<$Res> {
  __$OrderRequestModelCopyWithImpl(this._self, this._then);

  final _OrderRequestModel _self;
  final $Res Function(_OrderRequestModel) _then;

/// Create a copy of OrderRequestModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? courseIds = null,}) {
  return _then(_OrderRequestModel(
courseIds: null == courseIds ? _self._courseIds : courseIds // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}


}

// dart format on
