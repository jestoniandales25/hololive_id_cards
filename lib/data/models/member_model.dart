// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'member_model.freezed.dart';
part 'member_model.g.dart';

@freezed
abstract class MemberModel with _$MemberModel {
  @JsonSerializable(explicitToJson: true)
  const factory MemberModel({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'english_name') String? englishName,
    @JsonKey(name: 'photo') String? photo,
    @JsonKey(name: 'group') String? group,
    @JsonKey(name: 'org') String? org,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'subscriber_count') int? subscriberCount,
    @JsonKey(name: 'video_count') int? videoCount,
    @JsonKey(name: 'view_count') int? viewCount,
    @JsonKey(name: 'inactive') @Default(false) bool inactive,
  }) = _MemberModel;

  factory MemberModel.fromJson(Map<String, dynamic> json) =>
      _$MemberModelFromJson(json);
}

extension MemberModelX on MemberModel {
  String get displayName => englishName ?? name;

  String get formattedSubs {
    if (subscriberCount == null) return 'N/A';        // ✅ no more int.tryParse
    if (subscriberCount! >= 1000000) {
      return '${(subscriberCount! / 1000000).toStringAsFixed(1)}M subs';
    }
    if (subscriberCount! >= 1000) {
      return '${(subscriberCount! / 1000).toStringAsFixed(1)}K subs';
    }
    return '$subscriberCount subs';
  }

  String get avatarUrl {
    if (photo != null && photo!.isNotEmpty) {
      final encoded = Uri.encodeComponent(photo!);
      return 'https://wsrv.nl/?url=$encoded&w=128&h=128&fit=cover';
    }
    return 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(displayName)}&background=00ADB5&color=fff&size=128';
  }
}