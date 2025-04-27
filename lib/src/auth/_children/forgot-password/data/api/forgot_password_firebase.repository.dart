import 'dart:convert';
import 'package:http/http.dart' as http;

class ForgotPasswordApi {
  final String _endpoint = 'http://157.230.224.13:3000/api/recover-password';
  final http.Client _client;

  ForgotPasswordApi({http.Client? client}) : _client = client ?? http.Client();

  Future<String> sendPasswordResetEmail(String email) async {
    final response = await _client.post(
      Uri.parse(_endpoint),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['message'] ?? 'Recovery email sent successfully';
    } else {
      final json = jsonDecode(response.body);
      throw Exception(json['error'] ?? 'No se logró enviar el correo de recuperación.');
    }
  }
}
