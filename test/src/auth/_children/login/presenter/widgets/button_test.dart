import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/src/auth/_children/login/presenter/widgets/button.dart';

void main() {
  group('LoginButton Widget', () {
    testWidgets('should display the provided text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoginButton(
              isLoading: false,
              text: const Text('Login'),
              onPressed: () {},
              isEnabled: true,
            ),
          ),
        ),
      );

      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('should call onPressed when tapped', (tester) async {
      bool wasPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoginButton(
              isLoading: false,
              text: const Text('Login'),
              onPressed: () {
                wasPressed = true;
              },
              isEnabled: true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(wasPressed, isTrue);
    });

    testWidgets('should not call onPressed if disabled (manual test case)', (tester) async {
      bool wasPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoginButton(
              isLoading: false,
              text: const Text('Login'),
              onPressed: () {
                wasPressed = true;
              },
              isEnabled: false
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(wasPressed, isFalse);
    });
  });
}
