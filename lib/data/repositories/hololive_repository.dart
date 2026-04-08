import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:hololive_id_cards/core/env/env.dart';
import 'package:hololive_id_cards/data/models/member_model.dart';
import 'package:hololive_id_cards/data/models/song_model.dart';
import 'package:hololive_id_cards/data/models/video_model.dart';
import 'package:hololive_id_cards/data/network/holodex_client.dart';
import 'package:hololive_id_cards/data/network/itunes_client.dart';

class HololiveRepository {
  late final Dio _dio;
  late final Dio _itunesDio;
  late final HolodexClient _holodexClient;
  late final ItunesClient _itunesClient;

  HololiveRepository() {
    _dio = Dio(
      BaseOptions(
        baseUrl: Env.holodexBaseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'X-APIKEY': Env.holodexApiKey,
          'Content-Type': 'application/json',
        },
      ),
    );

    _itunesDio = Dio(
      BaseOptions(
        baseUrl: 'https://itunes.apple.com',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    _dio.interceptors.add(
      LogInterceptor(request: true, responseBody: false, error: true),
    );

    _holodexClient = HolodexClient(_dio);
    _itunesClient = ItunesClient(_itunesDio);
  }

  Future<List<MemberModel>> fetchMembers() async {
    try {
      final List<MemberModel> allMembers = [];
      int offset = 0;
      const int limit = 50; // The API strictly enforces a max limit of 50

      while (true) {
        final List<MemberModel> batch = await _holodexClient.fetchMembers(
          'Hololive', 'vtuber', limit, offset, 'subscriber_count', 'desc'
        );
        
        allMembers.addAll(batch);
        
        if (batch.length < limit) break; // If we received less than 50, we've reached the end
        offset += limit;
      }
      return allMembers;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<VideoModel>> fetchChannelVideos(String channelId) async {
    try {
      final dynamic responseData = await _holodexClient.fetchChannelVideos(
        channelId, 100, 'live,upcoming,past', 'stream', 'latest'
      );

      final List<dynamic> items = responseData is List
          ? responseData
          : (responseData['items'] ?? []);

      return items
          .map((json) => VideoModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<VideoModel>> fetchChannelSongs(String channelId) async {
    try {
      final dynamic responseData = await _holodexClient.fetchChannelVideos(
        channelId, 100, 'live,upcoming,past', 'stream,clip', 'latest'
      );

      final List<dynamic> items = responseData is List
          ? responseData
          : (responseData['items'] ?? []);

      final validTopics = [
        'music',
        'singing',
        'music_cover',
        'music_original',
        'original_song',
        'cover'
      ];

      final filteredItems = items.where((json) {
        final topic = (json as Map<String, dynamic>)['topic_id'] as String?;
        return topic != null && validTopics.contains(topic.toLowerCase());
      }).toList();

      return filteredItems
          .map((json) => VideoModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Fetches official songs/singles from Apple iTunes for a given member name.
  Future<List<SongModel>> fetchItunesSongs(String memberName) async {
    try {
      final dynamic responseData = await _itunesClient.fetchItunesSongs(
        memberName, 'music', 'song', 'us', 50
      );

      final dynamic raw = responseData is String
          ? jsonDecode(responseData)
          : responseData;

      final List<dynamic> results =
          (raw as Map<String, dynamic>)['results'] ?? [];

      return results
          .map((json) => SongModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Fetches currently live and upcoming streams for the entire org.
  Future<List<VideoModel>> fetchLiveVideos() async {
    try {
      final dynamic responseData = await _holodexClient.fetchLiveVideos(
        'Hololive', 'live,upcoming', 'stream', 50
      );

      final List<dynamic> items = responseData is List
          ? responseData
          : (responseData['items'] ?? []);

      return items
          .map((json) => VideoModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ── Error Handler ─────────────────────────────
  Exception _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return Exception('Connection timed out. Check your internet.');
      case DioExceptionType.receiveTimeout:
        return Exception('Server took too long to respond.');
      case DioExceptionType.badResponse:
        final status = e.response?.statusCode;
        if (status == 401) return Exception('Invalid API key.');
        if (status == 403) return Exception('Access denied.');
        if (status == 429) {
          return Exception('Rate limit exceeded. Try again later.');
        }
        return Exception('Server error: $status');
      case DioExceptionType.connectionError:
        return Exception('No internet connection.');
      default:
        return Exception('Something went wrong: ${e.message}');
    }
  }
}
