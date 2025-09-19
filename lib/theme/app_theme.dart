import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_gradients.dart';
import 'app_text_styles.dart';

class AppTheme {
  static Widget buildGradientText({
    required String text,
    required TextStyle style,
    Gradient? gradient,
  }) {
    return ShaderMask(
      shaderCallback: (bounds) => (gradient ?? AppGradients.textGradient).createShader(bounds),
      child: Text(
        text,
        style: style,
      ),
    );
  }

  static Widget buildPrimaryButton({
    required String text,
    required VoidCallback onPressed,
    double? width,
    double height = 60,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(height / 2),
        gradient: AppGradients.primaryGradient,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryPurpleOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.transparent,
          shadowColor: AppColors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(height / 2),
          ),
        ),
        child: Text(
          text,
          style: AppTextStyles.primaryButton,
        ),
      ),
    );
  }

  static Widget buildSecondaryButton({
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
    double height = 50,
  }) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(height / 2),
        border: Border.all(
          color: AppColors.whiteOpacity(0.2),
          width: 1,
        ),
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: AppColors.whiteOpacity(0.8),
          size: 20,
        ),
        label: Text(
          text,
          style: AppTextStyles.secondaryButton,
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.transparent,
          shadowColor: AppColors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(height / 2),
          ),
        ),
      ),
    );
  }

  static Widget buildScreenContainer({required Widget child}) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.backgroundGradient,
        ),
        child: SafeArea(child: child),
      ),
    );
  }

  static Widget buildFadeTransition({
    required Widget child,
    required AnimationController controller,
  }) {
    final fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    ));

    return FadeTransition(
      opacity: fadeAnimation,
      child: child,
    );
  }
}