import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppGradients {
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      AppColors.darkBackground,
      AppColors.mediumBackground,
      AppColors.darkBackground,
    ],
  );

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [
      AppColors.primaryPurple,
      AppColors.primaryViolet,
    ],
  );

  static const LinearGradient textGradient = LinearGradient(
    colors: [
      AppColors.primaryPurple,
      AppColors.primaryViolet,
      AppColors.primaryPink,
    ],
  );
}