import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:mobile/src/auth/auth.dart';

import 'login_firebase.repository_test.mocks.dart';

@GenerateMocks([firebase.FirebaseAuth, firebase.UserCredential, firebase.User])
void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockUserCredential mockUserCredential;
  late MockUser mockUser;
  late LoginRepositoryFirebase repository;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockUserCredential = MockUserCredential();
    mockUser = MockUser();
    repository = LoginRepositoryFirebase(firebaseAuth: mockFirebaseAuth);
  });

  group('Firebase Repository Tests', () {
    test('should use provided FirebaseAuth instance if passed', () {
      final mockAuth = MockFirebaseAuth();

      final repo = LoginRepositoryFirebase(firebaseAuth: mockAuth);

      expect(repo, isA<LoginRepositoryFirebase>());
    });

    test('should return AuthUserInfo on successful login', () async {
      when(
        mockFirebaseAuth.signInWithEmailAndPassword(
          email: 'test@example.com',
          password: 'password123',
        ),
      ).thenAnswer((_) async => mockUserCredential);

      when(mockUserCredential.user).thenReturn(mockUser);
      when(mockUser.uid).thenReturn('abc123');
      when(mockUser.email).thenReturn('test@example.com');
      when(mockUser.getIdToken()).thenAnswer((_) async => 'token123');

      final result = await repository.login('test@example.com', 'password123');

      expect(result.id, 'abc123');
      expect(result.email, 'test@example.com');
      expect(result.authProviderToken, 'token123');
    });

    test('should throw AuthException when getIdToken returns null', () async {
      when(
        mockFirebaseAuth.signInWithEmailAndPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      ).thenAnswer((_) async => mockUserCredential);

      when(mockUserCredential.user).thenReturn(mockUser);
      when(mockUser.getIdToken()).thenAnswer((_) async => null);

      expect(
        () => repository.login('email', 'pass'),
        throwsA(
          isA<AuthException>().having(
            (e) => e.message,
            'message',
            'Failed authentication',
          ),
        ),
      );
    });

    test('should throw AuthException when email has wrong format', () async {
      when(
        mockFirebaseAuth.signInWithEmailAndPassword(
          email: 'bademail',
          password: 'pass',
        ),
      ).thenThrow(firebase.FirebaseAuthException(code: 'invalid-email'));

      expect(
        () => repository.login('bademail', 'pass'),
        throwsA(
          isA<AuthException>().having(
            (e) => e.message,
            'message',
            'Invalid email format',
          ),
        ),
      );
    });

    test('should throw AuthException when credentials are incorrect', () async {
      when(
        mockFirebaseAuth.signInWithEmailAndPassword(
          email: 'email',
          password: 'pass',
        ),
      ).thenThrow(firebase.FirebaseAuthException(code: 'invalid-credential'));

      expect(
        () => repository.login('email', 'pass'),
        throwsA(
          isA<AuthException>().having(
            (e) => e.message,
            'message',
            'Incorrect credentials',
          ),
        ),
      );
    });

    test('should throw AuthException user is not found', () async {
      when(
        mockFirebaseAuth.signInWithEmailAndPassword(
          email: 'email',
          password: 'pass',
        ),
      ).thenThrow(firebase.FirebaseAuthException(code: 'user-not-found'));

      expect(
        () => repository.login('email', 'pass'),
        throwsA(
          isA<AuthException>().having(
            (e) => e.message,
            'message',
            'User not found',
          ),
        ),
      );
    });

    test('should throw AuthException for other errors', () async {
      when(
        mockFirebaseAuth.signInWithEmailAndPassword(
          email: 'email',
          password: 'pass',
        ),
      ).thenThrow(firebase.FirebaseAuthException(code: 'other-error'));

      expect(
        () => repository.login('email', 'pass'),
        throwsA(
          isA<AuthException>().having(
            (e) => e.message,
            'message',
            'failed, error: other-error',
          ),
        ),
      );
    });
  });
}
