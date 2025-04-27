import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/src/profile/presenter/page/page.dart';

void main() {
  testWidgets('ProfileScreen displays "Profile" text', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ProfileScreen(),
      ),
    );
    expect(find.text('Profile screen'), findsOneWidget);
  });
}
