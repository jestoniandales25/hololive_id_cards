import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hololive_id_cards/data/repositories/hololive_repository.dart';

import 'hololive_event.dart';
import 'hololive_state.dart';

class HololiveBloc extends Bloc<HololiveEvent, HololiveState> {
  final HololiveRepository _repo;

  HololiveBloc(this._repo) : super(const HololiveState()) {
    on<FetchMembersEvent>(_onFetchMembers);
    on<FetchVideosEvent>(_onFetchVideos);
    on<FetchSongsEvent>(_onFetchSongs);
    on<RefreshEvent>(_onRefresh);
  }

  Future<void> _onFetchMembers(FetchMembersEvent event, Emitter<HololiveState> emit) async {
    emit(state.copyWith(membersStatus: HololiveStatus.loading, membersError: null));

    try {
      final members = await _repo.fetchMembers();
      emit(state.copyWith(membersStatus: HololiveStatus.success, members: members));
    } catch (e) {
      emit(state.copyWith(membersStatus: HololiveStatus.error, membersError: e.toString()));
    }
  }

  Future<void> _onFetchVideos(FetchVideosEvent event, Emitter<HololiveState> emit) async {
    emit(state.copyWith(videosStatus: HololiveStatus.loading, videos: []));

    try {
      final videos = await _repo.fetchChannelVideos(event.channelId);
      emit(state.copyWith(videosStatus: HololiveStatus.success, videos: videos));
    } catch (e) {
      emit(state.copyWith(videosStatus: HololiveStatus.error, videosError: e.toString()));
    }
  }

  Future<void> _onFetchSongs(FetchSongsEvent event, Emitter<HololiveState> emit) async {
    emit(state.copyWith(songsStatus: HololiveStatus.loading, songs: []));

    try {
      final songs = await _repo.fetchChannelSongs(event.channelId);
      emit(state.copyWith(songsStatus: HololiveStatus.success, songs: songs));
    } catch (e) {
      emit(state.copyWith(songsStatus: HololiveStatus.error, songsError: e.toString()));
    }
  }

  void _onRefresh(RefreshEvent event, Emitter<HololiveState> emit) {
    add(FetchMembersEvent());
  }
}
