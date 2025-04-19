import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF007AFF);
  static const Color secondary = Color(0xFF34C759);
  static const Color background = Color(0xFFE0E0E0);
  static const Color textPrimary = Color(0xFF1C1C1E);
  static const Color textSecondary = Color(0xFF8E8E93);
  static const Color error = Color(0xFFFF3B30);

  static const Color backgroundDark = Color(0X4B4B4B4B);

  static Color getSurfaceColor(Brightness brightness) {
    return brightness == Brightness.dark ? Colors.black : Colors.white;
  }
}
