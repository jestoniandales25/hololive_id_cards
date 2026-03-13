import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'HOLODEX_API_KEY', obfuscate: true)
  static final String holodexApiKey = _Env.holodexApiKey;

  static const String holodexBaseUrl = 'https://holodex.net/api/v2';
}
