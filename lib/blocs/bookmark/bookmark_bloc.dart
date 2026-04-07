import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/models/video_model.dart';
import 'bookmark_event.dart';
import 'bookmark_state.dart';

class BookmarkBloc extends Bloc<BookmarkEvent, BookmarkState> {
  final _secureStorage = const FlutterSecureStorage();

  String get _storageKey {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    return uid != null ? 'secure_bookmarks_$uid' : 'secure_bookmarks_guest';
  }

  BookmarkBloc() : super(const BookmarkState()) {
    on<LoadBookmarksEvent>(_onLoadBookmarks);
    on<ToggleBookmarkEvent>(_onToggleBookmark);
    on<ClearMemberBookmarksEvent>(_onClearMemberBookmarks);
  }

  Future<void> _onLoadBookmarks(
      LoadBookmarksEvent event, Emitter<BookmarkState> emit) async {
    final String? data = await _secureStorage.read(key: _storageKey);
    if (data != null) {
      final Map<String, dynamic> decoded = jsonDecode(data);
      final bookmarkedMap = decoded.map(
        (channelId, videos) => MapEntry(
          channelId,
          (videos as List)
              .map((v) => VideoModel.fromJson(v as Map<String, dynamic>))
              .toList(),
        ),
      );
      emit(BookmarkState(bookmarks: bookmarkedMap));
    } else {
      emit(const BookmarkState(bookmarks: {}));
    }
  }

  Future<void> _onToggleBookmark(
      ToggleBookmarkEvent event, Emitter<BookmarkState> emit) async {
    final Map<String, List<VideoModel>> updatedBookmarks =
        Map.from(state.bookmarks);
    final String channelId = event.channelId;
    final VideoModel video = event.video;

    final list = updatedBookmarks[channelId] ?? [];
    final exists = list.any((v) => v.id == video.id);

    if (exists) {
      updatedBookmarks[channelId] =
          list.where((v) => v.id != video.id).toList();
      if (updatedBookmarks[channelId]!.isEmpty) {
        updatedBookmarks.remove(channelId);
      }
    } else {
      updatedBookmarks[channelId] = [...list, video];
    }

    emit(BookmarkState(bookmarks: updatedBookmarks));
    await _saveToSecurePrefs(updatedBookmarks);
  }

  Future<void> _onClearMemberBookmarks(
      ClearMemberBookmarksEvent event, Emitter<BookmarkState> emit) async {
    final Map<String, List<VideoModel>> updatedBookmarks =
        Map.from(state.bookmarks);
    updatedBookmarks.remove(event.channelId);

    emit(BookmarkState(bookmarks: updatedBookmarks));
    await _saveToSecurePrefs(updatedBookmarks);
  }

  Future<void> _saveToSecurePrefs(Map<String, List<VideoModel>> bookmarks) async {
    final encoded = jsonEncode(
      bookmarks.map(
        (channelId, videos) =>
            MapEntry(channelId, videos.map((v) => v.toJson()).toList()),
      ),
    );
    await _secureStorage.write(key: _storageKey, value: encoded);
  }
}
