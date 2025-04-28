import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/src/auth/auth.dart';

class _FakeHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return _FakeHttpClient();
  }
}

class _FakeHttpClient implements HttpClient {
  @override
  noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

void main() {
  setUp(() {
    HttpOverrides.global = _FakeHttpOverrides();
  });

  tearDown(() {
    HttpOverrides.global = null;
  });

  testWidgets('ForgotPasswordPage build() se ejecuta correctamente', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ForgotPasswordPage(),
      ),
    );

    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text('Password recovery'), findsOneWidget);
    expect(find.byType(ForgotPasswordForm), findsOneWidget);
  });
}
