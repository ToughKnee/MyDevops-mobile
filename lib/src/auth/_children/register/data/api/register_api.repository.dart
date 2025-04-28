import 'dart:convert';
import 'package:mobile/core/core.dart';
import 'package:mobile/src/auth/auth.dart';
import 'package:http/http.dart' as http;

class RegisterAPIRepository {
  final http.Client client;

  RegisterAPIRepository({http.Client? client})
      : client = client ?? http.Client();

  Future<void> sendUserToBackend(AuthUserInfo user) async {
    try {
      final response = await client.post(
        Uri.parse('$API_BASE_URL/user/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': user.email,
          'full_name': user.name,
          'auth_id': user.id,
          'auth_token': user.authProviderToken,
        }),
      );

      if (response.statusCode == 201) return;

      final data = jsonDecode(response.body);
      final message = data['message'] ?? 'Registration failed';
      final details = (data['details'] as List?)?.join(', ');

      throw AuthException('$message${details != null ? ': $details' : ''}');
    } catch (e) {
      if (e.toString().contains('Unauthorized')) {
        throw AuthException('Unauthorized: Invalid or missing auth token');
      }
      throw AuthException('Unexpected error: $e');
    }
  }
}
