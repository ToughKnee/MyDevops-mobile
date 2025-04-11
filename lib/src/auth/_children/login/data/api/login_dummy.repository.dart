// see https://dummyjson.com/docs/auth

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile/src/auth/auth.dart';

class LoginRepositoryDummy implements LoginRepository {
  @override
  Future<AuthUserInfo> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('https://dummyjson.com/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return AuthUserInfo(
          id: data['id'].toString(),
          email: data['email'],
          authProviderToken: data['username'],
        );
      } else {
        throw AuthException(data['message'] ?? 'Authentication failed');
      }
    } catch (e) {
      rethrow;
    }
  }
}
