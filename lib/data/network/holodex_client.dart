import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/member_model.dart';

part 'holodex_client.g.dart';

@RestApi()
abstract class HolodexClient {
  factory HolodexClient(Dio dio, {String baseUrl}) = _HolodexClient;

  @GET('/channels')
  Future<List<MemberModel>> fetchMembers(
    @Query('org') String org,
    @Query('type') String type,
    @Query('limit') int limit,
    @Query('offset') int offset,
    @Query('sort') String sort,
    @Query('order') String order,
  );

  @GET('/channels/{channelId}/videos')
  Future<dynamic> fetchChannelVideos(
    @Path('channelId') String channelId,
    @Query('limit') int limit,
    @Query('status') String status,
    @Query('type') String type,
    @Query('order') String order,
  );

  @GET('/live')
  Future<dynamic> fetchLiveVideos(
    @Query('org') String org,
    @Query('status') String status,
    @Query('type') String type,
    @Query('limit') int limit,
  );
}
