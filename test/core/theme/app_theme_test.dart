import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/theme/app_theme.dart';
import 'package:mobile/core/theme/app_colors.dart';

void main() {
  group('AppTheme', () {
    test('Light theme uses correct primary color and scaffold background', () {
      final theme = AppTheme.lightTheme;

      expect(theme.primaryColor, AppColors.primary);
      expect(theme.scaffoldBackgroundColor, AppColors.background);
      expect(theme.colorScheme.primary, AppColors.primary);
      expect(theme.colorScheme.secondary, AppColors.secondary);
      expect(theme.colorScheme.error, AppColors.error);
      expect(theme.colorScheme.surface, AppColors.background);
      expect(theme.colorScheme.outline, AppColors.textSecondary);
    });

    test('Dark theme uses correct primary color and scaffold background', () {
      final theme = AppTheme.darkTheme;

      expect(theme.primaryColor, AppColors.primary);
      expect(theme.scaffoldBackgroundColor, Colors.black);
      expect(theme.colorScheme.primary, AppColors.primary);
      expect(theme.colorScheme.secondary, AppColors.secondary);
      expect(theme.colorScheme.error, AppColors.error);
      expect(theme.colorScheme.surface, AppColors.backgroundDark);
      expect(theme.colorScheme.outline, AppColors.textSecondary);
    });

    test('TextTheme in light theme uses correct text color', () {
      final textColor = AppTheme.lightTheme.textTheme.bodyMedium?.color;
      expect(textColor, AppColors.textPrimary);
    });

    test('TextTheme in dark theme uses correct text color', () {
      final textColor = AppTheme.darkTheme.textTheme.bodyMedium?.color;
      expect(textColor, Colors.white);
    });
  });
}
