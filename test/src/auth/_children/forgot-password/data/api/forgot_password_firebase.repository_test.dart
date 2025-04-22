import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:mobile/src/auth/_children/forgot-password/data/api/forgot_password_firebase.repository.dart';

import 'forgot_password_firebase.repository_test.mocks.dart';

@GenerateMocks([FirebaseAuth])
void main() {
  late MockFirebaseAuth mockAuth;

  setUp(() {
    mockAuth = MockFirebaseAuth();
  });

  test('sendPasswordResetEmail llama al método de FirebaseAuth', () async {
    const email = 'test@ucr.ac.cr';
    final api = ForgotPasswordApi(auth: mockAuth);

    when(mockAuth.sendPasswordResetEmail(email: email)).thenAnswer((_) async {});

    await api.sendPasswordResetEmail(email);

    verify(mockAuth.sendPasswordResetEmail(email: email)).called(1);
  });
}
