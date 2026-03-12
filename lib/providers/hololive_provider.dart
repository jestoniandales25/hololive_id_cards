import 'package:flutter/material.dart';
import 'package:hololive_id_cards/models/hololive_model.dart';

class HololiveProvider extends ChangeNotifier {
  final List<HololiveModel> _hololiveList = [];

  List<HololiveModel> get hololiveList => _hololiveList;

  void addHololive(HololiveModel hololive) {
    if (!_hololiveList.contains(hololive)) {
      _hololiveList.add(hololive);
      notifyListeners();
    }
  }

  void removeHololive(HololiveModel hololive) {
    _hololiveList.remove(hololive);
    notifyListeners();
  }

  void clearHololive() {
    _hololiveList.clear();
    notifyListeners();
  }
}
