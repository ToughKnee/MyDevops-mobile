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

  setUp(() {
    mockRepository = MockForgotPasswordRepository();
    bloc = ForgotPasswordBloc(mockRepository);
  });

  tearDown(() => bloc.close());

  const email = 'test@ucr.ac.cr';
  const serverMessage = 'Email sent successfully.';

  test('Estado inicial debe ser ForgotPasswordInitial', () {
    expect(bloc.state.runtimeType, ForgotPasswordInitial);
  });

  blocTest<ForgotPasswordBloc, ForgotPasswordState>(
    'Emite [Loading, Success] cuando el envío es exitoso',
    build: () {
      when(mockRepository.sendResetEmail(email)).thenAnswer((_) async => serverMessage);
      return ForgotPasswordBloc(mockRepository);
    },
    act: (bloc) => bloc.add(ForgotPasswordSubmitted(email)),
    expect: () => [
      isA<ForgotPasswordLoading>(),
      isA<ForgotPasswordSuccess>(),
    ],
    verify: (_) {
      verify(mockRepository.sendResetEmail(email)).called(1);
    },
  );

  blocTest<ForgotPasswordBloc, ForgotPasswordState>(
    'Emite [Loading, Failure] cuando el envío falla',
    build: () {
      when(mockRepository.sendResetEmail(email)).thenThrow(Exception('Error'));
      return ForgotPasswordBloc(mockRepository);
    },
    act: (bloc) => bloc.add(ForgotPasswordSubmitted(email)),
    expect: () => [
      isA<ForgotPasswordLoading>(),
      isA<ForgotPasswordFailure>(),
    ],
    verify: (_) {
      verify(mockRepository.sendResetEmail(email)).called(1);
    },
  );
}
