import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'PlusJakartaSans',
  );

  // Text       → #374151
  // Hint       → #9CA3AF
  // Border     → #E5E7EB
  // static const Color primaryOrange = Color(0xFFE67E22);
  static const Color primaryOrange = Color(0xFFF59E0B);
  static const Color primaryGray = Color(0xFF374151);
  static const Color secondaryGray = Color(0xFF6B7280);
  static const Color tertiaryGray = Color(0xFF9CA3AF);
  static const Color borderGray = Color(0xFFE5E7EB);
  static const Color background = Color(0xFFFAFAF9);
}
