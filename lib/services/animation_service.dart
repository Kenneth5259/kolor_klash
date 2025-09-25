import 'package:flutter/material.dart';

class AnimationService {
  static bool _animationsEnabled = true;

  // Update animations setting
  static void updateSettings({required bool animationsEnabled}) {
    _animationsEnabled = animationsEnabled;
  }

  // Get conditional duration based on animation setting
  static Duration getDuration(Duration normalDuration) {
    return _animationsEnabled ? normalDuration : Duration.zero;
  }

  // Get conditional curve based on animation setting
  static Curve getCurve(Curve normalCurve) {
    return _animationsEnabled ? normalCurve : Curves.linear;
  }

  // Check if animations are enabled
  static bool get animationsEnabled => _animationsEnabled;
}