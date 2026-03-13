import 'dart:convert';
import 'package:hololive_id_cards/data/models/member_model.dart';
import 'package:http/http.dart' as http;

import '../../core/env/env.dart';

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
}