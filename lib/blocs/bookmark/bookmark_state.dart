import 'package:equatable/equatable.dart';
import '../../data/models/video_model.dart';

class BookmarkState extends Equatable {
  final Map<String, List<VideoModel>> bookmarks;

  const BookmarkState({this.bookmarks = const {}});

  List<VideoModel> get allBookmarks {
    final all = bookmarks.values.expand((list) => list).toList();
    return all.reversed.toList();
  }

  List<VideoModel> bookmarksForMember(String channelId) {
    return bookmarks[channelId] ?? [];
  }

  bool isBookmarked(String videoId) {
    return bookmarks.values.expand((list) => list).any((v) => v.id == videoId);
  }

  @override
  List<Object> get props => [bookmarks];
}
