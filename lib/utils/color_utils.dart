import 'package:flutter/material.dart';

/// Utility functions for working with colors
class ColorUtils {
  /// Creates a color with opacity without using deprecated methods
  static Color withOpacity(Color color, double opacity) {
    return Color.from(
        alpha: opacity, red: color.r, green: color.g, blue: color.b);
  }
}
