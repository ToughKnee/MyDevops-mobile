import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/core.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';

@GenerateMocks([SharedPreferences])
import 'user_session.storage_test.mocks.dart';

void main() {
  group('LocalStorage Tests', () {
    late MockSharedPreferences mockPrefs;
    late LocalStorage storage;

    setUp(() {
      mockPrefs = MockSharedPreferences();
      storage = LocalStorage.withPrefs(mockPrefs);
    });

    tearDown(() {
      // Reset the instance after each test
      LocalStorage.resetInstance();
    });

    test('should throw exception when accessed before initialization', () {
      LocalStorage.resetInstance();
      expect(() => LocalStorage(), throwsException);
    });

    test('init should create the singleton instance', () async {
      SharedPreferences.setMockInitialValues({});

      final instance = await LocalStorage.init();
      final factoryInstance = LocalStorage();

      expect(factoryInstance, same(instance));
    });

    test('should save and retrieve access token', () {
      const testToken = 'abc123';

      // 1. Stub the method setString to simulate saving the token and return true
      // This is necessary because setString is an async method.

      // when: Indicate to Mockito that we are waiting for setString to be called
      // thenAnswer: Indicate to Mockito that we want to return true when setString is called
      // because setString is an async method, we need to use thenAnswer to simulate it as successful
      when(
        mockPrefs.setString('accessToken', testToken),
      ).thenAnswer((_) async => true);

      // 2. Stub the method getString to simulate retrieving the token
      // Indicates to Mockito that we want to return testToken when getString is called
      // with the key 'accessToken'
      when(mockPrefs.getString('accessToken')).thenReturn(testToken);

      // 3. Now we can set the access token
      storage.accessToken = testToken;

      // 4. Get the access token from the storage
      final result = storage.accessToken;

      // 5. Verify that setString was called with the correct arguments
      // and was called exactly once, if not, it will throw an error
      verify(mockPrefs.setString('accessToken', testToken)).called(1);

      // compare the token retrieved from the storage with the test token
      expect(result, equals(testToken));
    });

    test('should save and retrieve refresh token', () {
      const testToken = 'xyz789';

      when(
        mockPrefs.setString('refreshToken', testToken),
      ).thenAnswer((_) async => true);

      when(mockPrefs.getString('refreshToken')).thenReturn(testToken);

      storage.refreshToken = testToken;

      final result = storage.refreshToken;

      verify(mockPrefs.setString('refreshToken', testToken)).called(1);
      expect(result, equals(testToken));
    });
    test('should save and retrieve user ID', () {
      const testId = 'user123';

      when(mockPrefs.setString('userId', testId)).thenAnswer((_) async => true);

      when(mockPrefs.getString('userId')).thenReturn(testId);

      storage.userId = testId;

      final result = storage.userId;

      verify(mockPrefs.setString('userId', testId)).called(1);
      expect(result, equals(testId));
    });

    test('should save and retrieve username', () {
      const testUsername = 'testUser';

      when(
        mockPrefs.setString('username', testUsername),
      ).thenAnswer((_) async => true);

      when(mockPrefs.getString('username')).thenReturn(testUsername);

      storage.username = testUsername;

      final result = storage.username;

      verify(mockPrefs.setString('username', testUsername)).called(1);
      expect(result, equals(testUsername));
    });

    test('should save and retrieve email', () {
      const testEmail = 'user@ucr.ac.cr';

      when(
        mockPrefs.setString('userEmail', testEmail),
      ).thenAnswer((_) async => true);

      when(mockPrefs.getString('userEmail')).thenReturn(testEmail);

      storage.userEmail = testEmail;

      final result = storage.userEmail;

      verify(mockPrefs.setString('userEmail', testEmail)).called(1);

      expect(result, equals(testEmail));
    });

    test(
      'isLoggedIn should return true when accessToken and userId are not empty',
      () {
        const testToken = 'abc123';
        const testUserId = 'user123';

        when(mockPrefs.getString('accessToken')).thenReturn(testToken);
        when(mockPrefs.getString('userId')).thenReturn(testUserId);

        final result = storage.isLoggedIn;
        expect(result, isTrue);
      },
    );

    test(
      'isLoggedIn should return false when accessToken or userId are empty',
      () {
        const testToken = '';
        const testUserId = 'user123';

        when(mockPrefs.getString('accessToken')).thenReturn(testToken);
        when(mockPrefs.getString('userId')).thenReturn(testUserId);

        final result = storage.isLoggedIn;
        expect(result, isFalse);
      },
    );

    test('should clear all stored data', () async {
      const testToken = 'abc123';

      when(
        mockPrefs.setString('accessToken', testToken),
      ).thenAnswer((_) async => true);

      when(mockPrefs.getString('accessToken')).thenReturn(testToken);

      storage.accessToken = testToken;

      expect(storage.accessToken, equals(testToken));

      when(mockPrefs.clear()).thenAnswer((_) async => true);

      await storage.clear();

      when(mockPrefs.getString('accessToken')).thenReturn(null);

      expect(storage.accessToken, equals(''));

      verify(mockPrefs.clear()).called(1);
    });
  });
}
