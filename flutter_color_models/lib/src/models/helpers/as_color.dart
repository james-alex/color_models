import 'package:color_models/color_models.dart' show ColorModel;
import 'package:flutter/painting.dart' show Color;
import 'dart:math' as math show pow;
import 'dart:ui' as ui hide Color;

extension ColorModelWithValues on ColorModel {
  Color performWithValues(double? alpha, double? red, double? green,
      double? blue, ui.ColorSpace? colorSpace) {
    // TODO(gaaclarke): This is inefficient and will be easier to rewrite once
    // the changes come through on Color.
    assert(colorSpace == null || colorSpace == ui.ColorSpace.sRGB);
    Color color = toRgbColor() as Color;
    if (alpha != null) {
      color = color.withAlpha(alpha ~/ 255.0);
    }
    if (red != null) {
      color = color.withRed(red ~/ 255.0);
    }
    if (green != null) {
      color = color.withGreen(green ~/ 255.0);
    }
    if (blue != null) {
      color = color.withBlue(blue ~/ 255.0);
    }
    return color;
  }
}

/// The getters and methods required to implement Flutter's [Color] class.
mixin AsColor on ColorModel {
  /// A 32 bit value representing this color.
  ///
  /// The bits are assigned as follows:
  ///
  /// * Bits 24-31 are the alpha value.
  /// * Bits 16-23 are the red value.
  /// * Bits 8-15 are the green value.
  /// * Bits 0-7 are the blue value.
  int get value;

  ui.ColorSpace get colorSpace => ui.ColorSpace.sRGB;

  /// See <https://www.w3.org/TR/WCAG20/#relativeluminancedef>
  ///
  /// Copied from Flutter's [Color] class.
  static double _linearizeColorComponent(double component) {
    if (component <= 0.03928) {
      return component / 12.92;
    }

    return math.pow((component + 0.055) / 1.055, 2.4) as double;
  }

  /// Returns a brightness value between 0 for darkest and 1 for lightest.
  ///
  /// Represents the relative luminance of the color. This value is computationally
  /// expensive to calculate.
  ///
  /// See <https://en.wikipedia.org/wiki/Relative_luminance>.
  ///
  /// Copied from Flutter's [Color] class.
  double computeLuminance() {
    final rgb = toRgbColor();

    // See <https://www.w3.org/TR/WCAG20/#relativeluminancedef>
    final red = _linearizeColorComponent(rgb.red / 0xFF);
    final green = _linearizeColorComponent(rgb.green / 0xFF);
    final blue = _linearizeColorComponent(rgb.blue / 0xFF);

    return 0.2126 * red + 0.7152 * green + 0.0722 * blue;
  }
}
