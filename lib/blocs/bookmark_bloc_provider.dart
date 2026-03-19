import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/video_model.dart';

class BookmarkBlocProvider extends ChangeNotifier {
  static const String _storageKey = 'bookmarked_videos';

  // Map of channelId -> List of bookmarked videos
  // This allows per-member bookmark filtering
  Map<String, List<VideoModel>> _bookmarks = {};

  Map<String, List<VideoModel>> get bookmarks => _bookmarks;

  // All bookmarks flat list — for the bookmark screen
  List<VideoModel> get allBookmarks {
    final all = _bookmarks.values.expand((list) => list).toList();
    // Sort by most recently bookmarked (last added first)
    return all.reversed.toList();
  }

  // Get bookmarks for a specific member
  List<VideoModel> bookmarksForMember(String channelId) {
    return _bookmarks[channelId] ?? [];
  }

  // Check if a specific video is bookmarked
  bool isBookmarked(String videoId) {
    return _bookmarks.values.expand((list) => list).any((v) => v.id == videoId);
  }

  // Load from SharedPreferences on app start
  Future<void> loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_storageKey);
    if (data != null) {
      final Map<String, dynamic> decoded = jsonDecode(data);
      _bookmarks = decoded.map(
        (channelId, videos) => MapEntry(
          channelId,
          (videos as List)
              .map((v) => VideoModel.fromJson(v as Map<String, dynamic>))
              .toList(),
        ),
      );
      notifyListeners();
    }
  }

  // Toggle bookmark — add if not exists, remove if exists
  Future<void> toggleBookmark(String channelId, VideoModel video) async {
    final list = _bookmarks[channelId] ?? [];
    final exists = list.any((v) => v.id == video.id);

    if (exists) {
      // Remove bookmark
      _bookmarks[channelId] = list.where((v) => v.id != video.id).toList();
      if (_bookmarks[channelId]!.isEmpty) {
        _bookmarks.remove(channelId);
      }
    } else {
      // Add bookmark
      _bookmarks[channelId] = [...list, video];
    }

    notifyListeners();
    await _saveToPrefs();
  }

  // Remove all bookmarks for a member
  Future<void> clearMemberBookmarks(String channelId) async {
    _bookmarks.remove(channelId);
    notifyListeners();
    await _saveToPrefs();
  }

  // Save to SharedPreferences
  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(
      _bookmarks.map(
        (channelId, videos) =>
            MapEntry(channelId, videos.map((v) => v.toJson()).toList()),
      ),
    );
    await prefs.setString(_storageKey, encoded);
  }
}
