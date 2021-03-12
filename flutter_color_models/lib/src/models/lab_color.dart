import 'package:flutter/painting.dart' show Color;
import 'package:color_models/color_models.dart' as cm;
import '../color_model.dart';
import 'helpers/as_color.dart';
import 'helpers/rgb_getters.dart';
import 'helpers/cast_to_color.dart';

/// A color in the CIELAB color space.
///
/// The CIELAB color space contains channels for [lightness],
/// [a] (red and green opponent values), and [b] (blue and
/// yellow opponent values.)
class LabColor extends cm.LabColor
    with AsColor, RgbGetters, CastToColor
    implements ColorModel {
  /// A color in the CIELAB color space.
  ///
  /// [lightness] must be `>= 0` and `<= 100`.
  ///
  /// [a] and [b] must both be `>= -128` and `<= 127`.
  const LabColor(
    num lightness,
    num a,
    num b, [
    int alpha = 255,
  ])  : assert(lightness >= 0 && lightness <= 100),
        assert(a >= -128 && a <= 127),
        assert(b >= -128 && b <= 127),
        assert(alpha >= 0 && alpha <= 255),
        super(lightness, a, b, alpha);

  @override
  int get value => toColor().value;

  @override
  List<LabColor> lerpTo(
    cm.ColorModel color,
    int steps, {
    bool excludeOriginalColors = false,
  }) {
    assert(steps > 0);
    return super
        .lerpTo(color, steps, excludeOriginalColors: excludeOriginalColors)
        .map<LabColor>((color) => color.cast())
        .toList();
  }

  @override
  LabColor get inverted => super.inverted.cast();

  @override
  LabColor get opposite => super.opposite.cast();

  @override
  LabColor rotateHue(num amount) => super.rotateHue(amount).cast();

  @override
  LabColor warmer(num amount, {bool relative = true}) {
    assert(amount > 0);
    return super.warmer(amount, relative: relative).cast();
  }

  @override
  LabColor cooler(num amount, {bool relative = true}) {
    assert(amount > 0);
    return super.cooler(amount, relative: relative).cast();
  }

  @override
  LabColor withLightness(num lightness) {
    assert(lightness >= 0 && lightness <= 100);
    return LabColor(lightness, a, b, alpha);
  }

  @override
  LabColor withA(num a) {
    assert(a >= -128 && a <= 127);
    return LabColor(lightness, a, b, alpha);
  }

  @override
  LabColor withB(num b) {
    assert(b >= -128 && b <= 127);
    return LabColor(lightness, a, b, alpha);
  }

  @override
  LabColor withRed(num red) {
    assert(red >= 0 && red <= 255);
    return toRgbColor().withRed(red).toLabColor();
  }

  @override
  LabColor withGreen(num green) {
    assert(green >= 0 && green <= 255);
    return toRgbColor().withGreen(green).toLabColor();
  }

  @override
  LabColor withBlue(num blue) {
    assert(blue >= 0 && blue <= 255);
    return toRgbColor().withBlue(blue).toLabColor();
  }

  @override
  LabColor withAlpha(int alpha) {
    assert(alpha >= 0 && alpha <= 255);
    return LabColor(lightness, a, b, alpha);
  }

  @override
  LabColor withOpacity(double opacity) {
    assert(opacity >= 0.0 && opacity <= 1.0);
    return withAlpha((opacity * 255).round());
  }

  /// Returns this [LabColor] modified with the provided [hue] value.
  @override
  LabColor withHue(num hue) {
    assert(hue >= 0 && hue <= 360);
    final hslColor = toHslColor();
    return hslColor.withHue((hslColor.hue + hue) % 360).toLabColor();
  }

  @override
  LabColor toLabColor() => this;

  /// Constructs a [LabColor] from [color].
  factory LabColor.from(cm.ColorModel color) => color.toLabColor().cast();

  /// Constructs a [LabColor] from a list of [lab] values.
  ///
  /// [lab] must not be null and must have exactly `3` or `4` values.
  ///
  /// The first value (L) must be `>= 0 && <= 100`.
  ///
  /// The A and B values must be `>= -128 && <= 127`.
  factory LabColor.fromList(List<num> lab) {
    assert(lab.length == 3 || lab.length == 4);
    assert(lab[0] >= 0 && lab[0] <= 100);
    assert(lab[1] >= -128 && lab[1] <= 127);
    assert(lab[2] >= -128 && lab[2] <= 127);
    if (lab.length == 4) assert(lab[3] >= 0 && lab[3] <= 255);
    final alpha = lab.length == 4 ? lab[3].round() : 255;
    return LabColor(lab[0], lab[1], lab[2], alpha);
  }

  /// Constructs a [LabColor] from [color].
  factory LabColor.fromColor(Color color) =>
      RgbColor.fromColor(color).toLabColor();

  /// Constructs a [LabColor] from a [hex] color.
  ///
  /// [hex] is case-insensitive and must be `3` or `6` characters
  /// in length, excluding an optional leading `#`.
  factory LabColor.fromHex(String hex) => cm.LabColor.fromHex(hex).cast();

  /// Constructs a [LabColor] from a list of [lab] values on a `0` to `1` scale.
  ///
  /// [lab] must not be null and must have exactly `3` or `4` values.
  ///
  /// Each of the values must be `>= 0` and `<= 1`.
  factory LabColor.extrapolate(List<double> lab) {
    assert(lab.length == 3 || lab.length == 4);
    assert(lab[0] >= 0 && lab[0] <= 1);
    assert(lab[1] >= 0 && lab[1] <= 1);
    assert(lab[2] >= 0 && lab[2] <= 1);
    if (lab.length == 4) assert(lab[3] >= 0 && lab[3] <= 1);
    final alpha = lab.length == 4 ? (lab[3] * 255).round() : 255;
    return LabColor(
        lab[0] * 100, (lab[1] * 255) - 128, (lab[2] * 255) - 128, alpha);
  }

  /// Generates a [LabColor] at random.
  ///
  /// [minLightness] and [maxLightness] constrain the generated [lightness]
  /// value.
  ///
  /// [minA] and [maxA] constrain the generated [a] value.
  ///
  /// [minB] and [maxB] constrain the generated [b] value.
  ///
  /// All min and max values must be `min <= max && max >= min`, must be
  /// in the range of `>= 0 && <= 100`, and must not be `null`.
  factory LabColor.random({
    num minLightness = 0,
    num maxLightness = 100,
    num minA = 0,
    num maxA = 100,
    num minB = 0,
    num maxB = 100,
  }) {
    assert(minLightness >= 0 && minLightness <= maxLightness);
    assert(maxLightness >= minLightness && maxLightness <= 100);
    assert(minA >= 0 && minA <= maxA);
    assert(maxA >= minA && maxA <= 100);
    assert(minB >= 0 && minB <= maxB);
    assert(maxB >= minB && maxB <= 100);
    return cm.LabColor.random(
      minLightness: minLightness,
      maxLightness: maxLightness,
      minA: minA,
      maxA: maxA,
      minB: minB,
      maxB: maxB,
    ).cast();
  }
}
