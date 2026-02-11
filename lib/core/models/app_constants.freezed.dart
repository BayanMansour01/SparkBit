// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_constants.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppConstants {

@JsonKey(name: 'user_roles') List<ConstantValue> get userRoles;@JsonKey(name: 'user_statuses') List<ConstantValue> get userStatuses;@JsonKey(name: 'activity_statuses') List<ConstantValue> get activityStatuses;@JsonKey(name: 'payment_statuses') List<ConstantValue> get paymentStatuses;
/// Create a copy of AppConstants
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppConstantsCopyWith<AppConstants> get copyWith => _$AppConstantsCopyWithImpl<AppConstants>(this as AppConstants, _$identity);

  /// Serializes this AppConstants to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppConstants&&const DeepCollectionEquality().equals(other.userRoles, userRoles)&&const DeepCollectionEquality().equals(other.userStatuses, userStatuses)&&const DeepCollectionEquality().equals(other.activityStatuses, activityStatuses)&&const DeepCollectionEquality().equals(other.paymentStatuses, paymentStatuses));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(userRoles),const DeepCollectionEquality().hash(userStatuses),const DeepCollectionEquality().hash(activityStatuses),const DeepCollectionEquality().hash(paymentStatuses));

@override
String toString() {
  return 'AppConstants(userRoles: $userRoles, userStatuses: $userStatuses, activityStatuses: $activityStatuses, paymentStatuses: $paymentStatuses)';
}


}

/// @nodoc
abstract mixin class $AppConstantsCopyWith<$Res>  {
  factory $AppConstantsCopyWith(AppConstants value, $Res Function(AppConstants) _then) = _$AppConstantsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'user_roles') List<ConstantValue> userRoles,@JsonKey(name: 'user_statuses') List<ConstantValue> userStatuses,@JsonKey(name: 'activity_statuses') List<ConstantValue> activityStatuses,@JsonKey(name: 'payment_statuses') List<ConstantValue> paymentStatuses
});




}
/// @nodoc
class _$AppConstantsCopyWithImpl<$Res>
    implements $AppConstantsCopyWith<$Res> {
  _$AppConstantsCopyWithImpl(this._self, this._then);

  final AppConstants _self;
  final $Res Function(AppConstants) _then;

/// Create a copy of AppConstants
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userRoles = null,Object? userStatuses = null,Object? activityStatuses = null,Object? paymentStatuses = null,}) {
  return _then(_self.copyWith(
userRoles: null == userRoles ? _self.userRoles : userRoles // ignore: cast_nullable_to_non_nullable
as List<ConstantValue>,userStatuses: null == userStatuses ? _self.userStatuses : userStatuses // ignore: cast_nullable_to_non_nullable
as List<ConstantValue>,activityStatuses: null == activityStatuses ? _self.activityStatuses : activityStatuses // ignore: cast_nullable_to_non_nullable
as List<ConstantValue>,paymentStatuses: null == paymentStatuses ? _self.paymentStatuses : paymentStatuses // ignore: cast_nullable_to_non_nullable
as List<ConstantValue>,
  ));
}

}


/// Adds pattern-matching-related methods to [AppConstants].
extension AppConstantsPatterns on AppConstants {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppConstants value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppConstants() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppConstants value)  $default,){
final _that = this;
switch (_that) {
case _AppConstants():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppConstants value)?  $default,){
final _that = this;
switch (_that) {
case _AppConstants() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'user_roles')  List<ConstantValue> userRoles, @JsonKey(name: 'user_statuses')  List<ConstantValue> userStatuses, @JsonKey(name: 'activity_statuses')  List<ConstantValue> activityStatuses, @JsonKey(name: 'payment_statuses')  List<ConstantValue> paymentStatuses)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppConstants() when $default != null:
return $default(_that.userRoles,_that.userStatuses,_that.activityStatuses,_that.paymentStatuses);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'user_roles')  List<ConstantValue> userRoles, @JsonKey(name: 'user_statuses')  List<ConstantValue> userStatuses, @JsonKey(name: 'activity_statuses')  List<ConstantValue> activityStatuses, @JsonKey(name: 'payment_statuses')  List<ConstantValue> paymentStatuses)  $default,) {final _that = this;
switch (_that) {
case _AppConstants():
return $default(_that.userRoles,_that.userStatuses,_that.activityStatuses,_that.paymentStatuses);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'user_roles')  List<ConstantValue> userRoles, @JsonKey(name: 'user_statuses')  List<ConstantValue> userStatuses, @JsonKey(name: 'activity_statuses')  List<ConstantValue> activityStatuses, @JsonKey(name: 'payment_statuses')  List<ConstantValue> paymentStatuses)?  $default,) {final _that = this;
switch (_that) {
case _AppConstants() when $default != null:
return $default(_that.userRoles,_that.userStatuses,_that.activityStatuses,_that.paymentStatuses);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppConstants implements AppConstants {
  const _AppConstants({@JsonKey(name: 'user_roles') required final  List<ConstantValue> userRoles, @JsonKey(name: 'user_statuses') required final  List<ConstantValue> userStatuses, @JsonKey(name: 'activity_statuses') required final  List<ConstantValue> activityStatuses, @JsonKey(name: 'payment_statuses') required final  List<ConstantValue> paymentStatuses}): _userRoles = userRoles,_userStatuses = userStatuses,_activityStatuses = activityStatuses,_paymentStatuses = paymentStatuses;
  factory _AppConstants.fromJson(Map<String, dynamic> json) => _$AppConstantsFromJson(json);

 final  List<ConstantValue> _userRoles;
@override@JsonKey(name: 'user_roles') List<ConstantValue> get userRoles {
  if (_userRoles is EqualUnmodifiableListView) return _userRoles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_userRoles);
}

 final  List<ConstantValue> _userStatuses;
@override@JsonKey(name: 'user_statuses') List<ConstantValue> get userStatuses {
  if (_userStatuses is EqualUnmodifiableListView) return _userStatuses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_userStatuses);
}

 final  List<ConstantValue> _activityStatuses;
@override@JsonKey(name: 'activity_statuses') List<ConstantValue> get activityStatuses {
  if (_activityStatuses is EqualUnmodifiableListView) return _activityStatuses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_activityStatuses);
}

 final  List<ConstantValue> _paymentStatuses;
@override@JsonKey(name: 'payment_statuses') List<ConstantValue> get paymentStatuses {
  if (_paymentStatuses is EqualUnmodifiableListView) return _paymentStatuses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_paymentStatuses);
}


/// Create a copy of AppConstants
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppConstantsCopyWith<_AppConstants> get copyWith => __$AppConstantsCopyWithImpl<_AppConstants>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppConstantsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppConstants&&const DeepCollectionEquality().equals(other._userRoles, _userRoles)&&const DeepCollectionEquality().equals(other._userStatuses, _userStatuses)&&const DeepCollectionEquality().equals(other._activityStatuses, _activityStatuses)&&const DeepCollectionEquality().equals(other._paymentStatuses, _paymentStatuses));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_userRoles),const DeepCollectionEquality().hash(_userStatuses),const DeepCollectionEquality().hash(_activityStatuses),const DeepCollectionEquality().hash(_paymentStatuses));

@override
String toString() {
  return 'AppConstants(userRoles: $userRoles, userStatuses: $userStatuses, activityStatuses: $activityStatuses, paymentStatuses: $paymentStatuses)';
}


}

/// @nodoc
abstract mixin class _$AppConstantsCopyWith<$Res> implements $AppConstantsCopyWith<$Res> {
  factory _$AppConstantsCopyWith(_AppConstants value, $Res Function(_AppConstants) _then) = __$AppConstantsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'user_roles') List<ConstantValue> userRoles,@JsonKey(name: 'user_statuses') List<ConstantValue> userStatuses,@JsonKey(name: 'activity_statuses') List<ConstantValue> activityStatuses,@JsonKey(name: 'payment_statuses') List<ConstantValue> paymentStatuses
});




}
/// @nodoc
class __$AppConstantsCopyWithImpl<$Res>
    implements _$AppConstantsCopyWith<$Res> {
  __$AppConstantsCopyWithImpl(this._self, this._then);

  final _AppConstants _self;
  final $Res Function(_AppConstants) _then;

/// Create a copy of AppConstants
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userRoles = null,Object? userStatuses = null,Object? activityStatuses = null,Object? paymentStatuses = null,}) {
  return _then(_AppConstants(
userRoles: null == userRoles ? _self._userRoles : userRoles // ignore: cast_nullable_to_non_nullable
as List<ConstantValue>,userStatuses: null == userStatuses ? _self._userStatuses : userStatuses // ignore: cast_nullable_to_non_nullable
as List<ConstantValue>,activityStatuses: null == activityStatuses ? _self._activityStatuses : activityStatuses // ignore: cast_nullable_to_non_nullable
as List<ConstantValue>,paymentStatuses: null == paymentStatuses ? _self._paymentStatuses : paymentStatuses // ignore: cast_nullable_to_non_nullable
as List<ConstantValue>,
  ));
}


}

// dart format on
