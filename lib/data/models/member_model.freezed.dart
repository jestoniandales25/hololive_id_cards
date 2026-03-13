// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'member_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MemberModel {

@JsonKey(name: 'id') String get id;@JsonKey(name: 'name') String get name;@JsonKey(name: 'english_name') String? get englishName;@JsonKey(name: 'photo') String? get photo;@JsonKey(name: 'group') String? get group;@JsonKey(name: 'org') String? get org;@JsonKey(name: 'description') String? get description;@JsonKey(name: 'subscriber_count') int? get subscriberCount;@JsonKey(name: 'video_count') int? get videoCount;@JsonKey(name: 'view_count') int? get viewCount;@JsonKey(name: 'inactive') bool get inactive;
/// Create a copy of MemberModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemberModelCopyWith<MemberModel> get copyWith => _$MemberModelCopyWithImpl<MemberModel>(this as MemberModel, _$identity);

  /// Serializes this MemberModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MemberModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.englishName, englishName) || other.englishName == englishName)&&(identical(other.photo, photo) || other.photo == photo)&&(identical(other.group, group) || other.group == group)&&(identical(other.org, org) || other.org == org)&&(identical(other.description, description) || other.description == description)&&(identical(other.subscriberCount, subscriberCount) || other.subscriberCount == subscriberCount)&&(identical(other.videoCount, videoCount) || other.videoCount == videoCount)&&(identical(other.viewCount, viewCount) || other.viewCount == viewCount)&&(identical(other.inactive, inactive) || other.inactive == inactive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,englishName,photo,group,org,description,subscriberCount,videoCount,viewCount,inactive);

@override
String toString() {
  return 'MemberModel(id: $id, name: $name, englishName: $englishName, photo: $photo, group: $group, org: $org, description: $description, subscriberCount: $subscriberCount, videoCount: $videoCount, viewCount: $viewCount, inactive: $inactive)';
}


}

/// @nodoc
abstract mixin class $MemberModelCopyWith<$Res>  {
  factory $MemberModelCopyWith(MemberModel value, $Res Function(MemberModel) _then) = _$MemberModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'name') String name,@JsonKey(name: 'english_name') String? englishName,@JsonKey(name: 'photo') String? photo,@JsonKey(name: 'group') String? group,@JsonKey(name: 'org') String? org,@JsonKey(name: 'description') String? description,@JsonKey(name: 'subscriber_count') int? subscriberCount,@JsonKey(name: 'video_count') int? videoCount,@JsonKey(name: 'view_count') int? viewCount,@JsonKey(name: 'inactive') bool inactive
});




}
/// @nodoc
class _$MemberModelCopyWithImpl<$Res>
    implements $MemberModelCopyWith<$Res> {
  _$MemberModelCopyWithImpl(this._self, this._then);

  final MemberModel _self;
  final $Res Function(MemberModel) _then;

/// Create a copy of MemberModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? englishName = freezed,Object? photo = freezed,Object? group = freezed,Object? org = freezed,Object? description = freezed,Object? subscriberCount = freezed,Object? videoCount = freezed,Object? viewCount = freezed,Object? inactive = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,englishName: freezed == englishName ? _self.englishName : englishName // ignore: cast_nullable_to_non_nullable
as String?,photo: freezed == photo ? _self.photo : photo // ignore: cast_nullable_to_non_nullable
as String?,group: freezed == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as String?,org: freezed == org ? _self.org : org // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,subscriberCount: freezed == subscriberCount ? _self.subscriberCount : subscriberCount // ignore: cast_nullable_to_non_nullable
as int?,videoCount: freezed == videoCount ? _self.videoCount : videoCount // ignore: cast_nullable_to_non_nullable
as int?,viewCount: freezed == viewCount ? _self.viewCount : viewCount // ignore: cast_nullable_to_non_nullable
as int?,inactive: null == inactive ? _self.inactive : inactive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [MemberModel].
extension MemberModelPatterns on MemberModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MemberModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MemberModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MemberModel value)  $default,){
final _that = this;
switch (_that) {
case _MemberModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MemberModel value)?  $default,){
final _that = this;
switch (_that) {
case _MemberModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'name')  String name, @JsonKey(name: 'english_name')  String? englishName, @JsonKey(name: 'photo')  String? photo, @JsonKey(name: 'group')  String? group, @JsonKey(name: 'org')  String? org, @JsonKey(name: 'description')  String? description, @JsonKey(name: 'subscriber_count')  int? subscriberCount, @JsonKey(name: 'video_count')  int? videoCount, @JsonKey(name: 'view_count')  int? viewCount, @JsonKey(name: 'inactive')  bool inactive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MemberModel() when $default != null:
return $default(_that.id,_that.name,_that.englishName,_that.photo,_that.group,_that.org,_that.description,_that.subscriberCount,_that.videoCount,_that.viewCount,_that.inactive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'name')  String name, @JsonKey(name: 'english_name')  String? englishName, @JsonKey(name: 'photo')  String? photo, @JsonKey(name: 'group')  String? group, @JsonKey(name: 'org')  String? org, @JsonKey(name: 'description')  String? description, @JsonKey(name: 'subscriber_count')  int? subscriberCount, @JsonKey(name: 'video_count')  int? videoCount, @JsonKey(name: 'view_count')  int? viewCount, @JsonKey(name: 'inactive')  bool inactive)  $default,) {final _that = this;
switch (_that) {
case _MemberModel():
return $default(_that.id,_that.name,_that.englishName,_that.photo,_that.group,_that.org,_that.description,_that.subscriberCount,_that.videoCount,_that.viewCount,_that.inactive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'name')  String name, @JsonKey(name: 'english_name')  String? englishName, @JsonKey(name: 'photo')  String? photo, @JsonKey(name: 'group')  String? group, @JsonKey(name: 'org')  String? org, @JsonKey(name: 'description')  String? description, @JsonKey(name: 'subscriber_count')  int? subscriberCount, @JsonKey(name: 'video_count')  int? videoCount, @JsonKey(name: 'view_count')  int? viewCount, @JsonKey(name: 'inactive')  bool inactive)?  $default,) {final _that = this;
switch (_that) {
case _MemberModel() when $default != null:
return $default(_that.id,_that.name,_that.englishName,_that.photo,_that.group,_that.org,_that.description,_that.subscriberCount,_that.videoCount,_that.viewCount,_that.inactive);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _MemberModel implements MemberModel {
  const _MemberModel({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'name') required this.name, @JsonKey(name: 'english_name') this.englishName, @JsonKey(name: 'photo') this.photo, @JsonKey(name: 'group') this.group, @JsonKey(name: 'org') this.org, @JsonKey(name: 'description') this.description, @JsonKey(name: 'subscriber_count') this.subscriberCount, @JsonKey(name: 'video_count') this.videoCount, @JsonKey(name: 'view_count') this.viewCount, @JsonKey(name: 'inactive') this.inactive = false});
  factory _MemberModel.fromJson(Map<String, dynamic> json) => _$MemberModelFromJson(json);

@override@JsonKey(name: 'id') final  String id;
@override@JsonKey(name: 'name') final  String name;
@override@JsonKey(name: 'english_name') final  String? englishName;
@override@JsonKey(name: 'photo') final  String? photo;
@override@JsonKey(name: 'group') final  String? group;
@override@JsonKey(name: 'org') final  String? org;
@override@JsonKey(name: 'description') final  String? description;
@override@JsonKey(name: 'subscriber_count') final  int? subscriberCount;
@override@JsonKey(name: 'video_count') final  int? videoCount;
@override@JsonKey(name: 'view_count') final  int? viewCount;
@override@JsonKey(name: 'inactive') final  bool inactive;

/// Create a copy of MemberModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemberModelCopyWith<_MemberModel> get copyWith => __$MemberModelCopyWithImpl<_MemberModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MemberModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MemberModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.englishName, englishName) || other.englishName == englishName)&&(identical(other.photo, photo) || other.photo == photo)&&(identical(other.group, group) || other.group == group)&&(identical(other.org, org) || other.org == org)&&(identical(other.description, description) || other.description == description)&&(identical(other.subscriberCount, subscriberCount) || other.subscriberCount == subscriberCount)&&(identical(other.videoCount, videoCount) || other.videoCount == videoCount)&&(identical(other.viewCount, viewCount) || other.viewCount == viewCount)&&(identical(other.inactive, inactive) || other.inactive == inactive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,englishName,photo,group,org,description,subscriberCount,videoCount,viewCount,inactive);

@override
String toString() {
  return 'MemberModel(id: $id, name: $name, englishName: $englishName, photo: $photo, group: $group, org: $org, description: $description, subscriberCount: $subscriberCount, videoCount: $videoCount, viewCount: $viewCount, inactive: $inactive)';
}


}

/// @nodoc
abstract mixin class _$MemberModelCopyWith<$Res> implements $MemberModelCopyWith<$Res> {
  factory _$MemberModelCopyWith(_MemberModel value, $Res Function(_MemberModel) _then) = __$MemberModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'name') String name,@JsonKey(name: 'english_name') String? englishName,@JsonKey(name: 'photo') String? photo,@JsonKey(name: 'group') String? group,@JsonKey(name: 'org') String? org,@JsonKey(name: 'description') String? description,@JsonKey(name: 'subscriber_count') int? subscriberCount,@JsonKey(name: 'video_count') int? videoCount,@JsonKey(name: 'view_count') int? viewCount,@JsonKey(name: 'inactive') bool inactive
});




}
/// @nodoc
class __$MemberModelCopyWithImpl<$Res>
    implements _$MemberModelCopyWith<$Res> {
  __$MemberModelCopyWithImpl(this._self, this._then);

  final _MemberModel _self;
  final $Res Function(_MemberModel) _then;

/// Create a copy of MemberModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? englishName = freezed,Object? photo = freezed,Object? group = freezed,Object? org = freezed,Object? description = freezed,Object? subscriberCount = freezed,Object? videoCount = freezed,Object? viewCount = freezed,Object? inactive = null,}) {
  return _then(_MemberModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,englishName: freezed == englishName ? _self.englishName : englishName // ignore: cast_nullable_to_non_nullable
as String?,photo: freezed == photo ? _self.photo : photo // ignore: cast_nullable_to_non_nullable
as String?,group: freezed == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as String?,org: freezed == org ? _self.org : org // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,subscriberCount: freezed == subscriberCount ? _self.subscriberCount : subscriberCount // ignore: cast_nullable_to_non_nullable
as int?,videoCount: freezed == videoCount ? _self.videoCount : videoCount // ignore: cast_nullable_to_non_nullable
as int?,viewCount: freezed == viewCount ? _self.viewCount : viewCount // ignore: cast_nullable_to_non_nullable
as int?,inactive: null == inactive ? _self.inactive : inactive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
