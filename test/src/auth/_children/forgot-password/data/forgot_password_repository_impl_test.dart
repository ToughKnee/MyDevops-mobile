import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:mobile/src/auth/auth.dart';

import 'forgot_password_repository_impl_test.mocks.dart';

@GenerateMocks([ForgotPasswordApi])
void main() {
  late MockForgotPasswordApi mockApi;
  late ForgotPasswordRepositoryImpl repository;

  setUp(() {
    mockApi = MockForgotPasswordApi();
    repository = ForgotPasswordRepositoryImpl(mockApi);
  });

  test('sendResetEmail llama al método del API', () async {
    const email = 'test@ucr.ac.cr';

    // Simular que el método se ejecuta correctamente
    when(mockApi.sendPasswordResetEmail(email)).thenAnswer((_) async {});

    await repository.sendResetEmail(email);

    // Verificar que se llamó correctamente
    verify(mockApi.sendPasswordResetEmail(email)).called(1);
  });
}
