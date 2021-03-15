import '../color_model.dart';
import 'color_math.dart';

/// A utility class with methods for adjusting the hues of colors.
class ColorAdjustments {
  ColorAdjustments._();

  /// Converts [color] to a [HslColor] and adjusts the hue by [amount].
  static HslColor rotateHue(ColorModel color, num amount) {
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
    assert(amount > 0);
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
    assert(amount > 0);

    final adjustment = relative
        ? ColorMath.calculateDistance(hue, 90) * (amount / 100)
        : amount;

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
    assert(amount > 0);
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
    assert(amount > 0);

    final adjustment = relative
        ? ColorMath.calculateDistance(hue, 270) * (amount / 100)
        : amount;

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
