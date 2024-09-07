import 'dart:math' as math;
import 'package:meta/meta.dart';
import 'package:num_utilities/num_utilities.dart';
import 'helpers/color_converter.dart';
import 'helpers/color_math.dart';
import 'models/cmyk_color.dart';
import 'models/hsb_color.dart';
import 'models/hsi_color.dart';
import 'models/hsl_color.dart';
import 'models/hsp_color.dart';
import 'models/lab_color.dart';
import 'models/oklab_color.dart';
import 'models/rgb_color.dart';
import 'models/xyz_color.dart';

export 'models/cmyk_color.dart';
export 'models/hsb_color.dart';
export 'models/hsi_color.dart';
export 'models/hsl_color.dart';
export 'models/hsp_color.dart';
export 'models/lab_color.dart';
export 'models/oklab_color.dart';
export 'models/rgb_color.dart';
export 'models/xyz_color.dart';

/// {@template color_models.ColorModel}
///
/// The base color model class.
///
/// {@endtemplate}
@immutable
abstract class ColorModel {
  /// The base color model class.
  const ColorModel({this.alpha = 255}) : assert(alpha >= 0 && alpha <= 255);

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

  /// Calculates a value representing this color's lightness on a linear scale.
  ///
  /// The returned value is calculated by converting this color to an [OklabColor]
  /// and normalizing its `lightness` value to a linear curve.
  ///
  /// Ranges from `0.0` (black) to `1.0` (white), unless the `lightness` value
  /// also falls outside of that range.
  double get chroma => math
      .pow((toOklabColor().lightness + 0.028) / 1.028, 6.9)
      .roundToPrecision(10)
      .clamp(0, 1)
      .toDouble();

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

  /// Interpolates to [step] between `this` and [end].
  ColorModel interpolate(ColorModel end, double step) {
    end = convert(end);
    final valuesA = this is RgbColor
        ? (this as RgbColor).toPreciseListWithAlpha()
        : toListWithAlpha();
    final valuesB =
        end is RgbColor ? end.toPreciseListWithAlpha() : end.toListWithAlpha();
    return fromValues(List<num>.generate(valuesA.length,
        (index) => _interpolateValue(valuesA[index], valuesB[index], step)));
  }

  /// Returns the interpolated [steps] between this color and [color].
  ///
  /// The returned [ColorModel]'s values will be interpolated in the
  /// color space defined by [colorSpace], or in the color space of
  /// `this` color if [colorSpace] is `null`.
  ///
  /// If [excludeOriginalColors] is `false`, this color and [color] will not be
  /// included in the list. If [color] is in a different color space, it will be
  /// converted to this color's color space.
  List<ColorModel> lerpTo(
    ColorModel color,
    int steps, {
    ColorSpace? colorSpace,
    bool excludeOriginalColors = false,
  }) {
    assert(steps > 0);

    final colorA = colorSpace != null ? colorSpace.from(this) : this;
    final valuesA = colorA is RgbColor
        ? colorA.toPreciseListWithAlpha()
        : colorA.toListWithAlpha();

    final colorB = colorSpace != null ? colorSpace.from(color) : convert(color);
    final valuesB = colorB is RgbColor
        ? colorB.toPreciseListWithAlpha()
        : colorB.toListWithAlpha();

    final colors = <ColorModel>[];
    final slice = 1 / (steps + 1);
    for (var i = 1; i <= steps; i++) {
      final values = <num>[];
      final step = slice * i;
      for (var j = 0; j < valuesA.length; j++) {
        values.add(_interpolateValue(valuesA[j], valuesB[j], step));
      }
      colors.add(colorA.fromValues(values));
    }

    if (!excludeOriginalColors) {
      colors.insert(0, colorA);
      colors.add(colorB);
    }

    return colors.map<ColorModel>((color) => convert(color)).toList();
  }

  /// Calculates the position at [step] between [value1] and [value2],
  /// rounded to the millionth.
  static num _interpolateValue(num value1, num value2, double step) =>
      ((((1 - step) * value1) + (step * value2)) * 1000000).round() / 1000000;

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

  /// Rotates the hue of this color by [amount] in radians.
  ColorModel rotateHueRad(double amount);

  /// Returns this [ColorModel] with the provided [hue] value.
  ColorModel withHue(num hue);

  /// Returns this [ColorModel] with the provided [alpha] value.
  ColorModel withAlpha(int alpha);

  /// Returns this [ColorModel] with the provided [opacity] value.
  ///
  /// [opacity] is the equivalent of [alpha] normalized to a `0` to `1` value.
  ColorModel withOpacity(double opacity);

  /// Converts this color to the Oklab color space, calculates and
  /// applies a new lightness value from the proivded [chroma] value,
  /// and converts it back to the original color space.
  ColorModel withChroma(double chroma);

  /// Returns a color in this color's color space with the values provided.
  ///
  /// [values] should contain one value for each parameter of the color space;
  /// the alpha value is optional.
  ColorModel fromValues(List<num> values);

  /// Returns a copy of this color modified with the provided values.
  ColorModel copyWith({int? alpha});

  /// Returns the distance between `this` color's
  /// hue and [color]'s hue in degrees.
  double distanceTo(ColorModel color) =>
      ColorMath.calculateDistance(hue, color.hue).toDouble();

  /// Compares colors in the RGB color space.
  ///
  /// If comparing two colors from the same color space,
  /// you can alternatively use the `==` operator.
  bool equals(ColorModel color) => RgbColor.from(this) == RgbColor.from(color);

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

  /// Converts `this` to the Oklab color space.
  OklabColor toOklabColor() => ColorConverter.toOklabColor(this);

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

  /// Converts [other] to this color's color space.
  ColorModel convert(ColorModel other);

  /// Converts this color to [other]'s color space.
  ColorModel castTo(ColorModel other) => other.convert(this);
}

/// An enumeration representing the color spaces defined in this package.
enum ColorSpace { cmyk, hsb, hsi, hsl, hsp, lab, oklab, rgb, xyz }

extension ConvertToColorSpace on ColorSpace {
  /// Converts [color] to this color space.
  ColorModel from(ColorModel color) {
    late ColorModel newColor;

    switch (this) {
      case ColorSpace.cmyk:
        newColor = CmykColor.from(color);
        break;
      case ColorSpace.hsb:
        newColor = HsbColor.from(color);
        break;
      case ColorSpace.hsi:
        newColor = HsiColor.from(color);
        break;
      case ColorSpace.hsl:
        newColor = HslColor.from(color);
        break;
      case ColorSpace.hsp:
        newColor = HspColor.from(color);
        break;
      case ColorSpace.lab:
        newColor = LabColor.from(color);
        break;
      case ColorSpace.oklab:
        newColor = OklabColor.from(color);
        break;
      case ColorSpace.rgb:
        newColor = RgbColor.from(color);
        break;
      case ColorSpace.xyz:
        newColor = XyzColor.from(color);
        break;
    }

    return newColor;
  }

  /// Returns a [ColorModel] in the color space defined by this from [values].
  ColorModel fromList(List<num> values) {
    late ColorModel newColor;

    switch (this) {
      case ColorSpace.cmyk:
        newColor = CmykColor.fromList(values);
        break;
      case ColorSpace.hsb:
        newColor = HsbColor.fromList(values);
        break;
      case ColorSpace.hsi:
        newColor = HsiColor.fromList(values);
        break;
      case ColorSpace.hsl:
        newColor = HslColor.fromList(values);
        break;
      case ColorSpace.hsp:
        newColor = HspColor.fromList(values);
        break;
      case ColorSpace.lab:
        newColor = LabColor.fromList(values);
        break;
      case ColorSpace.oklab:
        newColor = OklabColor.fromList(values.cast<double>());
        break;
      case ColorSpace.rgb:
        newColor = RgbColor.fromList(values);
        break;
      case ColorSpace.xyz:
        newColor = XyzColor.fromList(values);
        break;
    }

    return newColor;
  }

  String get name => toString().split('.').last;
}

extension AugmentColorModels on Iterable<ColorModel> {
  /// {@template color_models.AugumentColorModels.augment}
  ///
  /// Returns a new color palette derived from this one; containing
  /// the number of colors defined by [newLength].
  ///
  /// If [colorSpace] is `null`, the colors will be interpolated in
  /// the color space of the starting color within any pair of colors.
  ///
  /// [stops] can be provided to map the positions of the colors in the
  /// palette within the abstract gradient the augmented palette is derived
  /// from. If provided, there must be as many stops as there are colors
  /// in the palette. (`stops.length == length`)
  ///
  /// If [invert] is `true` and [colorSpace] is `null`, colors will be
  /// interpolated in the color space of the ending color within any pair
  /// of colors. [invert] has no effect if a [colorSpace] is provided.
  ///
  /// {@endtemplate}
  List<ColorModel> augment(
    int newLength, {
    List<double>? stops,
    ColorSpace? colorSpace,
    bool invert = false,
  }) {
    assert(stops == null || stops.length == length);

    late List<ColorModel> baseColors;
    if (stops != null && !stops.isIncremental) {
      // If the [stops] aren't sorted incrementally, reorder the
      // colors and their respective stops to be in correct order.
      final newStops = <double>[stops.first];
      baseColors = <ColorModel>[first];
      for (var i = 1; i < length; i++) {
        for (var j = 0; j <= newStops.length; j++) {
          if (j == newStops.length || stops[i] < newStops[j]) {
            newStops.insert(j, stops[i]);
            baseColors.insert(j, elementAt(i));
            break;
          }
        }
      }
      stops = newStops;
    } else {
      baseColors = toList();
    }

    final colors = <ColorModel>[];
    final slice = 1 / (newLength - 1);

    if (stops == null) {
      final stopSlice = 1 / (length - 1);
      stops = List<double>.generate(length, (index) => index * stopSlice);
    }

    for (var i = 0; i < newLength; i++) {
      // Calculate the position of the color within the palette.
      final step = i * slice;

      // If the step is before the first stop, or after the last stop,
      // set the color to the first or last color in the palette.
      if (step <= stops.first) {
        var color = baseColors.first;
        if (colorSpace != null) color = colorSpace.from(color);
        colors.add(color);
        continue;
      }
      if (step >= stops.last) {
        var color = baseColors.last;
        if (colorSpace != null) color = colorSpace.from(color);
        colors.add(color);
        continue;
      }

      // If the position is equal to one of the stops, the color
      // at that stop should remain in the palette.
      if (stops.contains(step)) {
        colors.add(baseColors[stops.indexOf(step)]);
        continue;
      }

      // Otherwise, calculate the new color by interpolating
      // between the colors around its position.
      late ColorModel colorA, colorB;
      late double stopA, stopB;
      for (var j = 0; j < length - 1; j++) {
        if (step >= stops[j] && step < stops[j + 1]) {
          if (invert) {
            colorA = baseColors[j + 1];
            colorB = baseColors[j];
            stopA = stops[j + 1];
            stopB = stops[j];
          } else {
            colorA = baseColors[j];
            colorB = baseColors[j + 1];
            stopA = stops[j];
            stopB = stops[j + 1];
          }
          break;
        }
      }

      // If [colorSpace] is defined, convert both colors to that space.
      if (colorSpace != null) {
        colorA = colorSpace.from(colorA);
        colorB = colorSpace.from(colorB);
      }

      // Calculate the new color and add it to the list.
      final substep = (step - stopA) / (stopB - stopA);
      colors.add(colorA.interpolate(colorB, substep));
    }
    return colors;
  }

  /// {@template color_models.AugumentColorModels.convertTo}
  ///
  /// Returns a new list containing the colors of this
  /// iterable converted to the defined [colorSpace].
  ///
  /// {@endtemplate}
  List<ColorModel> convertTo(ColorSpace colorSpace) {
    return List<ColorModel>.from(this)
        .map<ColorModel>((color) => colorSpace.from(color))
        .toList();
  }

  /// {@template color_models.AugumentColorModels.getColorAt}
  ///
  /// Returns the color at [delta] by interpolating between the colors in the list.
  ///
  /// {@endtemplate}
  ColorModel getColorAt(double delta) {
    assert(isNotEmpty, 'A color can\'t be returned from an empty list.');
    assert(delta >= 0.0 && delta <= 1.0);
    if (length == 1) return first;
    final slice = 1.0 / (length - 1);
    final position = delta / slice;
    final index = position.truncate();
    final color = elementAt(index);
    if (position == index) return color;
    return color.interpolate(elementAt(index + 1), position - index);
  }
}
