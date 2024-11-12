import 'package:envied/envied.dart';

part 'api_config.g.dart';

@Envied(path: '.env.prod')
abstract class ApiConfig {
  @EnviedField(varName: 'API_KEY',obfuscate: true)
  static final String apiKey = _ApiConfig.apiKey;
  @EnviedField(varName: 'ONE_SIGNAL_ID',obfuscate: true)
  static final String oneSignalId = _ApiConfig.oneSignalId;
}