// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OrderResponseModel {

 int get id;@JsonKey(name: 'student_id') int get studentId;@JsonKey(name: 'total_amount') String get totalAmount; String get status;@JsonKey(name: 'payment_method') String? get paymentMethod;@JsonKey(name: 'payment_status') String? get paymentStatus;@JsonKey(name: 'created_at') String get createdAt;@JsonKey(name: 'updated_at') String get updatedAt;
/// Create a copy of OrderResponseModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderResponseModelCopyWith<OrderResponseModel> get copyWith => _$OrderResponseModelCopyWithImpl<OrderResponseModel>(this as OrderResponseModel, _$identity);

  /// Serializes this OrderResponseModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderResponseModel&&(identical(other.id, id) || other.id == id)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.status, status) || other.status == status)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.paymentStatus, paymentStatus) || other.paymentStatus == paymentStatus)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,studentId,totalAmount,status,paymentMethod,paymentStatus,createdAt,updatedAt);

@override
String toString() {
  return 'OrderResponseModel(id: $id, studentId: $studentId, totalAmount: $totalAmount, status: $status, paymentMethod: $paymentMethod, paymentStatus: $paymentStatus, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $OrderResponseModelCopyWith<$Res>  {
  factory $OrderResponseModelCopyWith(OrderResponseModel value, $Res Function(OrderResponseModel) _then) = _$OrderResponseModelCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'student_id') int studentId,@JsonKey(name: 'total_amount') String totalAmount, String status,@JsonKey(name: 'payment_method') String? paymentMethod,@JsonKey(name: 'payment_status') String? paymentStatus,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'updated_at') String updatedAt
});




}
/// @nodoc
class _$OrderResponseModelCopyWithImpl<$Res>
    implements $OrderResponseModelCopyWith<$Res> {
  _$OrderResponseModelCopyWithImpl(this._self, this._then);

  final OrderResponseModel _self;
  final $Res Function(OrderResponseModel) _then;

/// Create a copy of OrderResponseModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? studentId = null,Object? totalAmount = null,Object? status = null,Object? paymentMethod = freezed,Object? paymentStatus = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as int,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,paymentMethod: freezed == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String?,paymentStatus: freezed == paymentStatus ? _self.paymentStatus : paymentStatus // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderResponseModel].
extension OrderResponseModelPatterns on OrderResponseModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderResponseModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderResponseModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderResponseModel value)  $default,){
final _that = this;
switch (_that) {
case _OrderResponseModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderResponseModel value)?  $default,){
final _that = this;
switch (_that) {
case _OrderResponseModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'student_id')  int studentId, @JsonKey(name: 'total_amount')  String totalAmount,  String status, @JsonKey(name: 'payment_method')  String? paymentMethod, @JsonKey(name: 'payment_status')  String? paymentStatus, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderResponseModel() when $default != null:
return $default(_that.id,_that.studentId,_that.totalAmount,_that.status,_that.paymentMethod,_that.paymentStatus,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'student_id')  int studentId, @JsonKey(name: 'total_amount')  String totalAmount,  String status, @JsonKey(name: 'payment_method')  String? paymentMethod, @JsonKey(name: 'payment_status')  String? paymentStatus, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt)  $default,) {final _that = this;
switch (_that) {
case _OrderResponseModel():
return $default(_that.id,_that.studentId,_that.totalAmount,_that.status,_that.paymentMethod,_that.paymentStatus,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'student_id')  int studentId, @JsonKey(name: 'total_amount')  String totalAmount,  String status, @JsonKey(name: 'payment_method')  String? paymentMethod, @JsonKey(name: 'payment_status')  String? paymentStatus, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _OrderResponseModel() when $default != null:
return $default(_that.id,_that.studentId,_that.totalAmount,_that.status,_that.paymentMethod,_that.paymentStatus,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrderResponseModel implements OrderResponseModel {
  const _OrderResponseModel({required this.id, @JsonKey(name: 'student_id') required this.studentId, @JsonKey(name: 'total_amount') required this.totalAmount, required this.status, @JsonKey(name: 'payment_method') this.paymentMethod, @JsonKey(name: 'payment_status') this.paymentStatus, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt});
  factory _OrderResponseModel.fromJson(Map<String, dynamic> json) => _$OrderResponseModelFromJson(json);

@override final  int id;
@override@JsonKey(name: 'student_id') final  int studentId;
@override@JsonKey(name: 'total_amount') final  String totalAmount;
@override final  String status;
@override@JsonKey(name: 'payment_method') final  String? paymentMethod;
@override@JsonKey(name: 'payment_status') final  String? paymentStatus;
@override@JsonKey(name: 'created_at') final  String createdAt;
@override@JsonKey(name: 'updated_at') final  String updatedAt;

/// Create a copy of OrderResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderResponseModelCopyWith<_OrderResponseModel> get copyWith => __$OrderResponseModelCopyWithImpl<_OrderResponseModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderResponseModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderResponseModel&&(identical(other.id, id) || other.id == id)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.status, status) || other.status == status)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.paymentStatus, paymentStatus) || other.paymentStatus == paymentStatus)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,studentId,totalAmount,status,paymentMethod,paymentStatus,createdAt,updatedAt);

@override
String toString() {
  return 'OrderResponseModel(id: $id, studentId: $studentId, totalAmount: $totalAmount, status: $status, paymentMethod: $paymentMethod, paymentStatus: $paymentStatus, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$OrderResponseModelCopyWith<$Res> implements $OrderResponseModelCopyWith<$Res> {
  factory _$OrderResponseModelCopyWith(_OrderResponseModel value, $Res Function(_OrderResponseModel) _then) = __$OrderResponseModelCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'student_id') int studentId,@JsonKey(name: 'total_amount') String totalAmount, String status,@JsonKey(name: 'payment_method') String? paymentMethod,@JsonKey(name: 'payment_status') String? paymentStatus,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'updated_at') String updatedAt
});




}
/// @nodoc
class __$OrderResponseModelCopyWithImpl<$Res>
    implements _$OrderResponseModelCopyWith<$Res> {
  __$OrderResponseModelCopyWithImpl(this._self, this._then);

  final _OrderResponseModel _self;
  final $Res Function(_OrderResponseModel) _then;

/// Create a copy of OrderResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? studentId = null,Object? totalAmount = null,Object? status = null,Object? paymentMethod = freezed,Object? paymentStatus = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_OrderResponseModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as int,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,paymentMethod: freezed == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String?,paymentStatus: freezed == paymentStatus ? _self.paymentStatus : paymentStatus // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
