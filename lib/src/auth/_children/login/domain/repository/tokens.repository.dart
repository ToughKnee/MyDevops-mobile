import 'package:mobile/src/auth/auth.dart';

abstract class TokensRepository {
  Future<AuthTokens> getTokens(String authProviderToken);
}
