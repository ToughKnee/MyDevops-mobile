import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/theme/app_colors.dart';

void main() {
  group('AppColors', () {
    test('Color constants have correct values', () {
      expect(AppColors.primary, const Color(0xFF007AFF));
      expect(AppColors.secondary, const Color(0xFF34C759));
      expect(AppColors.background, const Color(0xFFE0E0E0));
      expect(AppColors.textPrimary, const Color(0xFF1C1C1E));
      expect(AppColors.textSecondary, const Color(0xFF8E8E93));
      expect(AppColors.error, const Color(0xFFFF3B30));
      expect(AppColors.backgroundDark, const Color(0x4B4B4B4B));
    });

    test('getSurfaceColor returns correct color for Brightness.light', () {
      final surfaceColor = AppColors.getSurfaceColor(Brightness.light);
      expect(surfaceColor, Colors.white);
    });

    test('getSurfaceColor returns correct color for Brightness.dark', () {
      final surfaceColor = AppColors.getSurfaceColor(Brightness.dark);
      expect(surfaceColor, Colors.black);
    });
  });
}
