import 'package:freezed_annotation/freezed_annotation.dart';

part 'video_model.freezed.dart';
part 'video_model.g.dart';

@freezed
abstract class VideoModel with _$VideoModel {
  const factory VideoModel({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'title') required String title,
    @JsonKey(name: 'type') String? type,
    @JsonKey(name: 'status') String? status,
    @JsonKey(name: 'published_at') String? publishedAt,
    @JsonKey(name: 'available_at') String? availableAt,
    @JsonKey(name: 'duration') int? duration,
  }) = _VideoModel;

  factory VideoModel.fromJson(Map<String, dynamic> json) =>
      _$VideoModelFromJson(json);
}

extension VideoModelX on VideoModel {
  // YouTube thumbnail from video ID
  String get thumbnailUrl =>
      'https://img.youtube.com/vi/$id/mqdefault.jpg';

  // Full YouTube URL
  String get youtubeUrl =>
      'https://www.youtube.com/watch?v=$id';

  // Format duration from seconds
  String get formattedDuration {
    if (duration == null || duration == 0) return '';
    final h = duration! ~/ 3600;
    final m = (duration! % 3600) ~/ 60;
    final s = duration! % 60;
    if (h > 0) {
      return '${h}h ${m}m';
    }
    return '${m}m ${s.toString().padLeft(2, '0')}s';
  }

  bool get isLive => status == 'live';
  bool get isUpcoming => status == 'upcoming';
}