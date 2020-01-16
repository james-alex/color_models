import 'package:flutter/material.dart' show Color;
import '../../color_model.dart' as cm;
import '../../flutter_color_model.dart';
import '../../helpers/color_converter.dart';
import './helpers/to_color.dart';

/// A color in the HSI color space.
///
/// The HSI color space contains channels for [hue],
/// [saturation], and [intensity].
class HsiColor extends cm.HsiColor with ToColor {
  /// A color in the HSV (HSB) color space.
  ///
  /// [hue] must be `>= 0` and `<= 360`.
  ///
  /// [saturation] and [intensity] must both be `>= 0` and `<= 100`.
  const HsiColor(
    num hue,
    num saturation,
    num intensity,
  )   : assert(hue != null && hue >= 0 && hue <= 360),
        assert(saturation != null && saturation >= 0 && saturation <= 100),
        assert(intensity != null && intensity >= 0 && intensity <= 100),
        super(hue, saturation, intensity);

  /// Parses a list for HSI values and returns a [HsiColor].
  ///
  /// [hsi] must not be null and must have exactly 3 values.
  ///
  /// The hue must be `>= 0` and `<= 360`.
  ///
  /// The saturation and intensity must both be `>= 0` and `<= 100`.
  static HsiColor fromList(List<num> hsi) {
    assert(hsi != null && hsi.length == 3);
    assert(hsi[0] != null && hsi[0] >= 0 && hsi[0] <= 360);
    assert(hsi[1] != null && hsi[1] >= 0 && hsi[1] <= 100);
    assert(hsi[2] != null && hsi[2] >= 0 && hsi[2] <= 100);

    return HsiColor(hsi[0], hsi[1], hsi[2]);
  }

  /// Returns [color] as a [HsiColor].
  static HsiColor fromColor(Color color) {
    assert(color != null);

    return RgbColor.fromColor(color).toHsiColor();
  }

  /// Returns a [color] in another color space as a HSI color.
  static HsiColor from(ColorModel color) {
    assert(color != null);

    color = ToColor.cast(color);

    final hsi = ColorConverter.toHsiColor(color);

    return HsiColor(hsi.hue, hsi.saturation, hsi.intensity);
  }

  /// Returns a [HsiColor] from a list of [hsi] values on a 0 to 1 scale.
  ///
  /// [hsi] must not be null and must have exactly 3 values.
  ///
  /// Each of the values must be `>= 0` and `<= 1`.
  static HsiColor extrapolate(List<double> hsi) {
    assert(hsi != null && hsi.length == 3);
    assert(hsi[0] != null && hsi[0] >= 0 && hsi[0] <= 1);
    assert(hsi[1] != null && hsi[1] >= 0 && hsi[1] <= 1);
    assert(hsi[2] != null && hsi[2] >= 0 && hsi[2] <= 1);

    return HsiColor(hsi[0] * 360, hsi[1] * 100, hsi[2] * 100);
  }
}
