import 'package:dio/dio.dart';
import 'package:hololive_id_cards/core/env/env.dart';
import 'package:hololive_id_cards/data/models/member_model.dart';
import 'package:hololive_id_cards/data/models/video_model.dart';

class HololiveRepository {
  late final Dio _dio;

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

    _dio.interceptors.add(
      LogInterceptor(
        request: true,
        responseBody: false,
        error: true,
      ),
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
          'limit': 20,
          'status': 'past',
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
        if (status == 429) return Exception('Rate limit exceeded. Try again later.');
        return Exception('Server error: $status');
      case DioExceptionType.connectionError:
        return Exception('No internet connection.');
      default:
        return Exception('Something went wrong: ${e.message}');
    }
  }
}