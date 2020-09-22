import '../color_model.dart';
import 'calculate_distance.dart';

/// A utility class with methods for adjusting the hues of colors.
class ColorAdjustments {
  ColorAdjustments._();

  /// Interpolates [color1] to [color2] with the number of [steps] inbetween.
  ///
  /// If [excludeOriginalColors] is `false`, [color1] and [color2] will not be
  /// included in the list.
  static List<ColorModel> interpolateColors(
    ColorModel color1,
    ColorModel color2,
    int steps, {
    bool excludeOriginalColors = false,
  }) {
    assert(color1 != null);
    assert(color2 != null);
    assert(color1.runtimeType == color2.runtimeType);
    assert(steps != null && steps > 0);
    assert(excludeOriginalColors != null);

    final colors = <ColorModel>[];

    final values1 = color1 is RgbColor
        ? color1.toPreciseListWithAlpha()
        : color1.toListWithAlpha();
    final values2 = color2 is RgbColor
        ? color2.toPreciseListWithAlpha()
        : color2.toListWithAlpha();

    for (var i = 1; i <= steps; i++) {
      final values = <num>[];

      final step = (1 / (steps + 1)) * i;

      for (var j = 0; j < values1.length; j++) {
        values.add(_interpolateValue(values1[j], values2[j], step));
      }

      switch (color1.runtimeType) {
        case CmykColor:
          colors.add(CmykColor.fromList(values));
          break;
        case HsiColor:
          colors.add(HsiColor.fromList(values));
          break;
        case HslColor:
          colors.add(HslColor.fromList(values));
          break;
        case HspColor:
          colors.add(HspColor.fromList(values));
          break;
        case HsbColor:
          colors.add(HsbColor.fromList(values));
          break;
        case LabColor:
          colors.add(LabColor.fromList(values));
          break;
        case RgbColor:
          colors.add(RgbColor.fromList(values));
          break;
        case XyzColor:
          colors.add(XyzColor.fromList(values));
          break;
      }
    }

    if (!excludeOriginalColors) {
      colors.insert(0, color1);
      colors.add(color2);
    }

    return colors;
  }

  static num _interpolateValue(num value1, num value2, double step) =>
      ((((1 - step) * value1) + (step * value2)) * 1000000).round() / 1000000;

  /// Converts [color] to a [HslColor] and adjusts the hue by [amount].
  static HslColor rotateHue(ColorModel color, num amount) {
    assert(color != null);
    assert(amount != null);

    final hslColor = color.toHslColor();

    return hslColor.withHue((hslColor.hue + amount) % 360);
  }

  /// Converts [color] to a [HslColor] and adjusts the hue towards
  /// `90` degrees by [amount], capping the hue's value at `90`.
  static HslColor warmer(
    ColorModel color,
    num amount, {
    bool relative = true,
  }) {
    assert(color != null);
    assert(amount != null && amount > 0);
    assert(relative != null);

    final hslColor = color.toHslColor();

    final hue = warmerHue(hslColor.hue, amount, relative: relative);

    return hslColor.withHue(hue);
  }

  /// Adjusts [hue] towards `90` degrees by [amount],
  /// capping the value at `90`.
  static num warmerHue(
    num hue,
    num amount, {
    bool relative = true,
  }) {
    assert(hue != null);
    assert(amount != null && amount > 0);
    assert(relative != null);

    final adjustment =
        relative ? calculateDistance(hue, 90) * (amount / 100) : amount;

    if (hue >= 0 && hue <= 90) {
      hue += adjustment;
      if (hue > 90) hue = 90;
    } else if (hue >= 270 && hue <= 360) {
      hue = (hue + adjustment) % 360;
    } else {
      hue -= adjustment;
      if (hue < 90) hue = 90;
    }

    return hue;
  }

  /// Converts [color] to a [HslColor] and adjusts the hue towards
  /// `270` degrees by [amount], capping the hue's value at `270`.
  static HslColor cooler(
    ColorModel color,
    num amount, {
    bool relative = true,
  }) {
    assert(color != null);
    assert(amount != null && amount > 0);
    assert(relative != null);

    final hslColor = color.toHslColor();

    final hue = coolerHue(hslColor.hue, amount, relative: relative);

    return hslColor.withHue(hue);
  }

  /// Adjusts [hue] towards `270` degrees by [amount],
  /// capping the value at `270`.
  static num coolerHue(
    num hue,
    num amount, {
    bool relative = true,
  }) {
    assert(hue != null);
    assert(amount != null && amount > 0);
    assert(relative != null);

    final adjustment =
        relative ? calculateDistance(hue, 270) * (amount / 100) : amount;

    if (hue >= 0 && hue <= 90) {
      hue = (hue - adjustment) % 360;
    } else if (hue >= 270 && hue <= 360) {
      hue -= adjustment;
      if (hue < 270) hue = 270;
    } else {
      hue += adjustment;
      if (hue > 270) hue = 270;
    }

    return hue;
  }
}
