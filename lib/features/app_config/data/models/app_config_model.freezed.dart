// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_config_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppConfigModel {

@JsonKey(name: 'latest_android_version') String get latestAndroidVersion;@JsonKey(name: 'latest_supported_android_version') String get latestSupportedAndroidVersion;@JsonKey(name: 'update_android_features') String get updateAndroidFeatures;@JsonKey(name: 'latest_ios_version') String get latestIosVersion;@JsonKey(name: 'latest_supported_ios_version') String get latestSupportedIosVersion;@JsonKey(name: 'update_ios_features') String get updateIosFeatures;@JsonKey(name: 'direct_android_link') String get directAndroidLink;@JsonKey(name: 'android_privacy_link') String get androidPrivacyLink;@JsonKey(name: 'ios_privacy_link') String get iosPrivacyLink;
/// Create a copy of AppConfigModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppConfigModelCopyWith<AppConfigModel> get copyWith => _$AppConfigModelCopyWithImpl<AppConfigModel>(this as AppConfigModel, _$identity);

  /// Serializes this AppConfigModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppConfigModel&&(identical(other.latestAndroidVersion, latestAndroidVersion) || other.latestAndroidVersion == latestAndroidVersion)&&(identical(other.latestSupportedAndroidVersion, latestSupportedAndroidVersion) || other.latestSupportedAndroidVersion == latestSupportedAndroidVersion)&&(identical(other.updateAndroidFeatures, updateAndroidFeatures) || other.updateAndroidFeatures == updateAndroidFeatures)&&(identical(other.latestIosVersion, latestIosVersion) || other.latestIosVersion == latestIosVersion)&&(identical(other.latestSupportedIosVersion, latestSupportedIosVersion) || other.latestSupportedIosVersion == latestSupportedIosVersion)&&(identical(other.updateIosFeatures, updateIosFeatures) || other.updateIosFeatures == updateIosFeatures)&&(identical(other.directAndroidLink, directAndroidLink) || other.directAndroidLink == directAndroidLink)&&(identical(other.androidPrivacyLink, androidPrivacyLink) || other.androidPrivacyLink == androidPrivacyLink)&&(identical(other.iosPrivacyLink, iosPrivacyLink) || other.iosPrivacyLink == iosPrivacyLink));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,latestAndroidVersion,latestSupportedAndroidVersion,updateAndroidFeatures,latestIosVersion,latestSupportedIosVersion,updateIosFeatures,directAndroidLink,androidPrivacyLink,iosPrivacyLink);

@override
String toString() {
  return 'AppConfigModel(latestAndroidVersion: $latestAndroidVersion, latestSupportedAndroidVersion: $latestSupportedAndroidVersion, updateAndroidFeatures: $updateAndroidFeatures, latestIosVersion: $latestIosVersion, latestSupportedIosVersion: $latestSupportedIosVersion, updateIosFeatures: $updateIosFeatures, directAndroidLink: $directAndroidLink, androidPrivacyLink: $androidPrivacyLink, iosPrivacyLink: $iosPrivacyLink)';
}


}

/// @nodoc
abstract mixin class $AppConfigModelCopyWith<$Res>  {
  factory $AppConfigModelCopyWith(AppConfigModel value, $Res Function(AppConfigModel) _then) = _$AppConfigModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'latest_android_version') String latestAndroidVersion,@JsonKey(name: 'latest_supported_android_version') String latestSupportedAndroidVersion,@JsonKey(name: 'update_android_features') String updateAndroidFeatures,@JsonKey(name: 'latest_ios_version') String latestIosVersion,@JsonKey(name: 'latest_supported_ios_version') String latestSupportedIosVersion,@JsonKey(name: 'update_ios_features') String updateIosFeatures,@JsonKey(name: 'direct_android_link') String directAndroidLink,@JsonKey(name: 'android_privacy_link') String androidPrivacyLink,@JsonKey(name: 'ios_privacy_link') String iosPrivacyLink
});




}
/// @nodoc
class _$AppConfigModelCopyWithImpl<$Res>
    implements $AppConfigModelCopyWith<$Res> {
  _$AppConfigModelCopyWithImpl(this._self, this._then);

  final AppConfigModel _self;
  final $Res Function(AppConfigModel) _then;

/// Create a copy of AppConfigModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? latestAndroidVersion = null,Object? latestSupportedAndroidVersion = null,Object? updateAndroidFeatures = null,Object? latestIosVersion = null,Object? latestSupportedIosVersion = null,Object? updateIosFeatures = null,Object? directAndroidLink = null,Object? androidPrivacyLink = null,Object? iosPrivacyLink = null,}) {
  return _then(_self.copyWith(
latestAndroidVersion: null == latestAndroidVersion ? _self.latestAndroidVersion : latestAndroidVersion // ignore: cast_nullable_to_non_nullable
as String,latestSupportedAndroidVersion: null == latestSupportedAndroidVersion ? _self.latestSupportedAndroidVersion : latestSupportedAndroidVersion // ignore: cast_nullable_to_non_nullable
as String,updateAndroidFeatures: null == updateAndroidFeatures ? _self.updateAndroidFeatures : updateAndroidFeatures // ignore: cast_nullable_to_non_nullable
as String,latestIosVersion: null == latestIosVersion ? _self.latestIosVersion : latestIosVersion // ignore: cast_nullable_to_non_nullable
as String,latestSupportedIosVersion: null == latestSupportedIosVersion ? _self.latestSupportedIosVersion : latestSupportedIosVersion // ignore: cast_nullable_to_non_nullable
as String,updateIosFeatures: null == updateIosFeatures ? _self.updateIosFeatures : updateIosFeatures // ignore: cast_nullable_to_non_nullable
as String,directAndroidLink: null == directAndroidLink ? _self.directAndroidLink : directAndroidLink // ignore: cast_nullable_to_non_nullable
as String,androidPrivacyLink: null == androidPrivacyLink ? _self.androidPrivacyLink : androidPrivacyLink // ignore: cast_nullable_to_non_nullable
as String,iosPrivacyLink: null == iosPrivacyLink ? _self.iosPrivacyLink : iosPrivacyLink // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AppConfigModel].
extension AppConfigModelPatterns on AppConfigModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppConfigModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppConfigModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppConfigModel value)  $default,){
final _that = this;
switch (_that) {
case _AppConfigModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppConfigModel value)?  $default,){
final _that = this;
switch (_that) {
case _AppConfigModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'latest_android_version')  String latestAndroidVersion, @JsonKey(name: 'latest_supported_android_version')  String latestSupportedAndroidVersion, @JsonKey(name: 'update_android_features')  String updateAndroidFeatures, @JsonKey(name: 'latest_ios_version')  String latestIosVersion, @JsonKey(name: 'latest_supported_ios_version')  String latestSupportedIosVersion, @JsonKey(name: 'update_ios_features')  String updateIosFeatures, @JsonKey(name: 'direct_android_link')  String directAndroidLink, @JsonKey(name: 'android_privacy_link')  String androidPrivacyLink, @JsonKey(name: 'ios_privacy_link')  String iosPrivacyLink)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppConfigModel() when $default != null:
return $default(_that.latestAndroidVersion,_that.latestSupportedAndroidVersion,_that.updateAndroidFeatures,_that.latestIosVersion,_that.latestSupportedIosVersion,_that.updateIosFeatures,_that.directAndroidLink,_that.androidPrivacyLink,_that.iosPrivacyLink);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'latest_android_version')  String latestAndroidVersion, @JsonKey(name: 'latest_supported_android_version')  String latestSupportedAndroidVersion, @JsonKey(name: 'update_android_features')  String updateAndroidFeatures, @JsonKey(name: 'latest_ios_version')  String latestIosVersion, @JsonKey(name: 'latest_supported_ios_version')  String latestSupportedIosVersion, @JsonKey(name: 'update_ios_features')  String updateIosFeatures, @JsonKey(name: 'direct_android_link')  String directAndroidLink, @JsonKey(name: 'android_privacy_link')  String androidPrivacyLink, @JsonKey(name: 'ios_privacy_link')  String iosPrivacyLink)  $default,) {final _that = this;
switch (_that) {
case _AppConfigModel():
return $default(_that.latestAndroidVersion,_that.latestSupportedAndroidVersion,_that.updateAndroidFeatures,_that.latestIosVersion,_that.latestSupportedIosVersion,_that.updateIosFeatures,_that.directAndroidLink,_that.androidPrivacyLink,_that.iosPrivacyLink);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'latest_android_version')  String latestAndroidVersion, @JsonKey(name: 'latest_supported_android_version')  String latestSupportedAndroidVersion, @JsonKey(name: 'update_android_features')  String updateAndroidFeatures, @JsonKey(name: 'latest_ios_version')  String latestIosVersion, @JsonKey(name: 'latest_supported_ios_version')  String latestSupportedIosVersion, @JsonKey(name: 'update_ios_features')  String updateIosFeatures, @JsonKey(name: 'direct_android_link')  String directAndroidLink, @JsonKey(name: 'android_privacy_link')  String androidPrivacyLink, @JsonKey(name: 'ios_privacy_link')  String iosPrivacyLink)?  $default,) {final _that = this;
switch (_that) {
case _AppConfigModel() when $default != null:
return $default(_that.latestAndroidVersion,_that.latestSupportedAndroidVersion,_that.updateAndroidFeatures,_that.latestIosVersion,_that.latestSupportedIosVersion,_that.updateIosFeatures,_that.directAndroidLink,_that.androidPrivacyLink,_that.iosPrivacyLink);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppConfigModel extends AppConfigModel {
  const _AppConfigModel({@JsonKey(name: 'latest_android_version') required this.latestAndroidVersion, @JsonKey(name: 'latest_supported_android_version') required this.latestSupportedAndroidVersion, @JsonKey(name: 'update_android_features') required this.updateAndroidFeatures, @JsonKey(name: 'latest_ios_version') required this.latestIosVersion, @JsonKey(name: 'latest_supported_ios_version') required this.latestSupportedIosVersion, @JsonKey(name: 'update_ios_features') required this.updateIosFeatures, @JsonKey(name: 'direct_android_link') required this.directAndroidLink, @JsonKey(name: 'android_privacy_link') required this.androidPrivacyLink, @JsonKey(name: 'ios_privacy_link') required this.iosPrivacyLink}): super._();
  factory _AppConfigModel.fromJson(Map<String, dynamic> json) => _$AppConfigModelFromJson(json);

@override@JsonKey(name: 'latest_android_version') final  String latestAndroidVersion;
@override@JsonKey(name: 'latest_supported_android_version') final  String latestSupportedAndroidVersion;
@override@JsonKey(name: 'update_android_features') final  String updateAndroidFeatures;
@override@JsonKey(name: 'latest_ios_version') final  String latestIosVersion;
@override@JsonKey(name: 'latest_supported_ios_version') final  String latestSupportedIosVersion;
@override@JsonKey(name: 'update_ios_features') final  String updateIosFeatures;
@override@JsonKey(name: 'direct_android_link') final  String directAndroidLink;
@override@JsonKey(name: 'android_privacy_link') final  String androidPrivacyLink;
@override@JsonKey(name: 'ios_privacy_link') final  String iosPrivacyLink;

/// Create a copy of AppConfigModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppConfigModelCopyWith<_AppConfigModel> get copyWith => __$AppConfigModelCopyWithImpl<_AppConfigModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppConfigModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppConfigModel&&(identical(other.latestAndroidVersion, latestAndroidVersion) || other.latestAndroidVersion == latestAndroidVersion)&&(identical(other.latestSupportedAndroidVersion, latestSupportedAndroidVersion) || other.latestSupportedAndroidVersion == latestSupportedAndroidVersion)&&(identical(other.updateAndroidFeatures, updateAndroidFeatures) || other.updateAndroidFeatures == updateAndroidFeatures)&&(identical(other.latestIosVersion, latestIosVersion) || other.latestIosVersion == latestIosVersion)&&(identical(other.latestSupportedIosVersion, latestSupportedIosVersion) || other.latestSupportedIosVersion == latestSupportedIosVersion)&&(identical(other.updateIosFeatures, updateIosFeatures) || other.updateIosFeatures == updateIosFeatures)&&(identical(other.directAndroidLink, directAndroidLink) || other.directAndroidLink == directAndroidLink)&&(identical(other.androidPrivacyLink, androidPrivacyLink) || other.androidPrivacyLink == androidPrivacyLink)&&(identical(other.iosPrivacyLink, iosPrivacyLink) || other.iosPrivacyLink == iosPrivacyLink));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,latestAndroidVersion,latestSupportedAndroidVersion,updateAndroidFeatures,latestIosVersion,latestSupportedIosVersion,updateIosFeatures,directAndroidLink,androidPrivacyLink,iosPrivacyLink);

@override
String toString() {
  return 'AppConfigModel(latestAndroidVersion: $latestAndroidVersion, latestSupportedAndroidVersion: $latestSupportedAndroidVersion, updateAndroidFeatures: $updateAndroidFeatures, latestIosVersion: $latestIosVersion, latestSupportedIosVersion: $latestSupportedIosVersion, updateIosFeatures: $updateIosFeatures, directAndroidLink: $directAndroidLink, androidPrivacyLink: $androidPrivacyLink, iosPrivacyLink: $iosPrivacyLink)';
}


}

/// @nodoc
abstract mixin class _$AppConfigModelCopyWith<$Res> implements $AppConfigModelCopyWith<$Res> {
  factory _$AppConfigModelCopyWith(_AppConfigModel value, $Res Function(_AppConfigModel) _then) = __$AppConfigModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'latest_android_version') String latestAndroidVersion,@JsonKey(name: 'latest_supported_android_version') String latestSupportedAndroidVersion,@JsonKey(name: 'update_android_features') String updateAndroidFeatures,@JsonKey(name: 'latest_ios_version') String latestIosVersion,@JsonKey(name: 'latest_supported_ios_version') String latestSupportedIosVersion,@JsonKey(name: 'update_ios_features') String updateIosFeatures,@JsonKey(name: 'direct_android_link') String directAndroidLink,@JsonKey(name: 'android_privacy_link') String androidPrivacyLink,@JsonKey(name: 'ios_privacy_link') String iosPrivacyLink
});




}
/// @nodoc
class __$AppConfigModelCopyWithImpl<$Res>
    implements _$AppConfigModelCopyWith<$Res> {
  __$AppConfigModelCopyWithImpl(this._self, this._then);

  final _AppConfigModel _self;
  final $Res Function(_AppConfigModel) _then;

/// Create a copy of AppConfigModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? latestAndroidVersion = null,Object? latestSupportedAndroidVersion = null,Object? updateAndroidFeatures = null,Object? latestIosVersion = null,Object? latestSupportedIosVersion = null,Object? updateIosFeatures = null,Object? directAndroidLink = null,Object? androidPrivacyLink = null,Object? iosPrivacyLink = null,}) {
  return _then(_AppConfigModel(
latestAndroidVersion: null == latestAndroidVersion ? _self.latestAndroidVersion : latestAndroidVersion // ignore: cast_nullable_to_non_nullable
as String,latestSupportedAndroidVersion: null == latestSupportedAndroidVersion ? _self.latestSupportedAndroidVersion : latestSupportedAndroidVersion // ignore: cast_nullable_to_non_nullable
as String,updateAndroidFeatures: null == updateAndroidFeatures ? _self.updateAndroidFeatures : updateAndroidFeatures // ignore: cast_nullable_to_non_nullable
as String,latestIosVersion: null == latestIosVersion ? _self.latestIosVersion : latestIosVersion // ignore: cast_nullable_to_non_nullable
as String,latestSupportedIosVersion: null == latestSupportedIosVersion ? _self.latestSupportedIosVersion : latestSupportedIosVersion // ignore: cast_nullable_to_non_nullable
as String,updateIosFeatures: null == updateIosFeatures ? _self.updateIosFeatures : updateIosFeatures // ignore: cast_nullable_to_non_nullable
as String,directAndroidLink: null == directAndroidLink ? _self.directAndroidLink : directAndroidLink // ignore: cast_nullable_to_non_nullable
as String,androidPrivacyLink: null == androidPrivacyLink ? _self.androidPrivacyLink : androidPrivacyLink // ignore: cast_nullable_to_non_nullable
as String,iosPrivacyLink: null == iosPrivacyLink ? _self.iosPrivacyLink : iosPrivacyLink // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
