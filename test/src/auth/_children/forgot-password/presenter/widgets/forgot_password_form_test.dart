import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:mobile/src/auth/auth.dart';
import 'package:mobile/src/auth/_children/forgot-password/presenter/bloc/forgot_password_bloc.dart';

import 'forgot_password_form_test.mocks.dart';

@GenerateMocks([ForgotPasswordBloc])
void main() {
  late MockForgotPasswordBloc mockBloc;

  setUp(() {
    mockBloc = MockForgotPasswordBloc();
  });

  testWidgets('Formulario muestra botón y campo de texto', (tester) async {
    when(mockBloc.state).thenReturn(ForgotPasswordInitial());

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider<ForgotPasswordBloc>.value(
            value: mockBloc,
            child: const ForgotPasswordForm(),
          ),
        ),
      ),
    );

    expect(find.byType(TextFormField), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('Enviar formulario dispara evento', (tester) async {
    when(mockBloc.state).thenReturn(ForgotPasswordInitial());

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider<ForgotPasswordBloc>.value(
            value: mockBloc,
            child: const ForgotPasswordForm(),
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField), 'test@example.com');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    verify(mockBloc.add(ForgotPasswordSubmitted('test@example.com')))
        .called(1);
  });
}
