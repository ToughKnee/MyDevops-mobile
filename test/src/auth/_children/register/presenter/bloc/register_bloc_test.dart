import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:mobile/src/auth/auth.dart';

@GenerateMocks([RegisterRepository, RegisterAPIRepository])
import 'register_bloc_test.mocks.dart';

void main() {
  late MockRegisterRepository mockRegisterRepository;
  late MockRegisterAPIRepository mockRegisterAPIRepository;
  late RegisterBloc registerBloc;
  
  final testUser = AuthUserInfo(
    name: 'Test User',
    id: 'test-user-id',
    email: 'user@test.com',
    authProviderToken: 'token123',
  );

  setUp(() async {
    mockRegisterRepository = MockRegisterRepository();
    mockRegisterAPIRepository = MockRegisterAPIRepository();

    registerBloc = RegisterBloc(
      registerRepository: mockRegisterRepository,
      registerAPIRepository: mockRegisterAPIRepository,
    );
  });

  tearDown(() {
    registerBloc.close();
  });

  group('RegisterBloc', () {
    test('initial state of register bloc should be RegisterInitial', () {
      expect(registerBloc.state, isA<RegisterInitial>());
    });

    test('registerSubmitted event should be equatable', () {
      const eventA = RegisterSubmitted(name: 'Test User', email: 'email', password: 'pass');
      const eventB = RegisterSubmitted(name: 'Test User', email: 'email', password: 'pass');
      const eventC = RegisterSubmitted(name: 'Other Test User', email: 'email', password: 'pass');

      expect(eventA, equals(eventB));
      expect(eventA == eventB, isTrue);
      expect(eventA == eventC, isFalse);
    });

        blocTest<RegisterBloc, RegisterState>(
      'should emit [RegisterLoading, RegisterSuccess] when register is successful',

      build: () {
        when(
          mockRegisterRepository.register('Test User', 'user@test.com', 'password'),
        ).thenAnswer((_) async => testUser);
        return registerBloc;
      },

      act:
          (bloc) => bloc.add(
            const RegisterSubmitted(
              name: 'Test User',
              email: 'user@test.com',
              password: 'password',
            ),
          ),

      expect: () => [
        isA<RegisterLoading>(),
        isA<RegisterSuccess>().having((state) => state.user, 'user', testUser),
      ],

      verify: (bloc) {
        verify(
          mockRegisterRepository.register('Test User', 'user@test.com', 'password'),
        ).called(1);
      },
    );

    blocTest<RegisterBloc, RegisterState>(
      'should emit [RegisterLoading, RegisterFailure] when a register throws "Email already in use"',

      build: () {
        when(
          mockRegisterRepository.register('Test User', 'email_already_registered', 'pass'),
        ).thenThrow(AuthException('Email already in use'));
        return registerBloc;
      },

      act:
          (bloc) => bloc.add(
            const RegisterSubmitted(
              name: 'Test User',
              email: 'email_already_registered',
              password: 'pass',
            ),
          ),

      expect: () => [isA<RegisterLoading>(), isA<RegisterFailure>()],

      verify: (bloc) {
        verify(
          mockRegisterRepository.register('Test User', 'email_already_registered', 'pass'),
        ).called(1);

        expect(
          bloc.state,
          isA<RegisterFailure>().having(
            (state) => state.error,
            'error',
            'This email is already registered. Please log in or reset your password.',
          ),
        );
      },
    );

    blocTest<RegisterBloc, RegisterState>(
      'should emit [RegisterLoading, RegisterFailure] when a register throws "Invalid email format"',

      build: () {
        when(
          mockRegisterRepository.register('Test User', 'invalid_email_format', 'pass'),
        ).thenThrow(AuthException('Invalid email format'));
        return registerBloc;
      },

      act:
          (bloc) => bloc.add(
            const RegisterSubmitted(
              name: 'Test User',
              email: 'invalid_email_format',
              password: 'pass',
            ),
          ),

      expect: () => [isA<RegisterLoading>(), isA<RegisterFailure>()],

      verify: (bloc) {
        verify(
          mockRegisterRepository.register('Test User', 'invalid_email_format', 'pass'),
        ).called(1);

        expect(
          bloc.state,
          isA<RegisterFailure>().having(
            (state) => state.error,
            'error',
            'The email address is not valid.',
          ),
        );
      },
    );

    blocTest<RegisterBloc, RegisterState>(
      'should emit [RegisterLoading, RegisterFailure] when a register throws "Weak password"',

      build: () {
        when(
          mockRegisterRepository.register('Test User', 'email', 'weak_pass'),
        ).thenThrow(AuthException('Weak password'));
        return registerBloc;
      },

      act:
          (bloc) => bloc.add(
            const RegisterSubmitted(
              name: 'Test User',
              email: 'email',
              password: 'weak_pass',
            ),
          ),

      expect: () => [isA<RegisterLoading>(), isA<RegisterFailure>()],

      verify: (bloc) {
        verify(
          mockRegisterRepository.register('Test User', 'email', 'weak_pass'),
        ).called(1);

        expect(
          bloc.state,
          isA<RegisterFailure>().having(
            (state) => state.error,
            'error',
            'The password is too weak. Please choose a stronger one.',
          ),
        );
      },
    );

    blocTest<RegisterBloc, RegisterState>(
      'should emit [RegisterLoading, RegisterFailure] when a register throws an unexpected error',

      build: () {
        when(
          mockRegisterRepository.register('Test User', 'email', 'pass'),
        ).thenThrow(Exception('Unexpected error'));
        return registerBloc;
      },

      act:
          (bloc) => bloc.add(
            const RegisterSubmitted(
              name: 'Test User',
              email: 'email',
              password: 'pass',
            ),
          ),

      expect: () => [isA<RegisterLoading>(), isA<RegisterFailure>()],

      verify: (bloc) {
        verify(
          mockRegisterRepository.register('Test User', 'email', 'pass'),
        ).called(1);

        expect(
          bloc.state,
          isA<RegisterFailure>().having(
            (state) => state.error,
            'error',
            'Unexpected error',
          ),
        );
      },
    );

    blocTest<RegisterBloc, RegisterState>(
      'should emit [RegisterLoading, RegisterFailure] when a register throws a generic AuthException',

      build: () {
        when(
          mockRegisterRepository.register('Test User', 'email', 'pass'),
        ).thenThrow(AuthException('Generic error message'));
        return registerBloc;
      },

      act:
          (bloc) => bloc.add(
            const RegisterSubmitted(
              name: 'Test User',
              email: 'email',
              password: 'pass',
            ),
          ),

      expect: () => [isA<RegisterLoading>(), isA<RegisterFailure>()],

      verify: (bloc) {
        verify(
          mockRegisterRepository.register('Test User', 'email', 'pass'),
        ).called(1);

        expect(
          bloc.state,
          isA<RegisterFailure>().having(
            (state) => state.error,
            'error',
            'Generic error message',
          ),
        );
      },
    );
  });
}