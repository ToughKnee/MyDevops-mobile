import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:mobile/src/auth/auth.dart';

import 'register_firebase.repository_test.mocks.dart';

@GenerateMocks([firebase.FirebaseAuth, firebase.UserCredential, firebase.User])
void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockUserCredential mockUserCredential;
  late MockUser mockUser;
  late RegisterRepositoryFirebase repository;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockUserCredential = MockUserCredential();
    mockUser = MockUser();
    repository = RegisterRepositoryFirebase(firebaseAuth: mockFirebaseAuth);
  });

  group('Firebase Repository Tests', () {
    test('should use provided FirebaseAuth instance if passed', () {
      final mockAuth = MockFirebaseAuth();

      final repo = RegisterRepositoryFirebase(firebaseAuth: mockAuth);

      expect(repo, isA<RegisterRepositoryFirebase>());
    });

    test('should return AuthUserInfo on successful registration', () async {
      when(
        mockFirebaseAuth.createUserWithEmailAndPassword(
          email: 'test@example.com',
          password: 'password123',
        ),
      ).thenAnswer((_) async => mockUserCredential);

      when(mockUserCredential.user).thenReturn(mockUser);
      when(mockUser.uid).thenReturn('abc123');
      when(mockUser.email).thenReturn('test@example.com');
      when(mockUser.getIdToken()).thenAnswer((_) async => 'token123');

      final result = await repository.register('Test User', 'test@example.com', 'password123');

      expect(result.name, 'Test User');
      expect(result.id, 'abc123');
      expect(result.email, 'test@example.com');
      expect(result.authProviderToken, 'token123');
    });

    test('should throw AuthException when getIdToken returns null', () async {
      when(
        mockFirebaseAuth.createUserWithEmailAndPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      ).thenAnswer((_) async => mockUserCredential);

      when(mockUserCredential.user).thenReturn(mockUser);
      when(mockUser.getIdToken()).thenAnswer((_) async => null);

      expect(
        () => repository.register('Test User', 'email', 'pass'),
        throwsA(
          isA<AuthException>().having(
            (e) => e.message,
            'message',
            'Failed authentication',
          ),
        ),
      );
    });

    test('should throw AuthException when email is already in use', () async {
      when(
        mockFirebaseAuth.createUserWithEmailAndPassword(
          email: 'test@example.com',
          password: 'this-is-a-valid-password',
        ),
      ).thenThrow(firebase.FirebaseAuthException(code: 'email-already-in-use'));

      expect(
        () => repository.register('Test User', 'test@example.com', 'this-is-a-valid-password'),
        throwsA(
          isA<AuthException>().having(
            (e) => e.message,
            'message',
            'Email already in use',
          ),
        ),
      );
    });

    test('should throw AuthException when email has wrong format', () async {
      when(
        mockFirebaseAuth.createUserWithEmailAndPassword(
          email: 'bademail',
          password: 'this-is-a-valid-password',
        ),
      ).thenThrow(firebase.FirebaseAuthException(code: 'invalid-email'));

      expect(
        () => repository.register('Test User', 'bademail', 'this-is-a-valid-password'),
        throwsA(
          isA<AuthException>().having(
            (e) => e.message,
            'message',
            'Invalid email format',
          ),
        ),
      );
    });

    test('should throw AuthException when operation is not allowed', () async {
      when(
        mockFirebaseAuth.createUserWithEmailAndPassword(
          email: 'test@example.com',
          password: 'this-is-a-valid-password',
        ),
      ).thenThrow(firebase.FirebaseAuthException(code: 'operation-not-allowed'));

      expect(
        () => repository.register('Test User', 'test@example.com', 'this-is-a-valid-password'),
        throwsA(
          isA<AuthException>().having(
            (e) => e.message,
            'message',
            'Operation not allowed',
          ),
        ),
      );
    });

    test('should throw AuthException when password is too weak', () async {
      when(
        mockFirebaseAuth.createUserWithEmailAndPassword(
          email: 'test@example.com',
          password: 'weakpass',
        ),
      ).thenThrow(firebase.FirebaseAuthException(code: 'weak-password'));

      expect(
        () => repository.register('Test User', 'test@example.com', 'weakpass'),
        throwsA(
          isA<AuthException>().having(
            (e) => e.message,
            'message',
            'Weak password',
          ),
        ),
      );
    });

    test('should throw AuthException with default message for unknown FirebaseAuthException', () async {
      when(
        mockFirebaseAuth.createUserWithEmailAndPassword(
          email: 'test@example.com',
          password: 'this-is-a-valid-password',
        ),
      ).thenThrow(firebase.FirebaseAuthException(code: 'some-unknown-code'));

      expect(
        () => repository.register('Test User', 'test@example.com', 'this-is-a-valid-password'),
        throwsA(
          isA<AuthException>().having(
            (e) => e.message,
            'message',
            'Failed to register, error: some-unknown-code',
          ),
        ),
      );
    });
  });
}
