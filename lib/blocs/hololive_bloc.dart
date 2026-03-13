import 'package:flutter/foundation.dart';
import 'package:hololive_id_cards/data/models/member_model.dart';
import '../data/repositories/hololive_repository.dart';

enum BlocState { idle, loading, success, error }

class HololiveBloc extends ChangeNotifier {
  final HololiveRepository _repo;

  HololiveBloc(this._repo);

  List<MemberModel> _members = [];
  BlocState _state = BlocState.idle;
  String? _error;

  // Getters
  List<MemberModel> get members => _members;
  BlocState get state => _state;
  String? get error => _error;
  bool get isLoading => _state == BlocState.loading;

  // Actions
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

  void retry() => loadMembers();
}