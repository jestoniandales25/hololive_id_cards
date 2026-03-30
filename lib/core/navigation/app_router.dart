import 'package:flutter/material.dart';
import '../../data/models/song_model.dart';
import '../../data/models/video_model.dart';
import '../../ui/screens/bookmark_screen.dart';
import '../../ui/screens/hololive_dashboard.dart';
import '../../ui/screens/member_detail_screen.dart';
import '../../ui/screens/member_songs_screen.dart';
import '../../ui/screens/song_player_screen.dart';
import '../../ui/screens/video_player_screen.dart';

class AppRouter {
  static const String root = '/';
  static const String memberDetail = '/member-detail';
  static const String memberSongs = '/member-songs';
  static const String songPlayer = '/song-player';
  static const String videoPlayer = '/video-player';
  static const String bookmarks = '/bookmarks';

  static Map<String, WidgetBuilder> get routes => {
    root: (context) => const HololiveDashboard(),
    memberDetail: (context) => const HololiveDetailScreen(),
    memberSongs: (context) => const MemberSongsScreen(),
    songPlayer: (context) => SongPlayerScreen(
          song: ModalRoute.of(context)!.settings.arguments as SongModel,
        ),
    videoPlayer: (context) => VideoPlayerScreen(
          video: ModalRoute.of(context)!.settings.arguments as VideoModel,
        ),
    bookmarks: (context) => const BookmarkScreen(),
  };
}
