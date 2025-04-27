import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/src/auth/_children/forgot-password/data/api/forgot_password_firebase.repository.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'forgot_password_firebase.repository_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late MockClient mockHttpClient;
  late ForgotPasswordApi forgotPasswordApi;

  setUp(() {
    mockHttpClient = MockClient();
    forgotPasswordApi = ForgotPasswordApi(client: mockHttpClient);
  });

  group('ForgotPasswordApi', () {
    test('devuelve mensaje si el POST es exitoso', () async {
      when(mockHttpClient.post(
        Uri.parse('http://157.230.224.13:3000/api/recover-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': 'correo@ucr.ac.cr'}),
      )).thenAnswer((_) async => http.Response(jsonEncode({'message': 'Correo enviado'}), 200));

      final result = await forgotPasswordApi.sendPasswordResetEmail('correo@ucr.ac.cr');

      expect(result, 'Correo enviado');
    });

    test('lanza excepción si el POST falla', () async {
      when(mockHttpClient.post(
        Uri.parse('http://157.230.224.13:3000/api/recover-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': 'correo@ucr.ac.cr'}),
      )).thenAnswer((_) async => http.Response(jsonEncode({'error': 'Error al enviar'}), 400));

      expect(
        () async => await forgotPasswordApi.sendPasswordResetEmail('correo@ucr.ac.cr'),
        throwsA(isA<Exception>()),
      );
    });
  });
}
