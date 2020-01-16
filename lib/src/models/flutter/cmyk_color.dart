import 'package:flutter/material.dart' show Color;
import '../../color_model.dart' as cm;
import '../../flutter_color_model.dart';
import '../../helpers/color_converter.dart';
import './helpers/to_color.dart';

/// A color in the CMYK color space.
///
/// The CMYK color space contains channels for [cyan],
/// [magenta], [yellow], and [black].
class CmykColor extends cm.CmykColor with ToColor {
  /// A color in the CMYK color space.
  ///
  /// [cyan], [magenta], [yellow], and [black]
  /// must all be `>= 0` and `<= 100`.
  const CmykColor(
    num cyan,
    num magenta,
    num yellow,
    num black,
  )   : assert(cyan != null && cyan >= 0 && cyan <= 100),
        assert(magenta != null && magenta >= 0 && magenta <= 100),
        assert(yellow != null && yellow >= 0 && yellow <= 100),
        assert(black != null && black >= 0 && black <= 100),
        super(cyan, magenta, yellow, black);

  /// Parses a list for CMYK values and returns a [CmykColor].
  ///
  /// [cmyk] must not be null and must have exactly 4 values.
  ///
  /// Each color value must be `>= 0 && <= 100`.
  static CmykColor fromList(List<num> cmyk) {
    assert(cmyk != null && cmyk.length == 4);
    assert(cmyk[0] != null && cmyk[0] >= 0 && cmyk[0] <= 100);
    assert(cmyk[1] != null && cmyk[1] >= 0 && cmyk[1] <= 100);
    assert(cmyk[2] != null && cmyk[2] >= 0 && cmyk[2] <= 100);
    assert(cmyk[3] != null && cmyk[3] >= 0 && cmyk[3] <= 100);

    return CmykColor(cmyk[0], cmyk[1], cmyk[2], cmyk[3]);
  }

  /// Returns [color] as a [CmykColor].
  static CmykColor fromColor(Color color) {
    assert(color != null);

    return RgbColor.fromColor(color).toCmykColor();
  }

  /// Returns a [color] in another color space as a CMYK color.
  static CmykColor from(ColorModel color) {
    assert(color != null);

    color = ToColor.cast(color);

    final cmyk = ColorConverter.toCmykColor(color);

    return CmykColor(cmyk.cyan, cmyk.magenta, cmyk.yellow, cmyk.black);
  }

  /// Returns a [CmykColor] from a list of [cmyk] values on a 0 to 1 scale.
  ///
  /// [cmyk] must not be null and must have exactly 4 values.
  ///
  /// Each of the values must be `>= 0` and `<= 1`.
  static CmykColor extrapolate(List<double> cmyk) {
    assert(cmyk != null && cmyk.length == 4);
    assert(cmyk[0] != null && cmyk[0] >= 0 && cmyk[0] <= 1);
    assert(cmyk[1] != null && cmyk[1] >= 0 && cmyk[1] <= 1);
    assert(cmyk[2] != null && cmyk[2] >= 0 && cmyk[2] <= 1);
    assert(cmyk[3] != null && cmyk[3] >= 0 && cmyk[3] <= 1);

    final cmykValues = cmyk.map((cmykValue) => cmykValue * 100).toList();

    return CmykColor.fromList(cmykValues);
  }
}
