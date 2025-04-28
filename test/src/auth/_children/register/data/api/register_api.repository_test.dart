import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/constants/constants.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/src/auth/auth.dart';

import 'register_api.repository_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late MockClient mockClient;
  late RegisterAPIRepository repository;

  setUp(() {
    mockClient = MockClient();
    repository = RegisterAPIRepository(client: mockClient);
  });

  group('RegisterAPIRepository Tests', () {
    final endpoint = Uri.parse('$API_BASE_URL/user/auth/register');
    final requestHeaders = {'Content-Type': 'application/json'};

    test('should send user data to backend successfully', () async {
      final user = AuthUserInfo(
        name: 'Test User',
        id: 'abc123',
        email: 'test@example.com',
        authProviderToken: 'token123',
      );
      final requestBody = jsonEncode({
        'email': user.email,
        'full_name': user.name,
        'auth_id': user.id,
        'auth_token': user.authProviderToken,
      });

      when(mockClient.post(endpoint, headers: requestHeaders, body: requestBody))
          .thenAnswer((_) async => http.Response('', 201));

      await repository.sendUserToBackend(user);

      verify(mockClient.post(endpoint, headers: requestHeaders, body: requestBody))
          .called(1);
    });

    test('should throw AuthException when backend returns non-201 status', () async {
      final user = AuthUserInfo(
        name: 'Test User',
        id: 'abc123',
        email: 'test@example.com',
        authProviderToken: 'token123',
      );
      final requestBody = jsonEncode({
        'email': user.email,
        'full_name': user.name,
        'auth_id': user.id,
        'auth_token': user.authProviderToken,
      });

      when(mockClient.post(endpoint, headers: requestHeaders, body: requestBody))
          .thenAnswer((_) async => http.Response(
                '{"message": "Registration failed", "details": ["Invalid data"]}',
                400,
              ));

      expect(
        () => repository.sendUserToBackend(user),
        throwsA(
          isA<AuthException>().having(
            (e) => e.message,
            'message',
            'Unexpected error: Registration failed: Invalid data',
          ),
        ),
      );
    });

    test('should throw AuthException when backend response is unauthorized', () async {
      final user = AuthUserInfo(
        name: 'Test User',
        id: 'abc123',
        email: 'test@example.com',
        authProviderToken: 'token123',
      );
      final requestBody = jsonEncode({
        'email': user.email,
        'full_name': user.name,
        'auth_id': user.id,
        'auth_token': user.authProviderToken,
      });

      when(mockClient.post(endpoint, headers: requestHeaders, body: requestBody))
          .thenAnswer((_) async => http.Response('Unauthorized', 401));

      expect(
        () => repository.sendUserToBackend(user),
        throwsA(
          isA<AuthException>().having(
            (e) => e.message,
            'message',
            'Unauthorized: Invalid or missing auth token',
          ),
        ),
      );
    });

    test('should throw AuthException for unexpected errors', () async {
      final user = AuthUserInfo(
        name: 'Test User',
        id: 'abc123',
        email: 'test@example.com',
        authProviderToken: 'token123',
      );
      final requestBody = jsonEncode({
        'email': user.email,
        'full_name': user.name,
        'auth_id': user.id,
        'auth_token': user.authProviderToken,
      });

      when(mockClient.post(endpoint, headers: requestHeaders, body: requestBody))
          .thenThrow(Exception('Unexpected error'));

      expect(
        () => repository.sendUserToBackend(user),
        throwsA(
          isA<AuthException>().having(
            (e) => e.message,
            'message',
            'Unexpected error: Exception: Unexpected error',
          ),
        ),
      );
    });
  });
}
