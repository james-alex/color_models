import 'package:flutter/material.dart' show Color;
import '../../color_model.dart' as cm;
import '../../flutter_color_model.dart';
import '../../helpers/color_converter.dart';
import './helpers/to_color.dart';

/// A color in the HSP color space.
///
/// The HSP color space contains channels for [hue],
/// [saturation], and [perceivedBrightness].
///
/// The HSP color space was created in 2006 by Darel Rex Finley.
/// Read about it here: http://alienryderflex.com/hsp.html
class HspColor extends cm.HspColor with ToColor {
  /// A color in the HSP color space.
  ///
  /// [hue] must be `>= 0` and `<= 360`.
  ///
  /// [saturation] and [perceivedBrightness] must both be `>= 0` and `<= 100`.
  const HspColor(
    num hue,
    num saturation,
    num perceivedBrightness,
  )   : assert(hue != null && hue >= 0 && hue <= 360),
        assert(saturation != null && saturation >= 0 && saturation <= 100),
        assert(perceivedBrightness != null &&
            perceivedBrightness >= 0 &&
            perceivedBrightness <= 100),
        super(hue, saturation, perceivedBrightness);

  /// Parses a list for HSP values and returns a [HspColor].
  ///
  /// [hsp] must not be null and must have exactly 3 values.
  ///
  /// The hue must be `>= 0` and `<= 360`.
  ///
  /// The saturation and perceived brightness must both be `>= 0` and `<= 100`.
  static HspColor fromList(List<num> hsp) {
    assert(hsp != null && hsp.length == 3);
    assert(hsp[0] != null && hsp[0] >= 0 && hsp[0] <= 360);
    assert(hsp[1] != null && hsp[1] >= 0 && hsp[1] <= 100);
    assert(hsp[2] != null && hsp[2] >= 0 && hsp[2] <= 100);

    return HspColor(hsp[0], hsp[1], hsp[2]);
  }

  /// Returns [color] as a [HspColor].
  static HspColor fromColor(Color color) {
    assert(color != null);

    return RgbColor.fromColor(color).toHspColor();
  }

  /// Returns a [color] in another color space as a HSP color.
  static HspColor from(ColorModel color) {
    assert(color != null);

    color = ToColor.cast(color);

    final hsp = ColorConverter.toHspColor(color);

    return HspColor(hsp.hue, hsp.saturation, hsp.perceivedBrightness);
  }

  /// Returns a [HspColor] from a list of [hsp] values on a 0 to 1 scale.
  ///
  /// [hsp] must not be null and must have exactly 3 values.
  ///
  /// Each of the values must be `>= 0` and `<= 1`.
  static HspColor extrapolate(List<double> hsp) {
    assert(hsp != null && hsp.length == 3);
    assert(hsp[0] != null && hsp[0] >= 0 && hsp[0] <= 1);
    assert(hsp[1] != null && hsp[1] >= 0 && hsp[1] <= 1);
    assert(hsp[2] != null && hsp[2] >= 0 && hsp[2] <= 1);

    return HspColor(hsp[0] * 360, hsp[1] * 100, hsp[2] * 100);
  }
}
