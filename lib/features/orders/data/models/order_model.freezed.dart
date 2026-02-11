// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OrderModel {

 int get id; ConstantValue get status;@JsonKey(name: 'total_price') num get totalPrice;@JsonKey(name: 'payment_proof') String? get paymentProof;@JsonKey(name: 'rejected_reason') String? get rejectedReason; List<OrderItemModel> get items;@JsonKey(name: 'approved_at') String? get approvedAt;@JsonKey(name: 'rejected_at') String? get rejectedAt;
/// Create a copy of OrderModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderModelCopyWith<OrderModel> get copyWith => _$OrderModelCopyWithImpl<OrderModel>(this as OrderModel, _$identity);

  /// Serializes this OrderModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderModel&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.totalPrice, totalPrice) || other.totalPrice == totalPrice)&&(identical(other.paymentProof, paymentProof) || other.paymentProof == paymentProof)&&(identical(other.rejectedReason, rejectedReason) || other.rejectedReason == rejectedReason)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.approvedAt, approvedAt) || other.approvedAt == approvedAt)&&(identical(other.rejectedAt, rejectedAt) || other.rejectedAt == rejectedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,status,totalPrice,paymentProof,rejectedReason,const DeepCollectionEquality().hash(items),approvedAt,rejectedAt);

@override
String toString() {
  return 'OrderModel(id: $id, status: $status, totalPrice: $totalPrice, paymentProof: $paymentProof, rejectedReason: $rejectedReason, items: $items, approvedAt: $approvedAt, rejectedAt: $rejectedAt)';
}


}

/// @nodoc
abstract mixin class $OrderModelCopyWith<$Res>  {
  factory $OrderModelCopyWith(OrderModel value, $Res Function(OrderModel) _then) = _$OrderModelCopyWithImpl;
@useResult
$Res call({
 int id, ConstantValue status,@JsonKey(name: 'total_price') num totalPrice,@JsonKey(name: 'payment_proof') String? paymentProof,@JsonKey(name: 'rejected_reason') String? rejectedReason, List<OrderItemModel> items,@JsonKey(name: 'approved_at') String? approvedAt,@JsonKey(name: 'rejected_at') String? rejectedAt
});


$ConstantValueCopyWith<$Res> get status;

}
/// @nodoc
class _$OrderModelCopyWithImpl<$Res>
    implements $OrderModelCopyWith<$Res> {
  _$OrderModelCopyWithImpl(this._self, this._then);

  final OrderModel _self;
  final $Res Function(OrderModel) _then;

/// Create a copy of OrderModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? status = null,Object? totalPrice = null,Object? paymentProof = freezed,Object? rejectedReason = freezed,Object? items = null,Object? approvedAt = freezed,Object? rejectedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ConstantValue,totalPrice: null == totalPrice ? _self.totalPrice : totalPrice // ignore: cast_nullable_to_non_nullable
as num,paymentProof: freezed == paymentProof ? _self.paymentProof : paymentProof // ignore: cast_nullable_to_non_nullable
as String?,rejectedReason: freezed == rejectedReason ? _self.rejectedReason : rejectedReason // ignore: cast_nullable_to_non_nullable
as String?,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<OrderItemModel>,approvedAt: freezed == approvedAt ? _self.approvedAt : approvedAt // ignore: cast_nullable_to_non_nullable
as String?,rejectedAt: freezed == rejectedAt ? _self.rejectedAt : rejectedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of OrderModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ConstantValueCopyWith<$Res> get status {
  
  return $ConstantValueCopyWith<$Res>(_self.status, (value) {
    return _then(_self.copyWith(status: value));
  });
}
}


/// Adds pattern-matching-related methods to [OrderModel].
extension OrderModelPatterns on OrderModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderModel value)  $default,){
final _that = this;
switch (_that) {
case _OrderModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderModel value)?  $default,){
final _that = this;
switch (_that) {
case _OrderModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  ConstantValue status, @JsonKey(name: 'total_price')  num totalPrice, @JsonKey(name: 'payment_proof')  String? paymentProof, @JsonKey(name: 'rejected_reason')  String? rejectedReason,  List<OrderItemModel> items, @JsonKey(name: 'approved_at')  String? approvedAt, @JsonKey(name: 'rejected_at')  String? rejectedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderModel() when $default != null:
return $default(_that.id,_that.status,_that.totalPrice,_that.paymentProof,_that.rejectedReason,_that.items,_that.approvedAt,_that.rejectedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  ConstantValue status, @JsonKey(name: 'total_price')  num totalPrice, @JsonKey(name: 'payment_proof')  String? paymentProof, @JsonKey(name: 'rejected_reason')  String? rejectedReason,  List<OrderItemModel> items, @JsonKey(name: 'approved_at')  String? approvedAt, @JsonKey(name: 'rejected_at')  String? rejectedAt)  $default,) {final _that = this;
switch (_that) {
case _OrderModel():
return $default(_that.id,_that.status,_that.totalPrice,_that.paymentProof,_that.rejectedReason,_that.items,_that.approvedAt,_that.rejectedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  ConstantValue status, @JsonKey(name: 'total_price')  num totalPrice, @JsonKey(name: 'payment_proof')  String? paymentProof, @JsonKey(name: 'rejected_reason')  String? rejectedReason,  List<OrderItemModel> items, @JsonKey(name: 'approved_at')  String? approvedAt, @JsonKey(name: 'rejected_at')  String? rejectedAt)?  $default,) {final _that = this;
switch (_that) {
case _OrderModel() when $default != null:
return $default(_that.id,_that.status,_that.totalPrice,_that.paymentProof,_that.rejectedReason,_that.items,_that.approvedAt,_that.rejectedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrderModel implements OrderModel {
  const _OrderModel({required this.id, required this.status, @JsonKey(name: 'total_price') required this.totalPrice, @JsonKey(name: 'payment_proof') this.paymentProof, @JsonKey(name: 'rejected_reason') this.rejectedReason, required final  List<OrderItemModel> items, @JsonKey(name: 'approved_at') this.approvedAt, @JsonKey(name: 'rejected_at') this.rejectedAt}): _items = items;
  factory _OrderModel.fromJson(Map<String, dynamic> json) => _$OrderModelFromJson(json);

@override final  int id;
@override final  ConstantValue status;
@override@JsonKey(name: 'total_price') final  num totalPrice;
@override@JsonKey(name: 'payment_proof') final  String? paymentProof;
@override@JsonKey(name: 'rejected_reason') final  String? rejectedReason;
 final  List<OrderItemModel> _items;
@override List<OrderItemModel> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey(name: 'approved_at') final  String? approvedAt;
@override@JsonKey(name: 'rejected_at') final  String? rejectedAt;

/// Create a copy of OrderModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderModelCopyWith<_OrderModel> get copyWith => __$OrderModelCopyWithImpl<_OrderModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderModel&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.totalPrice, totalPrice) || other.totalPrice == totalPrice)&&(identical(other.paymentProof, paymentProof) || other.paymentProof == paymentProof)&&(identical(other.rejectedReason, rejectedReason) || other.rejectedReason == rejectedReason)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.approvedAt, approvedAt) || other.approvedAt == approvedAt)&&(identical(other.rejectedAt, rejectedAt) || other.rejectedAt == rejectedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,status,totalPrice,paymentProof,rejectedReason,const DeepCollectionEquality().hash(_items),approvedAt,rejectedAt);

@override
String toString() {
  return 'OrderModel(id: $id, status: $status, totalPrice: $totalPrice, paymentProof: $paymentProof, rejectedReason: $rejectedReason, items: $items, approvedAt: $approvedAt, rejectedAt: $rejectedAt)';
}


}

/// @nodoc
abstract mixin class _$OrderModelCopyWith<$Res> implements $OrderModelCopyWith<$Res> {
  factory _$OrderModelCopyWith(_OrderModel value, $Res Function(_OrderModel) _then) = __$OrderModelCopyWithImpl;
@override @useResult
$Res call({
 int id, ConstantValue status,@JsonKey(name: 'total_price') num totalPrice,@JsonKey(name: 'payment_proof') String? paymentProof,@JsonKey(name: 'rejected_reason') String? rejectedReason, List<OrderItemModel> items,@JsonKey(name: 'approved_at') String? approvedAt,@JsonKey(name: 'rejected_at') String? rejectedAt
});


@override $ConstantValueCopyWith<$Res> get status;

}
/// @nodoc
class __$OrderModelCopyWithImpl<$Res>
    implements _$OrderModelCopyWith<$Res> {
  __$OrderModelCopyWithImpl(this._self, this._then);

  final _OrderModel _self;
  final $Res Function(_OrderModel) _then;

/// Create a copy of OrderModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? status = null,Object? totalPrice = null,Object? paymentProof = freezed,Object? rejectedReason = freezed,Object? items = null,Object? approvedAt = freezed,Object? rejectedAt = freezed,}) {
  return _then(_OrderModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ConstantValue,totalPrice: null == totalPrice ? _self.totalPrice : totalPrice // ignore: cast_nullable_to_non_nullable
as num,paymentProof: freezed == paymentProof ? _self.paymentProof : paymentProof // ignore: cast_nullable_to_non_nullable
as String?,rejectedReason: freezed == rejectedReason ? _self.rejectedReason : rejectedReason // ignore: cast_nullable_to_non_nullable
as String?,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<OrderItemModel>,approvedAt: freezed == approvedAt ? _self.approvedAt : approvedAt // ignore: cast_nullable_to_non_nullable
as String?,rejectedAt: freezed == rejectedAt ? _self.rejectedAt : rejectedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of OrderModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ConstantValueCopyWith<$Res> get status {
  
  return $ConstantValueCopyWith<$Res>(_self.status, (value) {
    return _then(_self.copyWith(status: value));
  });
}
}


/// @nodoc
mixin _$OrderItemModel {

 int get id; OrderCourseModel get course; num get price;
/// Create a copy of OrderItemModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderItemModelCopyWith<OrderItemModel> get copyWith => _$OrderItemModelCopyWithImpl<OrderItemModel>(this as OrderItemModel, _$identity);

  /// Serializes this OrderItemModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderItemModel&&(identical(other.id, id) || other.id == id)&&(identical(other.course, course) || other.course == course)&&(identical(other.price, price) || other.price == price));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,course,price);

@override
String toString() {
  return 'OrderItemModel(id: $id, course: $course, price: $price)';
}


}

/// @nodoc
abstract mixin class $OrderItemModelCopyWith<$Res>  {
  factory $OrderItemModelCopyWith(OrderItemModel value, $Res Function(OrderItemModel) _then) = _$OrderItemModelCopyWithImpl;
@useResult
$Res call({
 int id, OrderCourseModel course, num price
});


$OrderCourseModelCopyWith<$Res> get course;

}
/// @nodoc
class _$OrderItemModelCopyWithImpl<$Res>
    implements $OrderItemModelCopyWith<$Res> {
  _$OrderItemModelCopyWithImpl(this._self, this._then);

  final OrderItemModel _self;
  final $Res Function(OrderItemModel) _then;

/// Create a copy of OrderItemModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? course = null,Object? price = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,course: null == course ? _self.course : course // ignore: cast_nullable_to_non_nullable
as OrderCourseModel,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as num,
  ));
}
/// Create a copy of OrderItemModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderCourseModelCopyWith<$Res> get course {
  
  return $OrderCourseModelCopyWith<$Res>(_self.course, (value) {
    return _then(_self.copyWith(course: value));
  });
}
}


/// Adds pattern-matching-related methods to [OrderItemModel].
extension OrderItemModelPatterns on OrderItemModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderItemModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderItemModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderItemModel value)  $default,){
final _that = this;
switch (_that) {
case _OrderItemModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderItemModel value)?  $default,){
final _that = this;
switch (_that) {
case _OrderItemModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  OrderCourseModel course,  num price)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderItemModel() when $default != null:
return $default(_that.id,_that.course,_that.price);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  OrderCourseModel course,  num price)  $default,) {final _that = this;
switch (_that) {
case _OrderItemModel():
return $default(_that.id,_that.course,_that.price);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  OrderCourseModel course,  num price)?  $default,) {final _that = this;
switch (_that) {
case _OrderItemModel() when $default != null:
return $default(_that.id,_that.course,_that.price);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrderItemModel implements OrderItemModel {
  const _OrderItemModel({required this.id, required this.course, required this.price});
  factory _OrderItemModel.fromJson(Map<String, dynamic> json) => _$OrderItemModelFromJson(json);

@override final  int id;
@override final  OrderCourseModel course;
@override final  num price;

/// Create a copy of OrderItemModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderItemModelCopyWith<_OrderItemModel> get copyWith => __$OrderItemModelCopyWithImpl<_OrderItemModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderItemModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderItemModel&&(identical(other.id, id) || other.id == id)&&(identical(other.course, course) || other.course == course)&&(identical(other.price, price) || other.price == price));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,course,price);

@override
String toString() {
  return 'OrderItemModel(id: $id, course: $course, price: $price)';
}


}

/// @nodoc
abstract mixin class _$OrderItemModelCopyWith<$Res> implements $OrderItemModelCopyWith<$Res> {
  factory _$OrderItemModelCopyWith(_OrderItemModel value, $Res Function(_OrderItemModel) _then) = __$OrderItemModelCopyWithImpl;
@override @useResult
$Res call({
 int id, OrderCourseModel course, num price
});


@override $OrderCourseModelCopyWith<$Res> get course;

}
/// @nodoc
class __$OrderItemModelCopyWithImpl<$Res>
    implements _$OrderItemModelCopyWith<$Res> {
  __$OrderItemModelCopyWithImpl(this._self, this._then);

  final _OrderItemModel _self;
  final $Res Function(_OrderItemModel) _then;

/// Create a copy of OrderItemModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? course = null,Object? price = null,}) {
  return _then(_OrderItemModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,course: null == course ? _self.course : course // ignore: cast_nullable_to_non_nullable
as OrderCourseModel,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as num,
  ));
}

/// Create a copy of OrderItemModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderCourseModelCopyWith<$Res> get course {
  
  return $OrderCourseModelCopyWith<$Res>(_self.course, (value) {
    return _then(_self.copyWith(course: value));
  });
}
}


/// @nodoc
mixin _$OrderCourseModel {

 int get id; String get title; String get image; OrderInstructorModel get instructor;
/// Create a copy of OrderCourseModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderCourseModelCopyWith<OrderCourseModel> get copyWith => _$OrderCourseModelCopyWithImpl<OrderCourseModel>(this as OrderCourseModel, _$identity);

  /// Serializes this OrderCourseModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderCourseModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.image, image) || other.image == image)&&(identical(other.instructor, instructor) || other.instructor == instructor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,image,instructor);

@override
String toString() {
  return 'OrderCourseModel(id: $id, title: $title, image: $image, instructor: $instructor)';
}


}

/// @nodoc
abstract mixin class $OrderCourseModelCopyWith<$Res>  {
  factory $OrderCourseModelCopyWith(OrderCourseModel value, $Res Function(OrderCourseModel) _then) = _$OrderCourseModelCopyWithImpl;
@useResult
$Res call({
 int id, String title, String image, OrderInstructorModel instructor
});


$OrderInstructorModelCopyWith<$Res> get instructor;

}
/// @nodoc
class _$OrderCourseModelCopyWithImpl<$Res>
    implements $OrderCourseModelCopyWith<$Res> {
  _$OrderCourseModelCopyWithImpl(this._self, this._then);

  final OrderCourseModel _self;
  final $Res Function(OrderCourseModel) _then;

/// Create a copy of OrderCourseModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? image = null,Object? instructor = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String,instructor: null == instructor ? _self.instructor : instructor // ignore: cast_nullable_to_non_nullable
as OrderInstructorModel,
  ));
}
/// Create a copy of OrderCourseModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderInstructorModelCopyWith<$Res> get instructor {
  
  return $OrderInstructorModelCopyWith<$Res>(_self.instructor, (value) {
    return _then(_self.copyWith(instructor: value));
  });
}
}


/// Adds pattern-matching-related methods to [OrderCourseModel].
extension OrderCourseModelPatterns on OrderCourseModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderCourseModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderCourseModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderCourseModel value)  $default,){
final _that = this;
switch (_that) {
case _OrderCourseModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderCourseModel value)?  $default,){
final _that = this;
switch (_that) {
case _OrderCourseModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  String image,  OrderInstructorModel instructor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderCourseModel() when $default != null:
return $default(_that.id,_that.title,_that.image,_that.instructor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  String image,  OrderInstructorModel instructor)  $default,) {final _that = this;
switch (_that) {
case _OrderCourseModel():
return $default(_that.id,_that.title,_that.image,_that.instructor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  String image,  OrderInstructorModel instructor)?  $default,) {final _that = this;
switch (_that) {
case _OrderCourseModel() when $default != null:
return $default(_that.id,_that.title,_that.image,_that.instructor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrderCourseModel implements OrderCourseModel {
  const _OrderCourseModel({required this.id, required this.title, required this.image, required this.instructor});
  factory _OrderCourseModel.fromJson(Map<String, dynamic> json) => _$OrderCourseModelFromJson(json);

@override final  int id;
@override final  String title;
@override final  String image;
@override final  OrderInstructorModel instructor;

/// Create a copy of OrderCourseModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderCourseModelCopyWith<_OrderCourseModel> get copyWith => __$OrderCourseModelCopyWithImpl<_OrderCourseModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderCourseModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderCourseModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.image, image) || other.image == image)&&(identical(other.instructor, instructor) || other.instructor == instructor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,image,instructor);

@override
String toString() {
  return 'OrderCourseModel(id: $id, title: $title, image: $image, instructor: $instructor)';
}


}

/// @nodoc
abstract mixin class _$OrderCourseModelCopyWith<$Res> implements $OrderCourseModelCopyWith<$Res> {
  factory _$OrderCourseModelCopyWith(_OrderCourseModel value, $Res Function(_OrderCourseModel) _then) = __$OrderCourseModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, String image, OrderInstructorModel instructor
});


@override $OrderInstructorModelCopyWith<$Res> get instructor;

}
/// @nodoc
class __$OrderCourseModelCopyWithImpl<$Res>
    implements _$OrderCourseModelCopyWith<$Res> {
  __$OrderCourseModelCopyWithImpl(this._self, this._then);

  final _OrderCourseModel _self;
  final $Res Function(_OrderCourseModel) _then;

/// Create a copy of OrderCourseModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? image = null,Object? instructor = null,}) {
  return _then(_OrderCourseModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String,instructor: null == instructor ? _self.instructor : instructor // ignore: cast_nullable_to_non_nullable
as OrderInstructorModel,
  ));
}

/// Create a copy of OrderCourseModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderInstructorModelCopyWith<$Res> get instructor {
  
  return $OrderInstructorModelCopyWith<$Res>(_self.instructor, (value) {
    return _then(_self.copyWith(instructor: value));
  });
}
}


/// @nodoc
mixin _$OrderInstructorModel {

 int get id; String get name;
/// Create a copy of OrderInstructorModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderInstructorModelCopyWith<OrderInstructorModel> get copyWith => _$OrderInstructorModelCopyWithImpl<OrderInstructorModel>(this as OrderInstructorModel, _$identity);

  /// Serializes this OrderInstructorModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderInstructorModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'OrderInstructorModel(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class $OrderInstructorModelCopyWith<$Res>  {
  factory $OrderInstructorModelCopyWith(OrderInstructorModel value, $Res Function(OrderInstructorModel) _then) = _$OrderInstructorModelCopyWithImpl;
@useResult
$Res call({
 int id, String name
});




}
/// @nodoc
class _$OrderInstructorModelCopyWithImpl<$Res>
    implements $OrderInstructorModelCopyWith<$Res> {
  _$OrderInstructorModelCopyWithImpl(this._self, this._then);

  final OrderInstructorModel _self;
  final $Res Function(OrderInstructorModel) _then;

/// Create a copy of OrderInstructorModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderInstructorModel].
extension OrderInstructorModelPatterns on OrderInstructorModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderInstructorModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderInstructorModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderInstructorModel value)  $default,){
final _that = this;
switch (_that) {
case _OrderInstructorModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderInstructorModel value)?  $default,){
final _that = this;
switch (_that) {
case _OrderInstructorModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderInstructorModel() when $default != null:
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name)  $default,) {final _that = this;
switch (_that) {
case _OrderInstructorModel():
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name)?  $default,) {final _that = this;
switch (_that) {
case _OrderInstructorModel() when $default != null:
return $default(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrderInstructorModel implements OrderInstructorModel {
  const _OrderInstructorModel({required this.id, required this.name});
  factory _OrderInstructorModel.fromJson(Map<String, dynamic> json) => _$OrderInstructorModelFromJson(json);

@override final  int id;
@override final  String name;

/// Create a copy of OrderInstructorModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderInstructorModelCopyWith<_OrderInstructorModel> get copyWith => __$OrderInstructorModelCopyWithImpl<_OrderInstructorModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderInstructorModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderInstructorModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'OrderInstructorModel(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$OrderInstructorModelCopyWith<$Res> implements $OrderInstructorModelCopyWith<$Res> {
  factory _$OrderInstructorModelCopyWith(_OrderInstructorModel value, $Res Function(_OrderInstructorModel) _then) = __$OrderInstructorModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String name
});




}
/// @nodoc
class __$OrderInstructorModelCopyWithImpl<$Res>
    implements _$OrderInstructorModelCopyWith<$Res> {
  __$OrderInstructorModelCopyWithImpl(this._self, this._then);

  final _OrderInstructorModel _self;
  final $Res Function(_OrderInstructorModel) _then;

/// Create a copy of OrderInstructorModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,}) {
  return _then(_OrderInstructorModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
