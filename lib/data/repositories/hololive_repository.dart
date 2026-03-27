import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:hololive_id_cards/core/env/env.dart';
import 'package:hololive_id_cards/data/models/member_model.dart';
import 'package:hololive_id_cards/data/models/song_model.dart';
import 'package:hololive_id_cards/data/models/video_model.dart';

class HololiveRepository {
  late final Dio _dio;
  late final Dio _itunesDio;

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
  }

  Future<List<MemberModel>> fetchMembers() async {
    try {
      final response = await _dio.get(
        '/channels',
        queryParameters: {
          'org': 'Hololive',
          'type': 'vtuber',
          'limit': 50,
          'sort': 'subscriber_count',
          'order': 'desc',
        },
      );

      return (response.data as List)
          .map((json) => MemberModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<VideoModel>> fetchChannelVideos(String channelId) async {
    try {
      final response = await _dio.get(
        '/channels/$channelId/videos',
        queryParameters: {
          'limit': 100, // increased to fetch more videos
          'status': 'live,upcoming,past',
          'type': 'stream',
          'order': 'latest',
        },
      );

      // API returns either a list or {items: [...]}
      final List<dynamic> items = response.data is List
          ? response.data
          : (response.data['items'] ?? []);

      return items
          .map((json) => VideoModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<VideoModel>> fetchChannelSongs(String channelId) async {
    try {
      final response = await _dio.get(
        '/channels/$channelId/videos',
        queryParameters: {
          'limit': 100, // increased to fetch more base videos to filter for songs
          'status': 'live,upcoming,past',
          'type': 'stream,clip', // getting both streams and clips to maximize chance of finding songs
          'order': 'latest',
        },
      );

      final List<dynamic> items = response.data is List
          ? response.data
          : (response.data['items'] ?? []);

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
      final response = await _itunesDio.get(
        '/search',
        queryParameters: {
          'term': memberName,
          'media': 'music',
          'entity': 'song',
          'country': 'us',
          'limit': 50,
        },
      );

      // iTunes sometimes returns raw JSON string; decode manually if needed
      final dynamic raw = response.data is String
          ? jsonDecode(response.data as String)
          : response.data;

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
      final response = await _dio.get(
        '/live',
        queryParameters: {
          'org': 'Hololive',
          'status': 'live,upcoming',
          'type': 'stream',
          'limit': 50,
        },
      );

      final List<dynamic> items = response.data is List
          ? response.data
          : (response.data['items'] ?? []);

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
        if (status == 429)
          return Exception('Rate limit exceeded. Try again later.');
        return Exception('Server error: $status');
      case DioExceptionType.connectionError:
        return Exception('No internet connection.');
      default:
        return Exception('Something went wrong: ${e.message}');
    }
  }
}
