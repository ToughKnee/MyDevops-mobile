import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mobile/core/core.dart';
import 'package:mobile/src/auth/auth.dart';

@GenerateMocks([http.Client])
import 'tokens_api.repository_test.mocks.dart';

void main() {
  late MockClient mockClient;
  late TokensRepositoryAPI repository;

  setUp(() {
    mockClient = MockClient();
    repository = TokensRepositoryAPI(client: mockClient);
  });

  group('TokensRepositoryAPI', () {
    final authProviderToken = 'test-auth-provider-token';
    final endpoint = Uri.parse('$API_BASE_URL/user/auth/login');
    final requestHeaders = {'Content-Type': 'application/json'};
    final requestBody = jsonEncode({'authProviderToken': authProviderToken});

    test('should return AuthTokens when API call is successful', () async {
      final responseData = {
        'accessToken': 'test-access-token',
        'refreshToken': 'test-refresh-token',
      };

      when(
        mockClient.post(endpoint, headers: requestHeaders, body: requestBody),
      ).thenAnswer((_) async => http.Response(jsonEncode(responseData), 200));

      final result = await repository.getTokens(authProviderToken);

      expect(result.accessToken, equals('test-access-token'));
      expect(result.refreshToken, equals('test-refresh-token'));
      verify(
        mockClient.post(endpoint, headers: requestHeaders, body: requestBody),
      ).called(1);
    });

    test('should handle null refreshToken in successful response', () async {
      final responseData = {'accessToken': 'test-access-token'};

      when(
        mockClient.post(endpoint, headers: requestHeaders, body: requestBody),
      ).thenAnswer((_) async => http.Response(jsonEncode(responseData), 200));

      final result = await repository.getTokens(authProviderToken);

      expect(result.accessToken, equals('test-access-token'));
      expect(result.refreshToken, equals(''));
    });

    test('should throw AuthException when API returns error', () async {
      final errorResponse = {'message': 'Invalid credentials'};

      when(
        mockClient.post(endpoint, headers: requestHeaders, body: requestBody),
      ).thenAnswer((_) async => http.Response(jsonEncode(errorResponse), 401));

      expect(
        () => repository.getTokens(authProviderToken),
        throwsA(
          isA<AuthException>().having(
            (e) => e.message,
            'message',
            'Unexpected error: Invalid credentials',
          ),
        ),
      );
    });

    test(
      'should use default error message when API error has no message',
      () async {
        when(
          mockClient.post(endpoint, headers: requestHeaders, body: requestBody),
        ).thenAnswer((_) async => http.Response(jsonEncode({}), 500));

        expect(
          () => repository.getTokens(authProviderToken),
          throwsA(
            isA<AuthException>().having(
              (e) => e.message,
              'message',
              'Unexpected error: Authentication failed',
            ),
          ),
        );
      },
    );

    test('should handle "Unauthorized" exception', () async {
      when(
        mockClient.post(endpoint, headers: requestHeaders, body: requestBody),
      ).thenThrow('Unauthorized');

      expect(
        () => repository.getTokens(authProviderToken),
        throwsA(
          isA<AuthException>().having(
            (e) => e.message,
            'message',
            'Unauthorized access',
          ),
        ),
      );
    });

    test('should handle unexpected exceptions', () async {
      when(
        mockClient.post(endpoint, headers: requestHeaders, body: requestBody),
      ).thenThrow(Exception('Network error'));

      expect(
        () => repository.getTokens(authProviderToken),
        throwsA(
          isA<AuthException>().having(
            (e) => e.message,
            'message',
            contains('Unexpected error'),
          ),
        ),
      );
    });
  });
}
