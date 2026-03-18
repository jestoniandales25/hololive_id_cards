import 'dart:convert';
import 'package:hololive_id_cards/data/models/member_model.dart';
import 'package:http/http.dart' as http;
import '../../../data/models/video_model.dart';
import '../../../core/env/env.dart';

class HololiveRepository {
  Future<List<MemberModel>> fetchMembers() async {
    final uri = Uri.parse(
      '${Env.holodexBaseUrl}/channels?org=Hololive&type=vtuber&limit=50&sort=subscriber_count&order=desc',
    );

    final response = await http.get(
      uri,
      headers: {
        'X-APIKEY': Env.holodexApiKey,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((json) => MemberModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Error ${response.statusCode}: Failed to fetch members');
    }
  }

  // Fetch videos for a specific channel
  Future<List<VideoModel>> fetchChannelVideos(String channelId) async {
    final uri = Uri.parse(
      '${Env.holodexBaseUrl}/channels/$channelId/videos?limit=20&status=past&type=stream&order=latest',
    );

    final response = await http.get(
      uri,
      headers: {
        'X-APIKEY': Env.holodexApiKey,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // API returns either a list or {items: [...]}
      final List<dynamic> items =
          data is List ? data : (data['items'] ?? []);
      return items
          .map((json) => VideoModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Error ${response.statusCode}: Failed to fetch videos');
    }
  }
}