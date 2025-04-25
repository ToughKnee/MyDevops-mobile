import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/theme/app_colors.dart';

void main() {
  group('AppColors', () {
    test('Color constants have correct values', () {
      expect(AppColors.primary, const Color(0xFF2C6BED));
      expect(AppColors.secondary, const Color(0xFF4CD964));
      expect(AppColors.background, const Color(0xFFF5F7FA));
      expect(AppColors.textPrimary, const Color(0xFF0F1A2A));
      expect(AppColors.textSecondary, const Color(0xFF7A8CA5));
      expect(AppColors.error, const Color.fromARGB(255, 219, 56, 80));
      expect(AppColors.accent, const Color(0xFF9D7FEA));
      expect(AppColors.success, const Color(0xFF20D5B4));
      expect(AppColors.warning, const Color(0xFFFFB340));
      expect(AppColors.backgroundDark, const Color(0xFF1E2533));
    });

    test('getSurfaceColor returns correct color for Brightness.light', () {
      final surfaceColor = AppColors.getSurfaceColor(Brightness.light);
      expect(surfaceColor, Colors.white);
    });

    test('getSurfaceColor returns correct color for Brightness.dark', () {
      final surfaceColor = AppColors.getSurfaceColor(Brightness.dark);
      expect(surfaceColor, const Color(0xFF2D3446));
    });

    test(
      'getSecondarySurfaceColor returns correct color for Brightness.light',
      () {
        final secondarySurfaceColor = AppColors.getSecondarySurfaceColor(
          Brightness.light,
        );
        expect(secondarySurfaceColor, const Color(0xFFF0F2F5));
      },
    );

    test(
      'getSecondarySurfaceColor returns correct color for Brightness.dark',
      () {
        final secondarySurfaceColor = AppColors.getSecondarySurfaceColor(
          Brightness.dark,
        );
        expect(secondarySurfaceColor, const Color(0xFF353C4F));
      },
    );
  });
}
