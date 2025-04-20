import 'dart:convert';
import 'package:mobile/core/core.dart';
import 'package:mobile/src/auth/auth.dart';
import 'package:http/http.dart' as http;

class TokensRepositoryAPI implements TokensRepository {
  final http.Client client;

  TokensRepositoryAPI({http.Client? client}) : client = client ?? http.Client();

  @override
  Future<AuthTokens> getTokens(String authProviderToken) async {
    try {
      final response = await client.post(
        Uri.parse('$API_BASE_URL/user/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'authProviderToken': authProviderToken}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return AuthTokens(
          accessToken: data['accessToken'],
          refreshToken: data['refreshToken'] ?? '',
        );
      } else {
        throw AuthException(data['message'] ?? 'Authentication failed');
      }
    } catch (e) {
      if (e.toString().contains('Unauthorized')) {
        throw AuthException('Unauthorized access');
      }
      throw AuthException('Unexpected error: $e');
    }
  }
}
