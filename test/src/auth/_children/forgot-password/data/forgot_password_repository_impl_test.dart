import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile/src/auth/auth.dart';

import 'forgot_password_repository_impl_test.mocks.dart';

@GenerateMocks([ForgotPasswordApi])
void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late ForgotPasswordRepositoryImpl repository;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    repository = ForgotPasswordRepositoryImpl(mockFirebaseAuth);
  });

  group('ForgotPasswordRepositoryImpl', () {
    const email = 'test@example.com';

    test('envía el email de recuperación exitosamente', () async {
      when(mockFirebaseAuth.sendPasswordResetEmail(email: email))
          .thenAnswer((_) async {});

      await repository.sendResetEmail(email);

      verify(mockFirebaseAuth.sendPasswordResetEmail(email: email)).called(1);
    });

    test('lanza excepción si Firebase falla', () async {
      when(mockFirebaseAuth.sendPasswordResetEmail(email: email))
          .thenThrow(FirebaseAuthException(code: 'user-not-found'));

      expect(() => repository.sendResetEmail(email), throwsException);
    });
  });
}
