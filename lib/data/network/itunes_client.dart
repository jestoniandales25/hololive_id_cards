import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'itunes_client.g.dart';

@RestApi(baseUrl: 'https://itunes.apple.com')
abstract class ItunesClient {
  factory ItunesClient(Dio dio, {String baseUrl}) = _ItunesClient;

  @GET('/search')
  Future<dynamic> fetchItunesSongs(
    @Query('term') String term,
    @Query('media') String media,
    @Query('entity') String entity,
    @Query('country') String country,
    @Query('limit') int limit,
  );
}
