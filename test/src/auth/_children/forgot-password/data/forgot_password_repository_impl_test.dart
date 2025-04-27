import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

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

  test('sendResetEmail llama a sendPasswordResetEmail del API', () async {
    const email = 'test@ucr.ac.cr';
    const serverResponse = 'Recovery mail sent successfully.';

    when(mockApi.sendPasswordResetEmail(email)).thenAnswer((_) async => serverResponse);

    final result = await repository.sendResetEmail(email);

    expect(result, equals(serverResponse));
    verify(mockApi.sendPasswordResetEmail(email)).called(1);
  });
}
