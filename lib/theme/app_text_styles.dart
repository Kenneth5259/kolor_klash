import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const TextStyle gameTitle = TextStyle(
    fontSize: 42,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
    letterSpacing: 3.0,
  );

  static TextStyle subtitle = TextStyle(
    fontSize: 16,
    color: AppColors.whiteOpacity(0.7),
    letterSpacing: 2.0,
    fontWeight: FontWeight.w300,
  );

  static const TextStyle primaryButton = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
    letterSpacing: 1.5,
  );

  static TextStyle secondaryButton = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.whiteOpacity(0.8),
    letterSpacing: 1.0,
  );

  static TextStyle versionText = TextStyle(
    fontSize: 12,
    color: AppColors.whiteOpacity(0.4),
    letterSpacing: 1.0,
  );
}