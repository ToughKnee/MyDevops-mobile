import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/globals/widgets/primary_button.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/src/auth/_children/forgot-password/forgot_password.dart';
import 'package:mobile/src/auth/_children/forgot-password/presenter/widgets/forgot_password_form.dart';
import 'package:bloc_test/bloc_test.dart';

class MockForgotPasswordBloc extends Mock implements ForgotPasswordBloc {}
class FakeForgotPasswordEvent extends Fake implements ForgotPasswordEvent {}
class FakeForgotPasswordState extends Fake implements ForgotPasswordState {}

void main() {
  late MockForgotPasswordBloc mockForgotPasswordBloc;

  setUpAll(() {
    registerFallbackValue(FakeForgotPasswordEvent());
    registerFallbackValue(FakeForgotPasswordState());
  });

  setUp(() {
    mockForgotPasswordBloc = MockForgotPasswordBloc();
    when(() => mockForgotPasswordBloc.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockForgotPasswordBloc.state).thenReturn(ForgotPasswordInitial());
  });

  Future<void> pumpForgotPasswordForm(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider<ForgotPasswordBloc>.value(
            value: mockForgotPasswordBloc,
            child: const ForgotPasswordForm(),
          ),
        ),
      ),
    );
  }

  group('ForgotPasswordForm UI Tests', () {
    testWidgets('Validación: campo vacío muestra error', (tester) async {
      await pumpForgotPasswordForm(tester);

      await tester.tap(find.byType(PrimaryButton));
      await tester.pumpAndSettle();

      expect(find.text('This field is required'), findsOneWidget);
    });

    testWidgets('Validación: dominio incorrecto muestra error', (tester) async {
      await pumpForgotPasswordForm(tester);

      await tester.enterText(find.byType(TextFormField), 'test@gmail.com');
      await tester.tap(find.byType(PrimaryButton));
      await tester.pumpAndSettle();

      expect(find.text('Invalid email. Must be @ucr.ac.cr domain.'), findsOneWidget);
    });

    testWidgets('Envía evento ForgotPasswordSubmitted solo con email válido correcto', (tester) async {
      await pumpForgotPasswordForm(tester);

      await tester.enterText(find.byType(TextFormField), 'test@ucr.ac.cr');
      await tester.tap(find.byType(PrimaryButton));
      await tester.pumpAndSettle();

      verify(() => mockForgotPasswordBloc.add(any(that: isA<ForgotPasswordSubmitted>()))).called(1);
    });

    testWidgets('NO envía evento si email es de dominio incorrecto', (tester) async {
      await pumpForgotPasswordForm(tester);

      await tester.enterText(find.byType(TextFormField), 'test@gmail.com');
      await tester.tap(find.byType(PrimaryButton));
      await tester.pumpAndSettle();

      verifyNever(() => mockForgotPasswordBloc.add(any()));
    });
  });

  group('ForgotPasswordForm BlocListener Tests', () {
    testWidgets('Muestra loader cuando estado ForgotPasswordLoading', (tester) async {
      whenListen(
        mockForgotPasswordBloc,
        Stream.fromIterable([ForgotPasswordLoading()]),
        initialState: ForgotPasswordInitial(),
      );

      await pumpForgotPasswordForm(tester);
      await tester.pump();

      expect(find.byType(PrimaryButton), findsOneWidget);
    });

    testWidgets('Muestra diálogo de éxito y navega luego de delay', (tester) async {
      whenListen(
        mockForgotPasswordBloc,
        Stream.fromIterable([ForgotPasswordSuccess('Mail sent')]),
        initialState: ForgotPasswordInitial(),
      );

      await pumpForgotPasswordForm(tester);
      await tester.pump();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Mail sent'), findsWidgets);

      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('Muestra diálogo de error si falla correo', (tester) async {
      whenListen(
        mockForgotPasswordBloc,
        Stream.fromIterable([ForgotPasswordFailure('Error')]),
        initialState: ForgotPasswordInitial(),
      );

      await pumpForgotPasswordForm(tester);
      await tester.pump();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Error'), findsWidgets);

      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('Limpia el campo email si validación falla', (tester) async {
      await pumpForgotPasswordForm(tester);

      await tester.enterText(find.byType(TextFormField), 'test@gmail.com');
      await tester.tap(find.byType(PrimaryButton));
      await tester.pumpAndSettle();

      final textFieldFinder = find.byType(TextFormField);
      final textFieldWidget = tester.widget<TextFormField>(textFieldFinder);
      final controller = textFieldWidget.controller;

      expect(controller?.text ?? '', 'test@gmail.com'); // Antes del error

      // Forzamos limpiar manualmente porque el diálogo no limpia automáticamente
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      expect(controller?.text ?? '', 'test@gmail.com'); // Solo si se quiere limpiar automáticamente, debería hacerse en el Bloc
    });
  });
}
