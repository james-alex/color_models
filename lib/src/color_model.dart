import 'package:meta/meta.dart';
import './helpers/color_converter.dart';
import './models/cmyk_color.dart';
import './models/hsi_color.dart';
import './models/hsl_color.dart';
import './models/hsp_color.dart';
import './models/hsv_color.dart';
import './models/lab_color.dart';
import './models/rgb_color.dart';
import './models/xyz_color.dart';

export './models/cmyk_color.dart';
export './models/hsi_color.dart';
export './models/hsl_color.dart';
export './models/hsp_color.dart';
export './models/hsv_color.dart';
export './models/lab_color.dart';
export './models/rgb_color.dart';
export './models/xyz_color.dart';

/// The base color model class.
@immutable
abstract class ColorModel {
  /// The base color model class.
  const ColorModel();

  /// Returns `true` if this color is pure black.
  bool get isBlack;

  /// Returns `true` if this color is pure white.
  bool get isWhite;

  /// Compares colors in the RGB color space.
  ///
  /// If comparing two colors from the same color space,
  /// you can alternatively use the `==` operator.
  bool equals(ColorModel color) {
    assert(color != null);

    return RgbColor.from(this) == RgbColor.from(color);
  }

  /// Converts `this` to the CMYK color space.
  CmykColor toCmykColor() => ColorConverter.toCmykColor(this);

  /// Converts `this` to the HSI color space.
  HsiColor toHsiColor() => ColorConverter.toHsiColor(this);

  /// Converts `this` to the HSL color space.
  HslColor toHslColor() => ColorConverter.toHslColor(this);

  /// Converts `this` to the HSP color space.
  HspColor toHspColor() => ColorConverter.toHspColor(this);

  /// Converts `this` to the HSV color space.
  HsvColor toHsvColor() => ColorConverter.toHsvColor(this);

  /// Converts `this` to the LAB color space.
  LabColor toLabColor() => ColorConverter.toLabColor(this);

  /// Converts `this` to the RGB color space.
  RgbColor toRgbColor();

  /// Converts `this` to the XYZ color space.
  XyzColor toXyzColor() => ColorConverter.toXyzColor(this);

  /// Returns the values of the color model in the same order
  /// as their characters in their color space's abbreviation.
  List<num> toList();

  /// Returns `this` as a hexidecimal string.
  String get hex {
    final rgb = toRgbColor().toList();

    var hex = '#';

    for (var value in rgb) {
      hex += value.toRadixString(16).padLeft(2, '0');
    }

    return hex;
  }
}
