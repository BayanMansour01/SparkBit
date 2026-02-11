// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'data_wrapper.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DataWrapper<T> {

 T get data;
/// Create a copy of DataWrapper
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DataWrapperCopyWith<T, DataWrapper<T>> get copyWith => _$DataWrapperCopyWithImpl<T, DataWrapper<T>>(this as DataWrapper<T>, _$identity);

  /// Serializes this DataWrapper to a JSON map.
  Map<String, dynamic> toJson(Object? Function(T) toJsonT);


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DataWrapper<T>&&const DeepCollectionEquality().equals(other.data, data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'DataWrapper<$T>(data: $data)';
}


}

/// @nodoc
abstract mixin class $DataWrapperCopyWith<T,$Res>  {
  factory $DataWrapperCopyWith(DataWrapper<T> value, $Res Function(DataWrapper<T>) _then) = _$DataWrapperCopyWithImpl;
@useResult
$Res call({
 T data
});




}
/// @nodoc
class _$DataWrapperCopyWithImpl<T,$Res>
    implements $DataWrapperCopyWith<T, $Res> {
  _$DataWrapperCopyWithImpl(this._self, this._then);

  final DataWrapper<T> _self;
  final $Res Function(DataWrapper<T>) _then;

/// Create a copy of DataWrapper
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = freezed,}) {
  return _then(_self.copyWith(
data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as T,
  ));
}

}


/// Adds pattern-matching-related methods to [DataWrapper].
extension DataWrapperPatterns<T> on DataWrapper<T> {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DataWrapper<T> value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DataWrapper() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DataWrapper<T> value)  $default,){
final _that = this;
switch (_that) {
case _DataWrapper():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DataWrapper<T> value)?  $default,){
final _that = this;
switch (_that) {
case _DataWrapper() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( T data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DataWrapper() when $default != null:
return $default(_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( T data)  $default,) {final _that = this;
switch (_that) {
case _DataWrapper():
return $default(_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( T data)?  $default,) {final _that = this;
switch (_that) {
case _DataWrapper() when $default != null:
return $default(_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(genericArgumentFactories: true)

class _DataWrapper<T> implements DataWrapper<T> {
  const _DataWrapper({required this.data});
  factory _DataWrapper.fromJson(Map<String, dynamic> json,T Function(Object?) fromJsonT) => _$DataWrapperFromJson(json,fromJsonT);

@override final  T data;

/// Create a copy of DataWrapper
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DataWrapperCopyWith<T, _DataWrapper<T>> get copyWith => __$DataWrapperCopyWithImpl<T, _DataWrapper<T>>(this, _$identity);

@override
Map<String, dynamic> toJson(Object? Function(T) toJsonT) {
  return _$DataWrapperToJson<T>(this, toJsonT);
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DataWrapper<T>&&const DeepCollectionEquality().equals(other.data, data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'DataWrapper<$T>(data: $data)';
}


}

/// @nodoc
abstract mixin class _$DataWrapperCopyWith<T,$Res> implements $DataWrapperCopyWith<T, $Res> {
  factory _$DataWrapperCopyWith(_DataWrapper<T> value, $Res Function(_DataWrapper<T>) _then) = __$DataWrapperCopyWithImpl;
@override @useResult
$Res call({
 T data
});




}
/// @nodoc
class __$DataWrapperCopyWithImpl<T,$Res>
    implements _$DataWrapperCopyWith<T, $Res> {
  __$DataWrapperCopyWithImpl(this._self, this._then);

  final _DataWrapper<T> _self;
  final $Res Function(_DataWrapper<T>) _then;

/// Create a copy of DataWrapper
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = freezed,}) {
  return _then(_DataWrapper<T>(
data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as T,
  ));
}


}

// dart format on
