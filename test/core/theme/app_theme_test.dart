import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/theme/app_theme.dart';
import 'package:mobile/core/theme/app_colors.dart';

void main() {
  group('AppTheme', () {
    test('lightTheme is correctly configured', () {
      final theme = AppTheme.lightTheme;

      expect(theme.primaryColor, AppColors.primary);
      expect(theme.scaffoldBackgroundColor, AppColors.background);

      expect(theme.textTheme.bodyLarge?.color, AppColors.textPrimary);
      expect(theme.textTheme.bodyMedium?.color, AppColors.textSecondary);

      final colorScheme = theme.colorScheme;
      expect(colorScheme.primary, AppColors.primary);
      expect(colorScheme.secondary, AppColors.secondary);
      expect(colorScheme.error, AppColors.error);
      expect(colorScheme.surface, AppColors.background);
      expect(colorScheme.outline, AppColors.textSecondary);
      expect(colorScheme.brightness, Brightness.light);
    });

    test('darkTheme is correctly configured', () {
      final theme = AppTheme.darkTheme;

      expect(theme.primaryColor, AppColors.primary);
      expect(theme.scaffoldBackgroundColor, Colors.black);

      expect(theme.textTheme.bodyLarge?.color, Colors.white);
      expect(theme.textTheme.bodyMedium?.color, Colors.grey);

      final colorScheme = theme.colorScheme;
      expect(colorScheme.primary, AppColors.primary);
      expect(colorScheme.secondary, AppColors.secondary);
      expect(colorScheme.error, AppColors.error);
      expect(colorScheme.surface, AppColors.backgroundDark);
      expect(colorScheme.outline, AppColors.textSecondary);
      expect(colorScheme.brightness, Brightness.dark);
    });

    test('light and dark themes are different', () {
      expect(AppTheme.lightTheme, isNot(equals(AppTheme.darkTheme)));
    });
  });
}
