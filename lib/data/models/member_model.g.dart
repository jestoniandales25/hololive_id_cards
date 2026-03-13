// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MemberModel _$MemberModelFromJson(Map<String, dynamic> json) => _MemberModel(
  id: json['id'] as String,
  name: json['name'] as String,
  englishName: json['english_name'] as String?,
  photo: json['photo'] as String?,
  group: json['group'] as String?,
  org: json['org'] as String?,
  description: json['description'] as String?,
  subscriberCount: (json['subscriber_count'] as num?)?.toInt(),
  videoCount: (json['video_count'] as num?)?.toInt(),
  viewCount: (json['view_count'] as num?)?.toInt(),
  inactive: json['inactive'] as bool? ?? false,
);

Map<String, dynamic> _$MemberModelToJson(_MemberModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'english_name': instance.englishName,
      'photo': instance.photo,
      'group': instance.group,
      'org': instance.org,
      'description': instance.description,
      'subscriber_count': instance.subscriberCount,
      'video_count': instance.videoCount,
      'view_count': instance.viewCount,
      'inactive': instance.inactive,
    };
