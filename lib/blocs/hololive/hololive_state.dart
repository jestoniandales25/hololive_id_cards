import 'package:equatable/equatable.dart';
import 'package:hololive_id_cards/data/models/member_model.dart';
import 'package:hololive_id_cards/data/models/song_model.dart';
import 'package:hololive_id_cards/data/models/video_model.dart';

enum HololiveStatus { idle, loading, success, error }

class HololiveState extends Equatable {
  final HololiveStatus membersStatus;
  final String? membersError;
  final List<MemberModel> members;

  final HololiveStatus videosStatus;
  final String? videosError;
  final List<VideoModel> videos;

  final HololiveStatus songsStatus;
  final String? songsError;
  final List<VideoModel> songs;

  final HololiveStatus itunesSongsStatus;
  final String? itunesSongsError;
  final List<SongModel> itunesSongs;

  final HololiveStatus liveVideosStatus;
  final String? liveVideosError;
  final List<VideoModel> liveVideos;

  const HololiveState({
    this.membersStatus = HololiveStatus.idle,
    this.membersError,
    this.members = const [],
    this.videosStatus = HololiveStatus.idle,
    this.videosError,
    this.videos = const [],
    this.songsStatus = HololiveStatus.idle,
    this.songsError,
    this.songs = const [],
    this.itunesSongsStatus = HololiveStatus.idle,
    this.itunesSongsError,
    this.itunesSongs = const [],
    this.liveVideosStatus = HololiveStatus.idle,
    this.liveVideosError,
    this.liveVideos = const [],
  });

  HololiveState copyWith({
    HololiveStatus? membersStatus,
    String? membersError,
    List<MemberModel>? members,
    HololiveStatus? videosStatus,
    String? videosError,
    List<VideoModel>? videos,
    HololiveStatus? songsStatus,
    String? songsError,
    List<VideoModel>? songs,
    HololiveStatus? itunesSongsStatus,
    String? itunesSongsError,
    List<SongModel>? itunesSongs,
    HololiveStatus? liveVideosStatus,
    String? liveVideosError,
    List<VideoModel>? liveVideos,
  }) {
    return HololiveState(
      membersStatus: membersStatus ?? this.membersStatus,
      membersError: membersError ?? this.membersError,
      members: members ?? this.members,
      videosStatus: videosStatus ?? this.videosStatus,
      videosError: videosError ?? this.videosError,
      videos: videos ?? this.videos,
      songsStatus: songsStatus ?? this.songsStatus,
      songsError: songsError ?? this.songsError,
      songs: songs ?? this.songs,
      itunesSongsStatus: itunesSongsStatus ?? this.itunesSongsStatus,
      itunesSongsError: itunesSongsError ?? this.itunesSongsError,
      itunesSongs: itunesSongs ?? this.itunesSongs,
      liveVideosStatus: liveVideosStatus ?? this.liveVideosStatus,
      liveVideosError: liveVideosError ?? this.liveVideosError,
      liveVideos: liveVideos ?? this.liveVideos,
    );
  }

  @override
  List<Object?> get props => [
        membersStatus,
        membersError,
        members,
        videosStatus,
        videosError,
        videos,
        songsStatus,
        songsError,
        songs,
        itunesSongsStatus,
        itunesSongsError,
        itunesSongs,
        liveVideosStatus,
        liveVideosError,
        liveVideos,
      ];
}
