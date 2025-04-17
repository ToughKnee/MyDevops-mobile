import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:mobile/src/auth/auth.dart';

import 'forgot_password_bloc_test.mocks.dart';

@GenerateMocks([ForgotPasswordRepository])
void main() {
  late ForgotPasswordBloc bloc;
  late MockForgotPasswordRepository mockRepository;
  late MockForgotPasswordApi mockApi;

  setUp(() {
    mockRepository = MockForgotPasswordRepository();
    bloc = ForgotPasswordBloc(mockRepository);
    mockApi = MockForgotPasswordApi();
    repository = ForgotPasswordRepositoryImpl(mockApi);
  });

  group('ForgotPasswordBloc', () {
    const email = 'test@example.com';

    blocTest<ForgotPasswordBloc, ForgotPasswordState>(
      'emite [Loading, Success] cuando el envío es exitoso',
      build: () {
        when(mockRepository.sendResetEmail(email)).thenAnswer((_) async {});
        return bloc;
      },
      act: (bloc) => bloc.add(ForgotPasswordSubmitted(email)),
      expect: () => [
        ForgotPasswordLoading(),
        ForgotPasswordSuccess(),
      ],
    );

    blocTest<ForgotPasswordBloc, ForgotPasswordState>(
      'emite [Loading, Failure] cuando el envío falla',
      build: () {
        when(mockRepository.sendResetEmail(email)).thenThrow(Exception('error'));
        return bloc;
      },
      act: (bloc) => bloc.add(ForgotPasswordSubmitted(email)),
      expect: () => [
        ForgotPasswordLoading(),
        isA<ForgotPasswordFailure>(),
      ],
    );
  });
}
