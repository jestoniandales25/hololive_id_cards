import 'package:equatable/equatable.dart';
import '../../data/models/video_model.dart';

abstract class BookmarkEvent extends Equatable {
  const BookmarkEvent();

  @override
  List<Object?> get props => [];
}

class LoadBookmarksEvent extends BookmarkEvent {}

class ToggleBookmarkEvent extends BookmarkEvent {
  final String channelId;
  final VideoModel video;

  const ToggleBookmarkEvent(this.channelId, this.video);

  @override
  List<Object> get props => [channelId, video];
}

class ClearMemberBookmarksEvent extends BookmarkEvent {
  final String channelId;

  const ClearMemberBookmarksEvent(this.channelId);

  @override
  List<Object> get props => [channelId];
}
