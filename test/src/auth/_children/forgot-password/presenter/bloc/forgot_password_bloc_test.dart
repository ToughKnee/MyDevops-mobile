import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';

import 'package:mobile/src/auth/auth.dart';
import 'package:mobile/src/auth/_children/forgot-password/presenter/bloc/forgot_password_bloc.dart';

import 'forgot_password_bloc_test.mocks.dart';

@GenerateMocks([ForgotPasswordRepository])
void main() {
  late ForgotPasswordBloc bloc;
  late MockForgotPasswordRepository mockRepository;

  setUp(() {
    mockRepository = MockForgotPasswordRepository();
    bloc = ForgotPasswordBloc(mockRepository);
  });

  const email = 'usuario@ucr.ac.cr';

  test('Estado inicial debe ser ForgotPasswordInitial', () {
    expect(bloc.state, ForgotPasswordInitial());
  });

  blocTest<ForgotPasswordBloc, ForgotPasswordState>(
    'Emite [Loading, Success] cuando el envío es exitoso',
    build: () {
      when(mockRepository.sendResetEmail(email)).thenAnswer((_) async => Future.value());
      return bloc;
    },
    act: (bloc) => bloc.add(ForgotPasswordSubmitted(email)),
    expect: () => [
      ForgotPasswordLoading(),
      ForgotPasswordSuccess(),
    ],
    verify: (_) {
      verify(mockRepository.sendResetEmail(email)).called(1);
    },
  );

  blocTest<ForgotPasswordBloc, ForgotPasswordState>(
    'Emite [Loading, Failure] cuando el envío falla',
    build: () {
      when(mockRepository.sendResetEmail(email)).thenThrow(Exception('Error inesperado'));
      return bloc;
    },
    act: (bloc) => bloc.add(ForgotPasswordSubmitted(email)),
    expect: () => [
      ForgotPasswordLoading(),
      isA<ForgotPasswordFailure>(),
    ],
    verify: (_) {
      verify(mockRepository.sendResetEmail(email)).called(1);
    },
  );
}
