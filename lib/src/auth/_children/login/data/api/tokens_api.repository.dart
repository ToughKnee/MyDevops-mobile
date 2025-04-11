import 'dart:convert';
import 'package:mobile/core/core.dart';
import 'package:mobile/src/auth/auth.dart';
import 'package:http/http.dart' as http;

// TODO: Adjust to backend API
class TokensRepositoryAPI implements TokensRepository {
  @override
  Future<AuthTokens> getTokens(String authProviderToken) async {
    try {
      final response = await http.post(
        Uri.parse('$API_BASE_URL/auth/login'),
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
      throw AuthException('Failed to get tokens: $e');
    }
  }
}
