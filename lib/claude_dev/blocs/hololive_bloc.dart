import 'package:flutter/foundation.dart';
import 'package:hololive_id_cards/data/models/member_model.dart';
import '../../data/models/video_model.dart';
import '../data/repositories/hololive_repository.dart';

enum BlocState { idle, loading, success, error }

class HololiveBloc extends ChangeNotifier {
  final HololiveRepository _repo;

  HololiveBloc(this._repo);

  // Members state
  List<MemberModel> _members = [];
  BlocState _state = BlocState.idle;
  String? _error;

  // Videos state
  List<VideoModel> _videos = [];
  BlocState _videosState = BlocState.idle;

  // Getters
  List<MemberModel> get members => _members;
  BlocState get state => _state;
  String? get error => _error;
  bool get isLoading => _state == BlocState.loading;

  List<VideoModel> get videos => _videos;
  BlocState get videosState => _videosState;
  bool get isLoadingVideos => _videosState == BlocState.loading;

  // Load all members
  Future<void> loadMembers() async {
    _state = BlocState.loading;
    _error = null;
    notifyListeners();

    try {
      _members = await _repo.fetchMembers();
      _state = BlocState.success;
    } catch (e) {
      _error = e.toString();
      _state = BlocState.error;
    }

    notifyListeners();
  }

  // Load videos for a specific member
  Future<void> loadVideos(String channelId) async {
    _videos = [];
    _videosState = BlocState.loading;
    notifyListeners();

    try {
      _videos = await _repo.fetchChannelVideos(channelId);
      _videosState = BlocState.success;
    } catch (e) {
      _videosState = BlocState.error;
    }

    notifyListeners();
  }

  void retry() => loadMembers();
}