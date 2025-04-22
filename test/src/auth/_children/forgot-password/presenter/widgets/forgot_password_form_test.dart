import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';

import 'package:mobile/src/auth/_children/forgot-password/presenter/widgets/forgot_password_form.dart';
import 'package:mobile/src/auth/_children/forgot-password/presenter/bloc/forgot_password_bloc.dart';

import 'forgot_password_form_test.mocks.dart';

@GenerateMocks([ForgotPasswordBloc])
void main() {
  late MockForgotPasswordBloc mockBloc;

  setUp(() {
    mockBloc = MockForgotPasswordBloc();
    when(mockBloc.state).thenReturn(ForgotPasswordInitial());
    when(mockBloc.stream).thenAnswer((_) => Stream.empty());
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: Scaffold(
        body: BlocProvider<ForgotPasswordBloc>.value(
          value: mockBloc,
          child: const ForgotPasswordForm(),
        ),
      ),
    );
  }

  testWidgets('Renderiza el formulario con campo y botón', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    expect(find.byType(TextFormField), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('Correo inválido muestra diálogo y limpia campo', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    final textField = find.byType(TextFormField);
    await tester.enterText(textField, 'correo@gmail.com');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // Verifica mensaje específico
    expect(find.text('Invalid Email'), findsOneWidget);
    expect(find.text('Please enter a valid email address from the @ucr.ac.cr domain'), findsOneWidget);
    expect((tester.widget(textField) as TextFormField).controller!.text, '');
  });

  testWidgets('Correo válido dispara evento ForgotPasswordSubmitted', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    final textField = find.byType(TextFormField);
    await tester.enterText(textField, 'user@ucr.ac.cr');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    verify(mockBloc.add(ForgotPasswordSubmitted('user@ucr.ac.cr'))).called(1);
  });

  testWidgets('ForgotPasswordSuccess muestra diálogo y se cierra tras 3 segundos', (tester) async {
    when(mockBloc.stream).thenAnswer((_) => Stream.value(ForgotPasswordSuccess()));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump(); // recibe el estado del stream

    expect(find.text('Recovery mail sent successfully.'), findsOneWidget);

    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('ForgotPasswordFailure muestra diálogo de error', (tester) async {
    when(mockBloc.stream).thenAnswer((_) => Stream.value(ForgotPasswordFailure('Algo salió mal')));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.text('Algo salió mal'), findsOneWidget);
    expect(find.text('Error'), findsOneWidget);
  });

  testWidgets('Aceptar en el diálogo de éxito regresa a pantalla anterior', (tester) async {
    mockBloc = MockForgotPasswordBloc();
    when(mockBloc.state).thenReturn(ForgotPasswordInitial());
    when(mockBloc.stream).thenAnswer((_) => Stream.value(ForgotPasswordSuccess()));

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => BlocProvider<ForgotPasswordBloc>.value(
                      value: mockBloc,
                      child: const ForgotPasswordForm(),
                    ),
                  ),
                );
              },
              child: const Text('Ir a recuperación'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Ir a recuperación'));
    await tester.pumpAndSettle();
    await tester.pump();

    expect(find.text('Recovery mail sent successfully.'), findsOneWidget);

    await tester.tap(find.text('Accept'));
    await tester.pumpAndSettle();

    // Verificamos que regresó a la pantalla anterior
    expect(find.text('Ir a recuperación'), findsOneWidget);
  });
}
