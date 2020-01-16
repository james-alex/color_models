import 'package:flutter/material.dart' show Color;
import '../../color_model.dart' as cm;
import '../../flutter_color_model.dart';
import '../../helpers/color_converter.dart';
import './helpers/to_color.dart';

/// A color in the HSV (HSB) color space.
///
/// The HSV color space contains channels for [hue],
/// [saturation], and [value].
class HsvColor extends cm.HsvColor with ToColor {
  /// A color in the HSV (HSB) color space.
  ///
  /// [hue] must be `>= 0` and `<= 360`.
  ///
  /// [saturation] and [value] must both be `>= 0` and `<= 100`.
  const HsvColor(
    num hue,
    num saturation,
    num value,
  )   : assert(hue != null && hue >= 0 && hue <= 360),
        assert(saturation != null && saturation >= 0 && saturation <= 100),
        assert(value != null && value >= 0 && value <= 100),
        super(hue, saturation, value);

  /// Parses a list for HSV values and returns a [HsvColor].
  ///
  /// [hsv] must not be null and must have exactly 3 values.
  ///
  /// The hue must be `>= 0` and `<= 360`.
  ///
  /// The saturation and value must both be `>= 0` and `<= 100`.
  static HsvColor fromList(List<num> hsv) {
    assert(hsv != null && hsv.length == 3);
    assert(hsv[0] != null && hsv[0] >= 0 && hsv[0] <= 360);
    assert(hsv[1] != null && hsv[1] >= 0 && hsv[1] <= 100);
    assert(hsv[2] != null && hsv[2] >= 0 && hsv[2] <= 100);

    return HsvColor(hsv[0], hsv[1], hsv[2]);
  }

  /// Returns [color] as a [HslColor].
  static HsvColor fromColor(Color color) {
    assert(color != null);

    return RgbColor.fromColor(color).toHsvColor();
  }

  /// Returns a [color] in another color space as a HSV color.
  static HsvColor from(ColorModel color) {
    assert(color != null);

    color = ToColor.cast(color);

    final hsv = ColorConverter.toHsvColor(color);

    return HsvColor(hsv.hue, hsv.saturation, hsv.value);
  }

  /// Returns a [HsvColor] from a list of [hsv] values on a 0 to 1 scale.
  ///
  /// [hsv] must not be null and must have exactly 3 values.
  ///
  /// Each of the values must be `>= 0` and `<= 1`.
  static HsvColor extrapolate(List<double> hsv) {
    assert(hsv != null && hsv.length == 3);
    assert(hsv[0] != null && hsv[0] >= 0 && hsv[0] <= 1);
    assert(hsv[1] != null && hsv[1] >= 0 && hsv[1] <= 1);
    assert(hsv[2] != null && hsv[2] >= 0 && hsv[2] <= 1);

    return HsvColor(hsv[0] * 360, hsv[1] * 100, hsv[2] * 100);
  }
}
