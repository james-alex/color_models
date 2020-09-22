import 'package:meta/meta.dart';
import 'helpers/calculate_distance.dart';
import 'helpers/color_converter.dart';
import 'models/cmyk_color.dart';
import 'models/hsb_color.dart';
import 'models/hsi_color.dart';
import 'models/hsl_color.dart';
import 'models/hsp_color.dart';
import 'models/lab_color.dart';
import 'models/rgb_color.dart';
import 'models/xyz_color.dart';

export 'models/cmyk_color.dart';
export 'models/hsb_color.dart';
export 'models/hsi_color.dart';
export 'models/hsl_color.dart';
export 'models/hsp_color.dart';
export 'models/lab_color.dart';
export 'models/rgb_color.dart';
export 'models/xyz_color.dart';

/// The base color model class.
@immutable
abstract class ColorModel {
  /// The base color model class.
  const ColorModel(this.alpha)
      : assert(alpha != null && alpha >= 0 && alpha <= 255);

  /// The alpha value of this color.
  ///
  /// Ranges from `0` to `255`.
  final int alpha;

  /// The [alpha] value as a double normalized to a `0.0` to `1.0` range.
  double get opacity => alpha / 255;

  /// Gets the hue value of this color.
  ///
  /// If you intend to get both the [hue] and [saturation] values,
  /// it is recommended to convert the color to a [HslColor] and
  /// getting the values from it, to avoid calculating the hue
  /// multiple times, unnecessarily.
  ///
  /// Ranges from `0` to `360`.
  num get hue => (ColorConverter.getHue(toRgbColor()) * 360) % 360;

  /// The saturation value of this color. Color spaces without a saturation
  /// value will be converted to HSL to retrieve the value.
  ///
  /// If you intend to get both the [hue] and [saturation] values,
  /// it is recommended to convert the color to a [HsbColor] and
  /// getting the values from it, to avoid calculating the hue
  /// multiple times, unnecessarily.
  ///
  /// Ranges from `0` to `360`.
  num get saturation => toHsbColor().saturation;

  /// Returns `true` if this color is pure black.
  bool get isBlack;

  /// Returns `true` if this color is pure white.
  bool get isWhite;

  /// Returns `true` if this color is monochromatic.
  bool get isMonochromatic;

  /// Returns the interpolated [steps] between this color and [color].
  ///
  /// The returned [ColorModel]'s values will be interpolated in
  /// this color's color space.
  ///
  /// If [excludeOriginalColors] is `false`, this color and [color] will not be
  /// included in the list. If [color] is in a different color space, it will be
  /// converted to this color's color space.
  List<ColorModel> interpolateTo(
    ColorModel color,
    int steps, {
    bool excludeOriginalColors,
  });

  /// Inverts the values of this [ColorModel],
  /// excluding [alpha], in its own color space.
  ColorModel get inverted;

  /// Returns the color with the hue opposite of this colors'.
  ColorModel get opposite;

  /// Adjusts the [hue] of this color by [amount] towards
  /// `90` degrees, capping the value at `90`.
  ///
  /// If [relative] is `true`, [amount] will be treated as a percentage and the
  /// hue will be adjusted by the percent of the distance from the current hue
  /// to `90` that [amount] represents. If `false`, [amount] will be treated
  /// as the number of degrees to adjust the hue by.
  ColorModel warmer(num amount, {bool relative});

  /// Adjusts the [hue] of this color by [amount] towards
  /// `270` degrees, capping the value at `270`.
  ///
  /// If [relative] is `true`, [amount] will be treated as a percentage and the
  /// hue will be adjusted by the percent of the distance from the current hue
  /// to `270` that [amount] represents. If `false`, [amount] will be treated
  /// as the number of degrees to adjust the hue by.
  ColorModel cooler(num amount, {bool relative});

  /// Rotates the hue of this color by [amount] in degrees.
  ColorModel rotateHue(num amount);

  /// Returns this [ColorModel] with the provided [alpha] value.
  ColorModel withAlpha(num alpha);

  /// Returns this [ColorModel] with the provided [hue] value.
  ColorModel withHue(num hue);

  /// Returns the distance between `this` color's
  /// hue and [color]'s hue in degrees.
  double distanceTo(ColorModel color) {
    assert(color != null);

    return calculateDistance(hue, color.hue);
  }

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

  /// Converts `this` to the HSB color space.
  HsbColor toHsbColor() => ColorConverter.toHsbColor(this);

  /// Converts `this` to the LAB color space.
  LabColor toLabColor() => ColorConverter.toLabColor(this);

  /// Converts `this` to the RGB color space.
  RgbColor toRgbColor();

  /// Converts `this` to the XYZ color space.
  XyzColor toXyzColor() => ColorConverter.toXyzColor(this);

  /// Returns the values of the color model in the same order
  /// as their characters in their color space's abbreviation.
  List<num> toList();

  /// Returns the values of the color model in the same order as their
  /// characters in their color space's abbreviation plus the alpha value.
  List<num> toListWithAlpha();

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
