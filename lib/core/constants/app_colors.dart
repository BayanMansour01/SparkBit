import 'package:flutter/material.dart';

/// App color constants
class AppColors {
  AppColors._();

  // Primary - Gold/Amber accent
  static const Color primary = Color(0xFFD4A84B);
  static const Color primaryLight = Color(0xFFE8C97A);
  static const Color primaryDark = Color(0xFFB8923F);

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF0D1321);
  static const Color darkSurface = Color(0xFF1D2939);
  static const Color darkCard = Color(0xFF243447);
  static const Color darkText = Color(0xFFF1F5F9);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkDivider = Color(0xFF334155);

  // Light Theme Colors
  static const Color lightBackground = Color(
    0xFFEBEFF5,
  ); // Reduced glare significantly
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightText = Color(0xFF1E293B);
  static const Color lightTextSecondary = Color(0xFF64748B);
  static const Color lightDivider = Color(0xFFE2E8F0);

  // Common
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF22C55E);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  // Default / Fallback Accessors (Prefer using Theme.of(context))
  static Color get background => lightBackground;
  static Color get surface => lightSurface;
  static Color get textSecondary => lightTextSecondary;
  static Color get card => lightCard;
  static Color get border => lightDivider;
}
