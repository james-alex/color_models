import 'package:flutter/material.dart' show Color;
import '../../color_model.dart' as cm;
import '../../flutter_color_model.dart';
import './helpers/to_color.dart';

/// A color in the sRGB color space.
///
/// The sRGB color space contains channels for [red], [green], and [blue].
///
/// [RgbColor] stores RGB values as [num]s privately in order to avoid
/// a loss of precision when converting between color spaces, but has
/// getters set for [red], [green], and [blue] that return the rounded
/// [int] values. The precise values can returned as a list with the
/// `toPreciseList()` method.
class RgbColor extends cm.RgbColor with ToColor {
  /// A color in the sRGB color space.
  ///
  /// [_red], [_green], and [_blue] must all be `>= 0` and `<= 255`.
  const RgbColor(
    num red,
    num green,
    num blue,
  )   : assert(red != null && red >= 0 && red <= 255),
        assert(green != null && green >= 0 && green <= 255),
        assert(blue != null && blue >= 0 && green <= 255),
        super(red, green, blue);

  /// Parses a list for RGB values and returns a [RgbColor].
  ///
  /// [rgb] must not be null and must have exactly 3 values.
  ///
  /// Each color value must be `>= 0 && <= 255`.
  static RgbColor fromList(List<num> rgb) {
    assert(rgb != null && rgb.length == 3);
    assert(rgb[0] != null && rgb[0] >= 0 && rgb[0] <= 255);
    assert(rgb[1] != null && rgb[1] >= 0 && rgb[1] <= 255);
    assert(rgb[2] != null && rgb[2] >= 0 && rgb[2] <= 255);

    return RgbColor(rgb[0], rgb[1], rgb[2]);
  }

  /// Returns [color] as a [RgbColor].
  static RgbColor fromColor(Color color) {
    assert(color != null);

    return RgbColor(color.red, color.green, color.blue);
  }

  /// Returns a [color] in another color space as a RGB color.
  static RgbColor from(ColorModel color) {
    assert(color != null);

    color = ToColor.cast(color);

    final rgb = color.toRgbColor();

    return RgbColor(rgb.red, rgb.green, rgb.blue);
  }

  /// Returns a [RgbColor] from a list of [rgb] values on a 0 to 1 scale.
  ///
  /// [rgb] must not be null and must have exactly 3 values.
  ///
  /// Each of the values must be `>= 0` and `<= 1`.
  static RgbColor extrapolate(List<double> rgb) {
    assert(rgb != null && rgb.length == 3);
    assert(rgb[0] != null && rgb[0] >= 0 && rgb[0] <= 1);
    assert(rgb[1] != null && rgb[1] >= 0 && rgb[1] <= 1);
    assert(rgb[2] != null && rgb[2] >= 0 && rgb[2] <= 1);

    final rgbValues = rgb.map((rgbValue) => rgbValue * 255).toList();

    return fromList(rgbValues);
  }
}
