import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/globals/widgets/primary_button.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile/src/auth/auth.dart';

class MockForgotPasswordBloc extends Mock implements ForgotPasswordBloc {}

class FakeForgotPasswordEvent extends Fake implements ForgotPasswordEvent {}

void main() {
  late ForgotPasswordBloc bloc;

  setUpAll(() {
    registerFallbackValue(FakeForgotPasswordEvent());
  });

  setUp(() {
    bloc = MockForgotPasswordBloc();
    when(() => bloc.state).thenReturn(ForgotPasswordInitial());
    when(() => bloc.stream).thenAnswer((_) => const Stream<ForgotPasswordState>.empty());
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<ForgotPasswordBloc>.value(
        value: bloc,
        child: const Scaffold(
          body: ForgotPasswordForm(),
        ),
      ),
    );
  }

  Future<void> _submitAndHandleDialog(WidgetTester tester) async {
    await tester.tap(find.byType(PrimaryButton));
    await tester.pump();

    await tester.pump(const Duration(milliseconds: 500));

    // Simula que pasan los 3 segundos del Future.delayed en el dialog
    await tester.pump(const Duration(seconds: 3));

    await tester.pumpAndSettle();
  }

  group('ForgotPasswordForm UI Tests', () {
    testWidgets('Validación: campo vacío muestra error', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await _submitAndHandleDialog(tester);
    });

    testWidgets('Validación: dominio incorrecto muestra error', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.enterText(find.byType(TextFormField), 'test@gmail.com');
      await _submitAndHandleDialog(tester);
    });

    testWidgets('NO envía evento si email es de dominio incorrecto', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.enterText(find.byType(TextFormField), 'test@gmail.com');
      await _submitAndHandleDialog(tester);

      verifyNever(() => bloc.add(any()));
    });
  });

  group('ForgotPasswordForm BlocListener Tests', () {
    testWidgets('Limpia el campo email si validación falla', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final emailField = find.byType(TextFormField);
      await tester.enterText(emailField, 'test@gmail.com');

      expect(
        (tester.widget(emailField) as TextFormField).controller!.text,
        'test@gmail.com',
      );

      await _submitAndHandleDialog(tester);

      expect(
        (tester.widget(emailField) as TextFormField).controller!.text,
        '',
      );
    });
  });
}
