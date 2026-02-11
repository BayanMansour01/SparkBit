// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_device.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserDevice {

 int? get id;@JsonKey(name: 'fcm_token') String get fcmToken;@JsonKey(name: 'device_type') String get deviceType;@JsonKey(name: 'device_info') String get deviceInfo;@JsonKey(name: 'created_at') String? get createdAt;@JsonKey(name: 'updated_at') String? get updatedAt;
/// Create a copy of UserDevice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserDeviceCopyWith<UserDevice> get copyWith => _$UserDeviceCopyWithImpl<UserDevice>(this as UserDevice, _$identity);

  /// Serializes this UserDevice to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserDevice&&(identical(other.id, id) || other.id == id)&&(identical(other.fcmToken, fcmToken) || other.fcmToken == fcmToken)&&(identical(other.deviceType, deviceType) || other.deviceType == deviceType)&&(identical(other.deviceInfo, deviceInfo) || other.deviceInfo == deviceInfo)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fcmToken,deviceType,deviceInfo,createdAt,updatedAt);

@override
String toString() {
  return 'UserDevice(id: $id, fcmToken: $fcmToken, deviceType: $deviceType, deviceInfo: $deviceInfo, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $UserDeviceCopyWith<$Res>  {
  factory $UserDeviceCopyWith(UserDevice value, $Res Function(UserDevice) _then) = _$UserDeviceCopyWithImpl;
@useResult
$Res call({
 int? id,@JsonKey(name: 'fcm_token') String fcmToken,@JsonKey(name: 'device_type') String deviceType,@JsonKey(name: 'device_info') String deviceInfo,@JsonKey(name: 'created_at') String? createdAt,@JsonKey(name: 'updated_at') String? updatedAt
});




}
/// @nodoc
class _$UserDeviceCopyWithImpl<$Res>
    implements $UserDeviceCopyWith<$Res> {
  _$UserDeviceCopyWithImpl(this._self, this._then);

  final UserDevice _self;
  final $Res Function(UserDevice) _then;

/// Create a copy of UserDevice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? fcmToken = null,Object? deviceType = null,Object? deviceInfo = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,fcmToken: null == fcmToken ? _self.fcmToken : fcmToken // ignore: cast_nullable_to_non_nullable
as String,deviceType: null == deviceType ? _self.deviceType : deviceType // ignore: cast_nullable_to_non_nullable
as String,deviceInfo: null == deviceInfo ? _self.deviceInfo : deviceInfo // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserDevice].
extension UserDevicePatterns on UserDevice {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserDevice value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserDevice() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserDevice value)  $default,){
final _that = this;
switch (_that) {
case _UserDevice():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserDevice value)?  $default,){
final _that = this;
switch (_that) {
case _UserDevice() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id, @JsonKey(name: 'fcm_token')  String fcmToken, @JsonKey(name: 'device_type')  String deviceType, @JsonKey(name: 'device_info')  String deviceInfo, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserDevice() when $default != null:
return $default(_that.id,_that.fcmToken,_that.deviceType,_that.deviceInfo,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id, @JsonKey(name: 'fcm_token')  String fcmToken, @JsonKey(name: 'device_type')  String deviceType, @JsonKey(name: 'device_info')  String deviceInfo, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _UserDevice():
return $default(_that.id,_that.fcmToken,_that.deviceType,_that.deviceInfo,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id, @JsonKey(name: 'fcm_token')  String fcmToken, @JsonKey(name: 'device_type')  String deviceType, @JsonKey(name: 'device_info')  String deviceInfo, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _UserDevice() when $default != null:
return $default(_that.id,_that.fcmToken,_that.deviceType,_that.deviceInfo,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserDevice implements UserDevice {
  const _UserDevice({this.id, @JsonKey(name: 'fcm_token') required this.fcmToken, @JsonKey(name: 'device_type') required this.deviceType, @JsonKey(name: 'device_info') required this.deviceInfo, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt});
  factory _UserDevice.fromJson(Map<String, dynamic> json) => _$UserDeviceFromJson(json);

@override final  int? id;
@override@JsonKey(name: 'fcm_token') final  String fcmToken;
@override@JsonKey(name: 'device_type') final  String deviceType;
@override@JsonKey(name: 'device_info') final  String deviceInfo;
@override@JsonKey(name: 'created_at') final  String? createdAt;
@override@JsonKey(name: 'updated_at') final  String? updatedAt;

/// Create a copy of UserDevice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserDeviceCopyWith<_UserDevice> get copyWith => __$UserDeviceCopyWithImpl<_UserDevice>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserDeviceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserDevice&&(identical(other.id, id) || other.id == id)&&(identical(other.fcmToken, fcmToken) || other.fcmToken == fcmToken)&&(identical(other.deviceType, deviceType) || other.deviceType == deviceType)&&(identical(other.deviceInfo, deviceInfo) || other.deviceInfo == deviceInfo)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fcmToken,deviceType,deviceInfo,createdAt,updatedAt);

@override
String toString() {
  return 'UserDevice(id: $id, fcmToken: $fcmToken, deviceType: $deviceType, deviceInfo: $deviceInfo, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$UserDeviceCopyWith<$Res> implements $UserDeviceCopyWith<$Res> {
  factory _$UserDeviceCopyWith(_UserDevice value, $Res Function(_UserDevice) _then) = __$UserDeviceCopyWithImpl;
@override @useResult
$Res call({
 int? id,@JsonKey(name: 'fcm_token') String fcmToken,@JsonKey(name: 'device_type') String deviceType,@JsonKey(name: 'device_info') String deviceInfo,@JsonKey(name: 'created_at') String? createdAt,@JsonKey(name: 'updated_at') String? updatedAt
});




}
/// @nodoc
class __$UserDeviceCopyWithImpl<$Res>
    implements _$UserDeviceCopyWith<$Res> {
  __$UserDeviceCopyWithImpl(this._self, this._then);

  final _UserDevice _self;
  final $Res Function(_UserDevice) _then;

/// Create a copy of UserDevice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? fcmToken = null,Object? deviceType = null,Object? deviceInfo = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_UserDevice(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,fcmToken: null == fcmToken ? _self.fcmToken : fcmToken // ignore: cast_nullable_to_non_nullable
as String,deviceType: null == deviceType ? _self.deviceType : deviceType // ignore: cast_nullable_to_non_nullable
as String,deviceInfo: null == deviceInfo ? _self.deviceInfo : deviceInfo // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
