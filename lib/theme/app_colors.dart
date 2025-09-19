import 'package:flutter/material.dart';

class AppColors {
  static const Color darkBackground = Color(0xFF0A0A0A);
  static const Color mediumBackground = Color(0xFF1A1A1A);

  static const Color primaryPurple = Color(0xFF6366F1);
  static const Color primaryViolet = Color(0xFF8B5CF6);
  static const Color primaryPink = Color(0xFFEC4899);

  static const Color white = Colors.white;
  static const Color transparent = Colors.transparent;

  static Color whiteOpacity(double opacity) => Colors.white.withOpacity(opacity);
  static Color primaryPurpleOpacity(double opacity) => primaryPurple.withOpacity(opacity);
}